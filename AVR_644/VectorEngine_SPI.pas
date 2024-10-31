Unit VectorEngine_SPI;

interface
// global part

{ $W+}                  // enable/disable warnings for this unit

uses fpga_if, global_vars;

{$PDATA}
var
  VEC_DONE[@PinB, 2]: Bit;      // Vektor fertig, F_INT
  //VEC_RESTART[@PortD, 2]: Bit;   // Vektor Engine Restart ab 0

{$IDATA}
const
// Font-Vektoren, ASCII-Zeichen 32..95
{$I simplex_font_32_95.txt}

type
  t_ve_cmd =  (ve_move_abs, ve_move_rel, ve_line_abs, ve_line_rel,
               ve_circle_deg, ve_circle_start, ve_set_offs, ve_set_rot_mid,
               ve_set_rot_deg, ve_set_scale, ve_pause, ve_skip,
               ve_stopwait, ve_jump, ve_gosub, ve_return,
               ve_beamint, ve_set_speed, ve_point);
  t_loader_cmd = (lc_set, lc_run, lc_singlerun,
               lc_fastrun, lc_nop4, lc_nop5, lc_nop6, lc_stop,
               lc_port0, lc_port1, lc_nop10, lc_nop11,
               lc_blankwidth, lc_zdelay);

{$IDATA}

var
  VE_beamoff, VE_beamlow, VE_beammid, VE_beamhi: Byte;

  VE_VecArr: Array[0..63] of Int8;   // Zwischenspeicher für Zeichen
  VE_VecArr_count[@VE_VecArr]: Int8;     // direkter Zugriff
  VE_VecArr_spacing[@VE_VecArr + 1]: Int8;

  VE_NextVector: Integer;    // fortlaufende Nummer des zuletzt hochgeladenen Vektors

  VE_temp_long: LongInt;  // Langwort

  VE_temp_w0[@VE_temp_long+0]: Word;
  VE_temp_w1[@VE_temp_long+2]: Word;

  VE_temp_i0[@VE_temp_long+0]: Integer;
  VE_temp_i1[@VE_temp_long+2]: Integer;

  VE_temp_b0[@VE_temp_long+0]: byte;
  VE_temp_b1[@VE_temp_long+1]: byte;
  VE_temp_b2[@VE_temp_long+2]: byte;
  VE_temp_b3[@VE_temp_long+3]: byte;

// #############################################################################
// ###                         DATA UPLOADER                                 ###
// #############################################################################
// Lade-Kommandos (LV_CMD = 1):
// 31 (3) 24   23 (2) 16   15 (1)  8   7  (0)  0       (In Klammern: Byte von MCU-IF)
// CCCC 0000   0000 0000   0000 PPPP   PPPP PPPP
// CCCC YYYY   YYYY YYYY   ZZZZ XXXX   XXXX XXXX - für Command 6 = direct
// C = Command, P = Parameter
// CCCC = 0 - Set Load Addr, nächste Lade-Adresse VECRAM (oder 0) in P-Wert
// CCCC = 1 - Starte Vector Engine mit Reset-State, Loop nach nächstem SYNC
// CCCC = 2 - Starte Vector Engine mit Reset-State, einmaliger Durchlauf
// CCCC = 3 - Starte Vector Engine mit Reset-State, Loop wartet nicht auf SYNC
// CCCC = 6 - Stop Vector Engine, DACs = YYYY YYYY YYYY 0ZZZ XXXX XXXX XXXX
// CCCC = 7 - Stop Vector Engine, DACs = 0
// CCCC = 8 - Set Auxiliary Port 0
// CCCC = 9 - Set Auxiliary Port 1
// CCCC = 12  Anzahl Pausentakte bei MOVE, 64 = 1,28µs, default 400 = 8µs
// CCCC = 13  Takte Delay Z
// #############################################################################

// Kommando an Loader
procedure SPI_LoaderCmd(const my_cmd: t_loader_cmd; const param: Integer);

// Setzen der Startadresse für fortlaufend geschriebenen Daten
procedure SPI_LoaderBegin(const start_adr: Integer);

// Daten an SPI übermitteln und Write/Increment auslösen
// werden ab der mit SPI_LoaderBegin gesetzten Adresse fortlaufen geschrieben
procedure SPI_LoaderWriteInc(const data32: LongInt);

// holt aktuell von VE bearbeitete Vektor-Nummer
Function SPI_GetCurrentVec: Integer;

// VE stoppen, DACs direkt setzen
procedure SPI_SetDACsDirect(const x, y: Integer; const z: Byte);

// #############################################################################
// ###                         VECTOR ENGINE                                 ###
// #############################################################################
// Vector Data (LV_INC = 1):
// 31 (3) 24   23 (2) 16   15 (1)  8   7  (0)  0       (In Klammern: Byte von MCU-IF)
// CCCC YYYY   YYYY YYYY   CCCC XXXX   XXXX XXXX
// C = Command, LSB in 15:12, MSB in 31:24
// Y = Y-Wert oder Kreisabschnitt-Ende,
// X = X-Wert, Kreis-Radius, Kreisabschnitt-Start oder Adresse
// Commands:
// 0  - Setze Startpunkt oder Kreismitte X/Y absolut
// 1  - Setze Startpunkt oder Kreismitte X/Y relativ
// 2  - Zeichne Linie nach X/Y absolut
// 3  - Zeichne Linie nach X/Y relativ, Beam Low
// 4  - Setze Kreisabschnitt (Winkel) nach X-Wert, 825 = Vollkreis
// 5  - Setze Kreis-Radius nach X-Wert und Auflösung nach Y-Wert (1..7), zeichne Kreis
// 6  - Setze Offset für nächste Objekte, X/Y
// 7  - Setze Rotations-Mittelpunkt für nächste Objekte, X/Y
// 8  - Setze Rotation für nächste Objekte um Offset-Nullpunkt, X = Winkel in 2 * pi * 128
// 9  - Setze Skalierung nach X/Y-Werten, $400 = 100%
// 10 - Pause, X-Wert * 5µs
// 11 - Dummy Cycle, NOP wenn X=0
// 12 - Stop, warte auf Reset
// 13 - Jump/Loop, Ende der Vektoren, Start wieder mit Adresse X
// 14 - Aufruf Subroutine an Adresse X
// 15 - Return aus Subroutine
// 16 - Setze Beam Intenity 0..7 (in X-Wert) für alle folgenden Draw-Funktionen
// 17 - Setze Deflection Timer XXXX XXXX XXXX 0..4095 (Vektor-Schreibgeschwindigkeit)
// 18 - Setze XY Punkt
// 19 - SKIP, Jump Relativ +X

// VEC-Datei beginnt immer mit 7 Initialisierungsvektoren:
// 0 = Skip/NOP (Objekt-Startkennung) mit X=Anzahl und Y=Animationstyp,
// 1 = Beam,
// 2 = Scale XY,
// 3 = Offset XY,
// 4 = Rotation,
// 5 = Center XY,
// 6 = Speed

// #############################################################################

Procedure VE_InitVars;
Procedure VE_Run(start_adr: Integer);
Procedure VE_SingleRun(start_adr: Integer);
Procedure VE_Stop;

Procedure VE_UploadBegin(start_adr: Integer);
Procedure VE_UploadVals(const cmd: t_ve_cmd; x_vec, y_vec: Integer);
Procedure VE_UploadLong(const long_val: LongInt);

// #############################################################################
// Basis-Funktionen mit Integer-Parameter, 12 Bit Auflösung (4096 x 4096)
// #############################################################################

procedure VE_DrawCircleSegmentAt(const x1, y1, radius, deg_start, deg_end: Integer; Const beam: Byte);

// Rotationswinkel entgegen Uhrzeigersinn, 0..803 (2 * pi * 128)!
procedure VE_SetRotationDeg(const rotation: Integer);
// etwas länger leuchtender, heller Punkt:
procedure VE_DrawPinPointAt(const x1, y1: Integer; Const beam, pause: Byte);
// etwas länger leuchtender Punkt mit letztem Pausen- und Beamwert:
procedure VE_DrawPointAt(const x1, y1: Integer);

// #############################################################################
// Basis-Funktionen mit Byte-Parameter, Werte werden mit Faktor x16 übergeben
// #############################################################################

procedure VE_SetBeamInt(const beam: Byte);
procedure VE_SetOffset_b(const x1, y1: Int8);
procedure VE_SetRotationMid_b(const x1, y1: Int8);
procedure VE_MoveTo_b(const x1, y1: Int8);

// von letztem Punkt X, Y zu neuen Koordinaten x1, y1
procedure VE_DrawLineTo_b(x1, y1: Int8; Const beam: Byte);

// 4-Quadranten-Bresenham für kurze Linien < 128
// von letztem Punkt X, Y zu neuen Koordinaten x1, y1
procedure VE_DrawLineToRel_b(x1, y1: Int8; Const beam: Byte);

procedure VE_DrawPointAt_b(const x1, y1: Int8; Const beam: Byte);
procedure VE_DrawCircleSegmentAt_b(const x1, y1, radius: Int8; deg_start, deg_end: Integer; Const beam: Byte);
procedure VE_DrawCircleAt_b(const x1, y1, radius: Int8; Const beam: Byte);
procedure VE_DrawPinPointAt_b(const x1, y1: Int8; Const beam: Byte);

// #############################################################################
// String-Ausgabe mit Hilfsroutinen, nutzt VE_VecArr
// #############################################################################

procedure VE_DrawStringAt_b(Const pos_x, pos_y: Int8; const ascii_str: String[15]; const size: Byte);
procedure VE_DrawCharAt_b(var pos_x, pos_y: Int8; const ascii_char: char; const size: Byte);
procedure VE_DrawROMvecArrRel(Const vec_rom_ptr: Pointer; const size: Byte);

procedure VE_DrawLargeROMvecArr(const vec_rom_arr: Pointer to Int8; size: Byte);

Procedure VE_CreateAllCharVecs(Const start_vec: Integer);  // TODO!

procedure VE_DefaultVectors(beam: Byte);

implementation

// var
  // VE_CharGosubs: Array[0..63] of Integer;


procedure VE_DefaultVectors(beam: Byte);
// VEC-Datei beginnt immer mit 7 Initialisierungsvektoren:
// 0 = Skip/NOP (Objekt-Startkennung) mit X=Anzahl und Y=Animationstyp,
// 1 = Beam,
// 2 = Scale XY,
// 3 = Offset XY,
// 4 = Rotation,
// 5 = Center XY,
// 6 = Speed
begin
  VE_UploadVals(ve_skip, 0, 0);      // #0
  VE_SetBeamInt(beam); // #1
  VE_UploadVals(ve_set_scale, 1024, 1024); // #2
  VE_UploadVals(ve_set_offs, 0,0);         // #3
  VE_UploadVals(ve_set_rot_deg, 0, 0);     // #4
  VE_UploadVals(ve_set_rot_mid, 0, 0);     // #5
  VE_UploadVals(ve_set_speed, 12, 0);      // #6
end;

Procedure VE_InitVars;
begin
  VE_beamoff:= EE_BeamIntensities[0];
  VE_beamlow:= EE_BeamIntensities[1];
  VE_beammid:= EE_BeamIntensities[2];
  VE_beamhi:=  EE_BeamIntensities[3];
  InvertZ:= EE_InvertZ <> false;
  BlankZ:= EE_BlankZ;

  if InvertZ then
    SPI_LoaderCmd(lc_port0, 3); // Animation 1 aktiv, invertiert
  else
    SPI_LoaderCmd(lc_port0, 1); // Animation 1 aktiv
  endif;
  SPI_LoaderCmd(lc_blankwidth, BlankZ); // Pulsweite Schwarzschulter
end;

// #############################################################################
// ###                         DATA UPLOADER                                 ###
// #############################################################################
// Lade-Kommandos (LV_CMD = 1):
// 31 (3) 24   23 (2) 16   15 (1)  8   7  (0)  0       (In Klammern: Byte von MCU-IF)
// CCCC 0000   0000 0000   0000 PPPP   PPPP PPPP
// CCCC YYYY   YYYY YYYY   ZZZZ XXXX   XXXX XXXX - für Command 6 = direct
// C = Command, P = Parameter
// CCCC = 0 - Set Load Addr, nächste Lade-Adresse VECRAM (oder 0) in P-Wert
// CCCC = 1 - Starte Vector Engine mit Reset-State, Loop nach nächstem SYNC
// CCCC = 2 - Starte Vector Engine mit Reset-State, einmaliger Durchlauf
// CCCC = 3 - Starte Vector Engine mit Reset-State, Loop wartet nicht auf SYNC
// CCCC = 6 - Stop Vector Engine, DACs = YYYY YYYY YYYY 0ZZZ XXXX XXXX XXXX
// CCCC = 7 - Stop Vector Engine, DACs = 0
// CCCC = 8 - Set Auxiliary Port 0
// CCCC = 9 - Set Auxiliary Port 1
// CCCC = 12  Anzahl Pausentakte bei MOVE, 64 = 1,28µs, default 400 = 8µs
// CCCC = 13  Takte Delay Z
// #############################################################################

procedure SPI_LoaderCmd(const my_cmd: t_loader_cmd; const param: Integer);
// AutoInc zurücksetzen, Core freigeben
begin
  FPGAreg:= $0081;
  SendFPGAreg;                    // Setze Register 128 = $80
  FPGAsendLong:= LongInt(param and $0FFF); // untere 12/16 Bytes
  FPGAsendLong3:= byte(my_cmd) shl 4;   // Befehl oberes Nibble einbauen
  SendFPGA32; // wird nach Ende der SPI-Übertragung ausgeführt
  // Upload-Register wiederherstellen
  FPGAreg:= $0080;
  SendFPGAreg;
end;

procedure SPI_SetDACsDirect(const x, y: Integer; const z: Byte);
// VE stoppen, DACs direkt setzen
Var z_int: Integer;
begin
  FPGAreg:= $0081;
  SendFPGAreg;                    // Setze Register 128 = $80
  z_int:= Integer(z);
  FPGAsendLong_int0:= (x and $0FFF) or (z_int shl 12);
  FPGAsendLong_int1:= (y and $0FFF) or $6000;  // cmd = 6
  SendFPGA32; // wird nach Ende der SPI-Übertragung ausgeführt
  // Upload-Register wiederherstellen
  FPGAreg:= $0080;
  SendFPGAreg;
end;

procedure SPI_LoaderBegin(const start_adr: Integer);
// Daten an SPI übermitteln und Write/Increment auslösen
begin
  SPI_LoaderCmd(lc_set, start_adr);
  // Upload-Register wiederherstellen
  FPGAreg:= $0080;
  SendFPGAreg;
end;

procedure SPI_LoaderWriteInc(const data32: LongInt);
// Daten an SPI übermitteln und Write/Increment auslösen
// werden ab der mit SPI_LoaderBegin gesetzten Adresse fortlaufen geschrieben
// SPI-FPGAreg muss bereits gesetzt sein!
begin
  FPGAsendLong:= data32;
  SendFPGA32;
end;

Function SPI_GetCurrentVec: Integer;
// holt aktuell von VE geladene Vektor-Nummer
// Verwenden, wenn VE_NextVector nicht mehr gültiug ist
begin
  ReceiveFPGA(0);
  // Upload-Register wiederherstellen
  FPGAreg:= $0080;
  SendFPGAreg;
  return(FPGAreceiveInt and $7FF);
end;

// #############################################################################
// ###                         VECTOR ENGINE                                 ###
// #############################################################################
// Vector Data (LV_INC = 1):
// 31 (3) 24   23 (2) 16   15 (1)  8   7  (0)  0       (In Klammern: Byte von MCU-IF)
// CCCC YYYY   YYYY YYYY   CCCC XXXX   XXXX XXXX
// C = Command, LSB in 15:12, MSB in 31:24
// Y = Y-Wert oder Kreisabschnitt-Ende,
// X = X-Wert, Kreis-Radius, Kreisabschnitt-Start oder Adresse
// Commands:
// 0  - Setze Startpunkt oder Kreismitte X/Y absolut
// 1  - Setze Startpunkt oder Kreismitte X/Y relativ
// 2  - Zeichne Linie nach X/Y absolut
// 3  - Zeichne Linie nach X/Y relativ, Beam Low
// 4  - Setze Kreisabschnitt (Winkel) nach X-Wert, 825 = Vollkreis
// 5  - Setze Kreis-Radius nach X-Wert und Auflösung nach Y-Wert (1..7), zeichne Kreis
// 6  - Setze Offset für nächste Objekte, X/Y
// 7  - Setze Rotations-Mittelpunkt für nächste Objekte, X/Y
// 8  - Setze Rotation für nächste Objekte um Offset-Nullpunkt, X = Winkel in 2 * pi * 128
// 9  - Setze Skalierung nach X/Y-Werten, $400 = 100%
// 10 - Pause, X-Wert * 5µs
// 11 - Skip/Jump relative +X oder Dummy Cycle, NOP wenn X=0
// 12 - Stop, warte auf Reset
// 13 - Jump/Loop, Ende der Vektoren, Start wieder mit Adresse X
// 14 - Aufruf Subroutine an Adresse X
// 15 - Return aus Subroutine
// 16 - Set Beam Intenity 0..15 (in X-Wert) für alle folgenden Draw-Funktionen
// 17 - Set Deflection Timer 0..4095 (Vektor-Schreibgeschwindigkeit)
// 18 - Set DAX XY Point (Punkt zeichnen mit anschließender Pause, letzter Wert aus #10)

// #############################################################################


Procedure VE_Run(start_adr: Integer);
begin
  SPI_LoaderCmd(lc_run, start_adr);
end;

Procedure VE_SingleRun(start_adr: Integer);
begin
  SPI_LoaderCmd(lc_singlerun, start_adr);
end;

Procedure VE_Stop;
begin
  SPI_LoaderCmd(lc_stop, 0);
end;

Procedure VE_UploadBegin(start_adr: Integer);
begin
  SPI_LoaderBegin(start_adr);
  VE_NextVector:= start_adr;
end;

Procedure VE_UploadLong(const long_val: LongInt);
begin
  FPGAsendLong:= long_val;
  SendFPGA32;
  inc(VE_NextVector);
end;

Procedure VE_UploadVals(const cmd: t_ve_cmd; x_vec, y_vec: Integer);
begin
  FPGAsendLong_int0:= x_vec and $FFF;
  FPGAsendLong_int1:= y_vec and $FFF;
  FPGAsendLong3:= FPGAsendLong3 or (Byte(cmd) and $F0); // MSNibble Command
  FPGAsendLong1:= FPGAsendLong1 or (Byte(cmd) shl 4);   // LSNibble Command
  SendFPGA32;
  inc(VE_NextVector);
end;

procedure VE_DrawCircleSegmentAt(const x1, y1, radius, deg_start, deg_end: Integer; beam: Byte);
// volle 12 Bit Auflösung
var
  num_points, start_point, end_point, teiler: Integer;
  frequ_shifts: Byte;
begin
  // Teiler bei 7 shifts = 128, Biquad-Multiplikator 0,0078125
  // Benötigte Punkte für Vollkreis: Teiler * 2pi
  frequ_shifts:= 4;
  if radius >= 160 then
    inc(frequ_shifts);
  endif;
  if radius >= 320 then
    inc(frequ_shifts);
  endif;
  if radius >= 640 then
    inc(frequ_shifts);
  endif;
  // inctolim(beam, 7);  // etwas mehr Helligkeit
  teiler:= (1 shl frequ_shifts);
  num_points:= muldivInt(teiler, 628, 100) +2; // * 2pi + Korrektur für vollständigen Kreis
  start_point:= muldivInt(deg_start, num_points, 360);
  end_point:= muldivInt(deg_end, num_points, 360);

  VE_UploadVals(ve_beamint, Integer(beam), 0);  // Helligkeit
  VE_UploadVals(ve_move_abs, x1, y1);
  VE_UploadVals(ve_circle_deg, start_point, end_point);   // Startpunkt oben, Anzahl Punkte
  // Kreis-Startbedingung Sinus (X-Wert = Radius), Cosinus (Y-Wert = 0)
  VE_UploadVals(ve_circle_start, radius, Integer(frequ_shifts));  // Kreis fängt oben an
end;

procedure VE_SetRotationDeg(const rotation: Integer);
// Rotationswinkel entgegen Uhrzeigersinn, 0..803 (2 * pi * 128)!
var
  rotation_val: Integer;
begin
  rotation_val:= mulDivInt(rotation, 803, 360);
  VE_UploadVals(ve_set_rot_deg, rotation_val, 0);
end;

// #############################################################################
// Funktionen mit Byte-Parameter
// #############################################################################

procedure VE_SetBeamInt(const beam: Byte);
begin
  VE_UploadVals(ve_beamint, Integer(beam), 0 );
end;

procedure VE_SetOffset_b(const x1, y1: Int8);
begin
  VE_UploadVals(ve_set_offs, Integer(x1) * 16, Integer(y1) * 16);
end;

procedure VE_SetRotationMid_b(const x1, y1: Int8);
begin
  VE_UploadVals(ve_set_rot_mid, Integer(x1) * 16, Integer(y1) * 16);
end;

procedure VE_MoveTo_b(const x1, y1: Int8);
begin
  VE_UploadVals(ve_move_abs, Integer(x1) * 16, Integer(y1) * 16);
end;

procedure VE_MoveToRel_b(const x1, y1: Int8);
begin
  VE_UploadVals(ve_move_rel, Integer(x1) * 16, Integer(y1) * 16);
end;

procedure VE_DrawLineTo_b(x1, y1: Int8; Const beam: Byte);
// von letztem Punkt X, Y zu neuen Koordinaten x1, y1
begin
  VE_UploadVals(ve_beamint, Integer(beam), 0);  // Helligkeit
  VE_UploadVals(ve_line_abs, Integer(x1) * 16, Integer(y1) * 16);
end;

procedure VE_DrawLineToRel_b(x1, y1: Int8; Const beam: Byte);
// 4-Quadranten-Bresenham für kurze Linien < 128
// von letztem Punkt X, Y zu neuen Koordinaten x1, y1
begin
  VE_UploadVals(ve_beamint, Integer(beam), 0);  // Helligkeit
  VE_UploadVals(ve_line_rel, Integer(x1) * 16, Integer(y1) * 16);
end;

procedure VE_DrawPointAt_b(const x1, y1: Int8; Const beam: Byte);
begin
  VE_MoveTo_b(x1, y1);
  VE_UploadVals(ve_beamint, Integer(beam), 0);  // Helligkeit
  VE_UploadVals(ve_line_rel, -5, -5);
  VE_UploadVals(ve_line_rel, -5, 5);
  VE_UploadVals(ve_line_rel, 5, 5);
  VE_UploadVals(ve_line_rel, -5, 5);
  VE_UploadVals(ve_line_rel, -5, -5); // Endposition
end;

procedure VE_DrawPinPointAt(const x1, y1: Integer; Const beam, pause: Byte);
begin
  VE_UploadVals(ve_beamint, Integer(beam), 0);  // Helligkeit
  VE_UploadVals(ve_point, x1, y1);
  VE_UploadVals(ve_pause, Integer(pause), 0);
end;

procedure VE_DrawPinPointAt_b(const x1, y1: Int8; Const beam: Byte);
begin
  VE_UploadVals(ve_beamint, Integer(beam), 0);  // Helligkeit
  VE_UploadVals(ve_point, Integer(x1) * 16, Integer(y1) * 16);
  VE_UploadVals(ve_pause, 20, 0);
end;

procedure VE_DrawPointAt(const x1, y1: Integer);
begin
  VE_UploadVals(ve_point, x1, y1);
end;


procedure VE_DrawCircleSegmentAt_b(const x1, y1, radius: Int8; deg_start, deg_end: Integer; beam: Byte);
begin
  VE_DrawCircleSegmentAt(Integer(x1) * 16, Integer(y1) * 16, Integer(radius) * 16, deg_start, deg_end, beam);
end;

procedure VE_DrawCircleAt_b(const x1, y1, radius: Int8; Const beam: Byte);
begin
  VE_DrawCircleSegmentAt_b(x1, y1, radius, 0, 360, beam);
end;

// #############################################################################
// String-Ausgabe mit Hilfsroutinen, nutzt VE_VecArr
// #############################################################################

procedure VE_DrawVecArrRel_b(size: Byte);
// Zeichen in abs. Vektorarray in relativen Koordinaten zeichnen,
// size in Prozent 0..255
var
  vx, vy, vcount: Int8; x_spacing: Integer;
  my_ptr: Pointer to Int8;
  vx_int, vy_int, x_abs, y_abs, x_abs_old, y_abs_old,
  x_add, y_add,
  size_int: Integer;
  pen_up, first_point: Boolean;
begin
  size_int:= Integer(size) * 16;
  x_spacing:= muldivInt(Integer(VE_VecArr_spacing), size_int, 100);
  if VE_VecArr_count = 0 then
    // Endet mit rel. Position für neues Zeichen
    VE_UploadVals(ve_move_rel, x_spacing, 0);
    return;
  endif;
  // Zeichen-Vektoren abarbeiten, in rel. Koordinaten umrechnen
  vx_int:= 0;
  vy_int:= 0;
  x_abs:= 0;
  y_abs:= 0;
  x_add:= 0;  // Addierte relative Vektoren
  y_add:= 0;
  first_point:= true;
  vcount:= 0;
  my_ptr:= @VE_VecArr[0];  // wird bei first_point um 2 erhöht!
  repeat
    x_abs_old:= x_abs;
    y_abs_old:= y_abs;
    vx:= my_ptr^++;
    vy:= my_ptr^++;
    inc(vcount);
    pen_up:= (vx = -128) or first_point;
    if pen_up then  // Pen Up, Move zum ersten oder nächsten Vektor
      vx:= my_ptr^++;
      vy:= my_ptr^++;
      inc(vcount);
    endif;
    x_abs:= muldivInt(Integer(vx), size_int, 100);
    y_abs:= muldivInt(Integer(vy), size_int, 100);
    vx_int:= x_abs - x_abs_old;
    vy_int:= y_abs - y_abs_old;
    x_add:= x_add + vx_int;
    y_add:= y_add + vy_int;
    if pen_up then
      VE_UploadVals(ve_move_rel, vx_int, vy_int);
    else
      VE_UploadVals(ve_line_rel, vx_int, vy_int);
    endif;
    first_point:= false;
  until vcount > VE_VecArr_count;
  // x inkrementiert um Spacing, y wieder auf Grundlinie
  VE_UploadVals(ve_move_rel, x_spacing-x_add, -y_add);
end;

// #############################################################################


procedure VE_DrawLargeROMvecArr(vec_rom_ptr: Pointer to Int8; size: Byte);
// size in Prozent 0..255
// Zeichen in abs. Vektorarray in absoluten Koordinaten zeichnen,
// size in Prozent 0..255
var
  vx, vy: Int8;
  vx_int, vy_int,
  vnum, vcount,
  size_int: Integer;
  pen_up, first_point: Boolean;
begin
  lo(vnum):= byte(FlashPtr(vec_rom_ptr)^++);
  hi(vnum):= byte(FlashPtr(vec_rom_ptr)^++);
  size_int:= Integer(size) * 16;
  if vnum = 0 then
    return;
  endif;
  vcount:= 0;
  first_point:= true;
  // Zeichen-Vektoren abarbeiten, abs. Koordinaten umrechnen
  repeat
    vx:= FlashPtr(vec_rom_ptr)^++;
    vy:= FlashPtr(vec_rom_ptr)^++;
    inc(vcount);
    pen_up:= (vx = -128);
    if pen_up then  // Pen Up, Move zum ersten oder nächsten Vektor
      vx:= FlashPtr(vec_rom_ptr)^++;
      vy:= FlashPtr(vec_rom_ptr)^++;
      inc(vcount);
    endif;
    vx_int:= muldivInt(Integer(vx), size_int, 100);
    vy_int:= muldivInt(Integer(vy), size_int, 100);
    if pen_up or first_point then
      VE_UploadVals(ve_move_abs, vx_int, vy_int);
    else
      VE_UploadVals(ve_line_abs, vx_int, vy_int);
    endif;
    first_point:= false;
  until vcount > vnum;
end;

procedure VE_DrawROMvecArrRel(Const vec_rom_ptr: Pointer; const size: Byte);
// size in Prozent 0..255
var
  vec_bytecount: Word;
begin
  // Anzahl Bytes 2 * Anzahl Vektoren plus 2 Bytes für VecCount & Spacing
  vec_bytecount:= (Word(FlashPtr(vec_rom_ptr)^) and $003F) * 2 + 2;
  copyBlock(FlashPtr(vec_rom_ptr), @VE_VecArr[0], vec_bytecount);
  VE_DrawVecArrRel_b(size);
end;

procedure VE_DrawCharAt_b(var pos_x, pos_y: Int8; const ascii_char: char; const size: Byte);
// size in Prozent 0..255
var cidx: Byte; vec8: Int8; ptr_offs: Word;

begin
  if ascii_char < #32 then
    return;
  endif;
  cidx:= Byte(ascii_char) - 32;
  ptr_offs:= Word(cidx) * 64;
  copyBlock(@c_SimpleFontArr + ptr_offs, @VE_VecArr[0], 64);
  VE_MoveTo_b(pos_x, pos_y);
  VE_DrawVecArrRel_b(size);
end;

procedure VE_DrawCharRelAt_b(const ascii_char: char; const size: Byte);
// size in Prozent 0..255
var cidx: Byte; vec8: Int8; ptr_offs: Word;
begin
  if ascii_char < #32 then
    return;
  endif;
  cidx:= Byte(ascii_char) - 32;
  ptr_offs:= Word(cidx) * 64;
  copyBlock(@c_SimpleFontArr + ptr_offs, @VE_VecArr[0], 64);
  VE_DrawVecArrRel_b(size);
end;

Procedure VE_DrawStringAt_b(Const pos_x, pos_y: Int8; const ascii_str: String[15]; const size: Byte);
// Liefert Breite des gezeicheneten Strings in Int8-Pixeln
var charcount: Byte;
begin
  VE_MoveTo_b(pos_x, pos_y);
  for charcount:= 1 to length(ascii_str) do
    VE_DrawCharRelAt_b(ascii_str[charcount], size);
  endfor;
end;

Procedure VE_CreateAllCharVecs(Const start_vec: Integer);
var
  count, cidx: Byte; ptr_offs: Word;
begin
  VE_UploadBegin(start_vec);
  for count:= 0 to 47 do
    ptr_offs:= Word(count) * 64;
    copyBlock(@c_SimpleFontArr + ptr_offs, @VE_VecArr[0], 64);
    VE_DrawVecArrRel_b(100);
    VE_UploadVals(ve_return, 0,0);
  endfor;
end;

initialization

end VectorEngine_SPI.

