Unit global_vars;

interface
// global part

{ $W+}                  // enable/disable warnings for this unit
// #############################################################################

//EEPROM-Routinen
uses rtc_maxim;

procedure InitVars;

procedure DateTimeToDOS;
procedure TimeToParamStr;
procedure DateToParamStr;

procedure SerCRLF;

type
  t_boardmode = (board_none, board_asteroids, board_invaders);
  tModify   = (param0, param1, param2, param3, input0, input1, input2, input3, filesel);
  tError = (NoErr, UserReq, BusyErr, FileErr, SyntaxErr, ParamErr, LockedErr, ChecksumErr);

  t_state = (s_initclock, s_updateclock, s_anim, s_anim_1, s_anim_2, s_anim_3, s_msgscreen,
             s_initasteroids, s_asteroids, s_stationaryscreen);
  t_sequstate = (s_sequ_init, s_sequ_1, s_sequ_2,
             s_sequ_3, s_sequ_4, s_sequ_end);
  t_setmode = (s_run, s_year, s_month, s_day, s_weekday, s_daysleft,
               s_hour, s_minute, s_second);
  t_ufomode = (ufo_invisible, ufo_new, ufo_moving, ufo_placeshoot, ufo_shootactive, ufo_flarenew, ufo_flareactive, ufo_flareend, ufo_end);

  t_animobject = Record
    // Ggf. direkt an Vector Engine zu übermittelnde Werte
    x_pos, y_pos: Integer;      // absolute Position des Objekts (Offset zur Mitte)
    x_scale, y_scale: Integer;  // Skalierung des Objekts
    rotation: Integer;          // Rotation in Grad entgegen Uhrzeigersinn
    // In Zeichenroutine verwendete Werte
    visible: Boolean;           // sichtbar/unsichtbar
    x_inc, y_inc, rot_inc: Integer;      // Geschwindigkeitsvektor bei bewegten Objekten
    timer: Integer;                 // Alle n Systicks ausführen, z.B. für Logos
    timecount1: Integer;            // Timer 1 z.B. für Schuss-Dauer
    timecount2: Integer;            // Timer 2 z.B. für Richtungsänderung
    timeout1: Integer;              // z.B. Zufallswert für Schuss-Dauer
    timeout2: Integer;              // z.B. Zufallswert für Richtungsänderung
    trigger: Boolean;
    damage_level: Byte;            // Stufe der "Beschädigung"
    // Start und Ende der erzeugten Vektoren für Update-Routine merken
    vecupd_start, vecupd_redraw, vecupd_end: Integer;
  end;

  t_clockobject = Record
    // einfache Objekt-Version für Ziffernblatt
    rotation: Integer;          // Rotation in Grad entgegen Uhrzeigersinn
    // Start und Ende der erzeugten Vektoren für Update-Routine merken
    vecupd_start, vecupd_end: Integer;
  end;

  t_fileobject = Record
    // Start und Ende der erzeugten Vektoren für Update-Routine merken
    vecupd_start, vecupd_end: Integer;
  end;

  t_pendulumobject = Record
    // einfachere Objekt-Version für Pendel
    rotation: Integer;          // Rotation in Grad entgegen Uhrzeigersinn
    rot_inc: Integer;           // Geschwindigkeitsvektor bei bewegten Objekten
    timecount1: Integer;           // Timer 1 z.B. für Pendel
    timer: Integer;                // Alle n Systicks ausführen, z.B. für Pendel
    // Start und Ende der erzeugten Vektoren für Update-Routine merken
    vecupd_start, vecupd_end: Integer;
  end;

  t_simpleobject = Record
    // VEC-Datei beginnt immer mit 7 Initialisierungsvektoren:
    // Skip/NOP, Beam, Scale XY, Offset, Rotation, Center XY, Speed
    // Ggf. direkt an Vector Engine zu übermittelnde Werte
    skip: Integer;              // Zu überspringende Vektoren falls unsichtbar
    beam, anim_type: Byte;            // Animationsart, Y-Wert in SKIP - TBD!
    x_offs, y_offs: Integer;    // Position des Objekts (Offset zur Mitte)
    x_scale, y_scale: Integer;  // Skalierung des Objekts
    rotation: Integer;          // Rotation in Grad entgegen Uhrzeigersinn
    x_scale_inc, y_scale_inc,   // Skalierungs-Delta bei bewegten Objekten
    x_inc, y_inc,               // Positions-Delta bei bewegten Objekten
    rot_inc: Int8;              // Rotations-Delta bei bewegten Objekten
    vecupd_start: Integer;      // Adresse erster/letzer+1 Vektor
  end;

  t_position = Record
    x_offs, y_offs: Integer;    // Position des Objekts (Offset zur Mitte)
  end;

{--------------------------------------------------------------}
const
{$TYPEDCONST OFF}

  Vers1Str    = '2.80 [FPGA by CM 09/2024]';    //Vers1
  Vers3Str    = 'FPGA 2.8';    // Kurzform von Vers1

  ErrStrArr      : array[0..7] of String[8] = (
    '[OK]','[SRQUSR]','[BUSY]','[FILERR]','[CMDERR]','[PARERR]',
    '[LOCKED]','[CHKSUM]');

  FaultStrArr : array[0..3] of String[10] = (
    '[NOTFOUND]',
    '[NOCARD]',
    '[CONFERR]',
    '[WRITERR]');


  EEnotProgrammedStr         = 'EEPROM EMPTY! ';
  AdrStr                     = 'Adr ';
  ParamHintStr               = 'Param  ';
  InputHintStr               = 'Value  ';
  EvalHintStr                = 'DataAdr';
  RunStr1                    = 'BTN:STOP';
  RunStr2                    = 'INI exec';
  FileNumStr                 = ' file';
  ErrSubCh: Integer          = 255;

  CmdStrArr: array[0..13] of String[3] = (
  'STR', // 255
  'IDN', // 254
  'VAL', // 0..9999
{--------------------------------------------------------------}
// Script-Befehle
  'DIR', // 241 Dir Listing
  'FNM', // 242 FileNumber, Anzahl der Dateien
  'FNA', // 243 Data FileName (alpha)
  'FDL', // 244 Delete DataFileName (alpha)
  'FQU', // 249 File Query, OK/Exists
  'HEX', // 88  Hex-Mode bei Zahlenausgeben seriell [$12345678]
  'WEN', // 250 Write enable
  'ERC', // 251 ErrCount seit letztem Reset
  'SBD', // 252 SerBaud UBRR-Register mit U2X=1
  'REM', // 253
  'NOP');

  Cmd2SubChArr: array[0..13] of integer = (
  255, 254,
  0,
  241, 242, 243, 244, 249,
  88, 250, 251, 252, 253, 253);

  cmdAnzahl=65; // letzter Eintrag, statt tCmdwhich
  cmdErr=cmdAnzahl+1; // Error, Statt tCmdwhich

  high: Boolean = true;
  low: Boolean = false;

//Inkrementalgeber-Beschleunigungstabelle
  IncrAccArray: array[0..15] of integer = (0,1,2,5,10,25,50,100,250,
  500,1000,2500,5000,10000,10000,10000);

  IncrDigitArray: array[0..7] of LongInt = (
  $10000000,$01000000,$00100000,$00010000,
  $00001000,$00000100,$00000010,$00000001);

// Button Panel(s)
  PCA9532_0      : Byte      = $60; // Upper Voice
  PCA9532_1      : Byte      = $61; // Lower Voice
  PCA9532_2      : Byte      = $62; // Panel16 onboard
  PCA9532_3      : Byte      = $63; // ext. Panels
  PCA9532_4      : Byte      = $64;
  PCA9532_5      : Byte      = $65;
  PCA9532_6      : Byte      = $66;
  PCA9532_7      : Byte      = $67; // auch XB2!

structconst

//Default-EEPROM-Werte:
{$EEPROM}
  EE_dummy:LongInt = 0;
  EE_initialised:word = $AA55;

  EE_OptionArray:Array[0..19] of Integer =  (
  255,  // 200 BIN-File Default, 255=keine
  255,  // 201 INI-File Default
  0,    // 202 AutoIncSel, default 0
  128,  // 203 AutoIncReg, default 128
  0,    // 204
  0,    // 205
  4,    // 206 EE_InitIncRast
  51,   // 207 EE_SerBaudReg
  0,    // 208 EE_MainCh
  500,  // 209
  255,  // 210 EE_h24mode
  0,    // 211
  0,    // 212
  0,    // 213
  0,    // 214
  0,    // 215
  0,    // 216
  0,
  0,
  0);

  EE_InitFileName:String[15] = 'AST_CLK.BIT';

  EE_DestDayCount : Integer = 8582; // Tage seit 1.1.2000
//Default-EEPROM-Werte:
{--------------------------------------------------------------}

var
{$EEPROM}

  EE_BinFileNum[@EE_OptionArray+0]:integer;      // unused!
  EE_IniFileNum[@EE_OptionArray+2]:integer;      // INI-FileNum -1 (kein INI-File)
  EE_AutoIncSel[@EE_OptionArray+4]:integer;      // Default AutoIncSel
  EE_AutoIncReg[@EE_OptionArray+6]:integer;      // Default AutoIncReg

  EE_InitIncRast[@EE_OptionArray+12]:Integer;
  EE_SerBaudReg[@EE_OptionArray+14]:Integer;
  EE_MainCh[@EE_OptionArray+16]:integer;

  EE_InitParamLongArray: array[0..3] of LongInt;

structconst
{$EEPROM}
  EE_InvertZ[@EE_InitParamLongArray + 0]: Boolean = false;
  EE_BlankZ[@EE_InitParamLongArray + 4]: Integer = 4;
  EE_BeamIntensities[@EE_InitParamLongArray + 8]:Array[0..3] of Byte =  (
  0,    // Beam OFF
  10,    // Beam LOW
  12,    // Beam MID
  15     // Beam HI
  );


{$DATA} {Schnelle Register-Variablen}
var
  i, k, n: Byte;
  m: Int8;

{$IDATA}  {Langsamere SRAM-Variablen}


var
  BoardMode: t_boardmode;
  Ufo, Shoot, Flare: t_animobject;
  UfoMode: t_ufomode;
  UfoActive, ShootFlareActive: Boolean;

  FileVecs: t_fileobject;
  // Falls File mit Einzelobjekten (eigene Init-Params)
  FileObjects: Array[0..39] of t_simpleobject;
  FileObjectSavedBeams: Array[0..39] of Byte; // Zwischenspeicher für Animationen
  FileObjectCount: Byte;
  AnimationNr: Byte;

  LogoNr, AnimNr: Byte;

  InvertZ: Boolean;
  InvertZ_Mask: Integer;
  BlankZ: Integer;

  MainCh: byte;
  ButtonTemp,RangeTemp: Byte; // invertiert - low=on!
  ButtonDown[@ButtonTemp, 5]  : bit;
  ButtonUp[@ButtonTemp, 4]  : bit;
  ButtonEnter[@ButtonTemp, 3]  : bit;

  LEDtimer:Systimer8;

  CmdWhich: byte; // tcmdwhich nicht mehr benutzt
  CmdStr: string[3];
  SubCh: Integer;
  OmniFlag, verbose: boolean;
  ParamInt:  Integer;
  ParamAlpha: boolean; // Flag für Zeichenfolge hinter "="
  ParamLong: LongInt;
  ParamByte :Byte;

  SerInpStr : String[31];
  SerInpPtr: byte;

  SysTickSema, ButtonsPresent: boolean;


//für Parser
  ParamStr: string[31]; // auch für Display
  isInteger, Request: boolean;
  Status: byte;  // 0..3 Fehlernummer
  BusyFlag[@Status, 7]: bit;
//  UserSRQFlag[@Status, 6]: bit;
  FileErrorFlag[@Status, 5]: bit;  //
  // EEUnlocked[@Status, 4]: bit; // EEPROM-unlocked-Flag

{  FaultStrArr : array[0..3] of String[10] = (
    '[READERR]',
    '[NOCARD]',
    '[CONFERR]',
    '[WRITERR]');  }

  FaultFlags: byte;
  ReadErr[@FaultFlags, 0]  : bit;

  ConfErr[@FaultFlags, 2]  : bit;
  WriteErr[@FaultFlags, 3]  : bit;

  ErrCount:integer;
  ErrFlag:boolean;

  ParseResult: Boolean;
  Pause: word;

  AutoIncReg:byte;         // Auto-Increment-Register, hierhin werden .DAT-Datenblöcke geschrieben
  AutoIncSel:byte;         // Auto-Increment-Select
  AutoIncWidth:byte;       // AI Breite in Bytes, 1, 2 oder 4
// Real Time Clock RTC
  DOStime, DOSdate: Word;

  pDummy:byte;

  AutoIncBlockEnd, AutoIncBlockStart: LongInt;

  CardOK: boolean;

  BinFile : file of byte;

  State: t_state;
  SetMode: t_setmode;

implementation
// #############################################################################


procedure InitVars;
//Frequenz und Settings aus EEPROM holen
begin
  ParamStr:='0';
  AutoIncReg:=byte(EE_AutoIncReg);
  AutoIncSel:=byte(EE_AutoIncSel);
  AutoIncWidth:=4;
end;


procedure DateTimeToDOS;
{ DOS time format bits:
DOStime: 15..11=Hours (0-23), 10..5=Minutes (0-59), 4..0=Seconds/2 (0-29)
DOSdate: 15..9=Year (0=1980, 127=2107), 8..5=Month (1=January, 12=December),
4..0=Day (1-31) }
begin
  DS_GetTime(second, minute, hour);
  DS_GetDate(weekday, day, month, year);
  DOStime:= (word(Hour) shl 11) or (word(Minute) shl 5) or (word(Second) shr 1);
  DOSdate:= (word(Year+20) shl 9) or (word(Month) shl 5) or (word(Day));
end;

procedure TimeToParamStr;
begin
  ParamStr:= byteToStr(Hour:2:'0')+':'+byteToStr(Minute:2:'0')+':'+byteToStr(Second:2:'0');
end;

procedure DateToParamStr;
begin
  ParamStr:= byteToStr(Day:2:'0')+'.'+byteToStr(Month:2:'0')+'.'+byteToStr(Year:2:'0');
end;


procedure SerCRLF;
begin
  SerOut(#$0D);
  SerOut(#$0A);
end;


end global_vars.

