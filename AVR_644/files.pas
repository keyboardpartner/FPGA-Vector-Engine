Unit files;

interface
// global part

{ $W+}                  // enable/disable warnings for this unit

uses   UFAT16_32, fpga_if, vectorengine_spi, global_vars;

procedure ReceiveFPGAbinary(count: LongInt);
procedure ReceiveBRAM16binary(core: Byte; count: Integer); // Anzahl Bytes (!) in count

{ functions }
Function FileLoad(const myLoadfileName: String[12]): Boolean;
Function FPGAload(myBinFileName:String[12]): Boolean;
function VectorLoad(myBinFileName:String[12]; start_vec: Integer): Boolean;

procedure CheckCard;

procedure ShowLogoFiles;
procedure ShowTestScreen;

implementation


procedure CheckCard;
begin
  if F16_DiskInit then
    F16_DiskReset;
    CardOK:=true;
  else
    CardOK:=false;
  endif;
end;

// #############################################################################

procedure ReceiveBRAM16binary(core: Byte; count: Integer); // Anzahl Bytes (!) in count
var FPGAresponse, loaded:Boolean;
  chars_read: Integer;
begin
  repeat
  until not serstat;
  LEDactivity:= low;
  chars_read:= 0;
  SendByteToFPGA(core, 129); // LC Counter Reset
  FPGAreg:= 128;     // LC Auto Inc
  SendFPGAreg;
  repeat
    repeat
    until serstat;
    lo(FPGAsendWord):= byte(serInp);
    hi(FPGAsendWord):= byte(serInp);
    SendFPGA16;
    inc(chars_read, 2);
  until chars_read >= count;
  SendByteToFPGA(core, 129);
  LEDactivity:= high;
  repeat
  until not serstat;
end;

procedure ReceiveFPGAbinary(count: LongInt);
var FPGAresponse, loaded:Boolean;
  chars_read: LongInt;
begin
  repeat
  until not serstat;
  FPGAresponse:= false;
  ReadErr:= false;
  ConfErr:= false;
  loaded:= false;
  FPGA_PROG:=low;
  udelay(1);
  FPGA_PROG:=high;
  udelay(10);     // Setup-Zeit FPGA Spartan-3
  repeat
  until not FPGA_Done;
  LEDactivity:= low;
  chars_read:= 0;
  repeat
    repeat
    until serstat;
    FPGAbyte:= byte(serInp);
    ShiftFPGAconf;
    inc(chars_read);
  until chars_read = count;
  FPGAbyte:= 255;  // Wichtig: noch ein paar CCLK-Impulse nachschieben
  ShiftFPGAconf;
  LEDactivity:= high;
end;

Function FPGAload(myBinFileName:String[12]): Boolean;
// liest Datei "FPGAn.bin" von SD- oder MMC-Karte und programmiert
// Spartan-2-FPGA über SPI damit

var firstBlock, FPGAresponse, loaded:Boolean;
  bytes_read: word;
begin
  FPGAresponse:= false;
  ReadErr:= false;
  ConfErr:= false;
  loaded:= false;
  if CardOK then
    if F16_FileExist ('\', myBinFileName, faFilesOnly) then
      F16_FileAssign (BinFile, '', myBinFileName);
      F16_FileReset (BinFile); // Datei zum Lesen öffnen
      firstBlock:=true;
      while not F16_EndOfFile (BinFile) do // read the entire file
        F16_BlockRead (BinFile, @BlockArray, 256, bytes_read);
        if firstBlock then
          FPGA_PROG:=low;
          udelay(1);
          FPGA_PROG:=high;
          mdelay(10);     // Setup-Zeit FPGA Spartan-3
          firstBlock:=false;
          // FPGA_Done muss low werden
          if not FPGA_Done then
            FPGAresponse:=true;
          endif;
        endif;
        ShiftFPGAconfblock;
        if FPGA_Done then
          break;
        endif;
      endwhile; // until end of file
      loaded:= true;
      FPGAbyte:= 255;  // Wichtig: noch ein paar CCLK-Impulse nachschieben
      ShiftFPGAconf;
      F16_FileClose (BinFile);
      if (not FPGAresponse) or (not FPGA_Done) then
        ConfErr:=true;
      endif;
    else
      ReadErr:=true;
    endif;
  endif;
  if loaded then
    write(SerOut,'/ FPGA Load OK');
    SerCRLF;
  else
    write(SerOut,'/ ERR: FPGA not loaded!');
    SerCRLF;
  endif;
  return(loaded);
end;

{
// Lesen von SD viel zu langsam!
Function DACload(myBinFileName:String[12]): Boolean;
// Übermittelt WAV-Datei an DAC AD5447 über SPI
var
  block_val: LongInt;
  block_count: Byte;
  bytes_read: Word;
begin
  if CardOK then
    VE_Stop;
    VE_UploadBegin(0); // ab Adresse 0
    VE_SetBeamInt(c_beammid);
    VE_UploadVals(ve_pause, 0, 1);
    if F16_FileExist ('\', myBinFileName, faFilesOnly) then
      ReadErr:= false;
      F16_FileAssign (BinFile, '', myBinFileName);
      F16_FileReset (BinFile); // Datei zum Lesen öffnen
      while not F16_EndOfFile (BinFile) do // read the entire file
        F16_BlockRead(BinFile, @BlockArray, 256, bytes_read);
        VE_UploadBegin(2); // ab Adresse 2
        for i:= 0 to 63 do
          VE_temp_long:= BlockArray4[i];
          VE_UploadVals(ve_point, VE_temp_i0 shr 4, VE_temp_i1 shr 4);
        endfor;
        VE_UploadVals(ve_stopwait, 0, 0);
        VE_SingleRun(0);
        repeat
        until VEC_DONE;
      endwhile; // until end of file
      F16_FileClose (BinFile);
    else
      if LCDpresent then
        LCDxy_M(LCD_m1, 0, 0);
        Write(LCDOut_M, 'NotFound');
        setsystimer(DisplayTimer,200);
      endif;
      ReadErr:= true;
    endif;
  endif;
  NoCard:= not CardOK;
  return(CardOK and (not ReadErr));
end;
}

function VectorLoad(myBinFileName:String[12]; start_vec: Integer): Boolean;
// Liest Speicherinhalt Vektor-RAM von SD und schreibt diesen in VE
// ab start_vec, max. 1024 LongWords (4 KByte)
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
// 16 - Setze Beam Intenity 0..7 (in X-Wert) für alle folgenden Draw-Funktionen
// 17 - Setze Deflection Timer XXXX XXXX XXXX 0..4095 (Vektor-Schreibgeschwindigkeit)
// 18 - Setze XY Punkt

// Vektor-Datei kann für jedes Vektor-Objekt eine eigene Init-Sequenz enthalten,
// die bei VectorLoad() FileObjects-Einträge erzeugt und FileObjectCount
// auf die Anzahl der gefundenen Objekte setzt.

// VEC-Datei beginnt immer mit 7 Initialisierungsvektoren:
// 0 = Skip/NOP (Objekt-Startkennung) mit X=Anzahl und Y=Animationstyp,
// 1 = Beam,
// 2 = Scale XY,
// 3 = Offset XY,
// 4 = Rotation,
// 5 = Center XY,
// 6 = Speed

var
  cmd_mask: LongWord;
  idx_w, bytes_read: Word;
  my_vec: Integer;
  is_nop, is_skip, is_beam, obj_started: Boolean;
begin
  ReadErr:= true;
  FileObjectCount:= 0;
  FillBlock(@FileObjects, sizeof(FileObjects), 0);
  FileVecs.vecupd_start:= start_vec;
  obj_started:= false;
  if CardOK then
    if F16_FileExist ('\', myBinFileName, faFilesOnly) then
      VE_Stop;
      VE_UploadBegin(start_vec); // ab Adresse, setzt VE_NextVector
      my_vec:= start_vec;
      ReadErr:= false;
      F16_FileAssign(BinFile, '', myBinFileName);
      F16_FileReset(BinFile); // Datei zum Lesen öffnen
      while not F16_EndOfFile (BinFile) do // read the entire file
        F16_BlockRead(BinFile, @BlockArray, 256, bytes_read);
        for idx_w:= 0 to (bytes_read div 4) - 1  do
          FPGAsendLong:= BlockArray4[idx_w];
          cmd_mask:= FPGAsendLong and $F000F000;
          is_skip:= cmd_mask = $10003000;
          is_nop:=  cmd_mask = $0000B000;
          is_beam:= cmd_mask = $10000000;
          if is_beam and obj_started and (FileObjectCount > 0) then
            // Wenn BEAM auftaucht, wurde FileObjectCount bereits erhöht
            FileObjects[FileObjectCount - 1].beam:= FPGAsendLong0; // X-Wert LSB
            obj_started:= false; // falls einzelnes BEAM kommt
          endif;
          if is_skip or is_nop then
            FileObjects[FileObjectCount].skip:= Integer(FPGAsendLong and $0FFF); // X-Wert
            FileObjects[FileObjectCount].anim_type:= Byte(FPGAsendLong shr 16); // Y-Wert
            FileObjects[FileObjectCount].vecupd_start:= my_vec; // VE_BeginUpload-Adresse
            FileObjects[FileObjectCount].x_scale:= 1024; // auf 100% initialisieren
            FileObjects[FileObjectCount].y_scale:= 1024;
            FPGAsendLong:= $0000B000; // Zunächst auf NOP (X=0)setzen
            inc(FileObjectCount);
            obj_started:= true;
          endif;
          SendFPGA32;
          inc(my_vec);
        endfor;
      endwhile; // until end of file
      // FileObjectCount enthält jetzt Anzahl Objekte in FileObjectArr oder 0
      F16_FileClose (BinFile);
      write(SerOut,'/ Loaded "' + myBinFileName + '", Objects: ');
      write(SerOut, ByteToStr(FileObjectCount));
      SerCRLF;
    else
      write(SerOut,'/ ERR: File "' + myBinFileName + '" not found!');
      SerCRLF;
    endif;
    FileVecs.vecupd_end:= my_vec; // nach letzten File-Vektor
    VE_UploadBegin(my_vec);  // weiter mit Ende der Bildvektoren
    // Starten mit VE_Run(0) oder VE_SingleRun(0)
  endif;
  return(not ReadErr);
end;


Function FileLoad(const myLoadfileName: String[12]): Boolean;
// lädt File je nach Extension in das FPGA oder ins AutoInc-RAM
var
  myFileName: String[12];
  myFileExt: String[3];  // myFileName: String[8];
  loaded: Boolean;
begin
  myFileName:= UpperCase(myLoadfileName);
  myFileExt:=ExtractFileExt(myFileName);
  // myFileName:=ExtractFileName(myLoadfileName);
  LEDactivity:=low;
  write(SerOut,'/ Loading "' + myFileName + '"...');
  SerCRLF;
  loaded:= false;
  if (myFileExt='BIN') or (myFileExt='BIT') then
    loaded:= FPGAload(myFileName);
    if (myFileName = 'AST_CLK.BIT') then
      VE_InitVars;
      InitSPI;
      VE_Stop;
      if InvertZ then
        SPI_LoaderCmd(lc_port0, 3); // Clock aktiv, inverses Z
      else
        SPI_LoaderCmd(lc_port0, 1); // Clock aktiv
      endif;
      write(SerOut,'/ Init ScopeClock...');
      SerCRLF;
      BoardMode:= board_asteroids;
      State:= s_initclock;
    endif;
  endif;
  if (BoardMode = board_asteroids) and (myFileExt='VEC') then
    InvertZ:= EE_InvertZ <> false;
    if InvertZ then
      SPI_LoaderCmd(lc_port0, 3); // Clock aktiv, inverses Z
    else
      SPI_LoaderCmd(lc_port0, 1); // Clock aktiv
    endif;
    loaded:= VectorLoad(myFileName, 0);
    VE_UploadVals(ve_stopwait, 0, 0);
    VE_Run(0);
    State:= s_stationaryscreen;   // Vektor-Updates verhindern
  endif;
{
  if myFileExt='WAV' then
    DACload(myLoadfileName);
    myReadErr:=ReadErr;
  endif;
}
  return(loaded);
end;

// #############################################################################

procedure ShowLogoFiles;
begin
  for LogoNr:= 0 to 19 do
    if not VectorLoad('LOGO_' + ByteToStr(LogoNr) + '.VEC', 0) then
      break;
    endif;
    VE_SetBeamInt(ve_beamhi);
    VE_DrawStringAt_b(-100, -100, 'L' + ByteToSTr(LogoNr), 100);
    VE_UploadVals(ve_stopwait, 0, 0);
    VE_Run(0);
    mdelay(500);
  endfor;
  for AnimNr:= 0 to 19 do
    if not VectorLoad('ANIM_' + ByteToStr(AnimNr) + '.VEC', 0) then
      break;
    endif;
    VE_SetBeamInt(ve_beamhi);
    VE_DrawStringAt_b(-100, -100, 'A' + ByteToSTr(AnimNr), 100);
    VE_UploadVals(ve_stopwait, 0, 0);
    VE_Run(0);
    mdelay(500);
  endfor;
  VectorLoad('SPLASH.VEC', 0);
  VE_SetBeamInt(ve_beamhi);
  VE_DrawStringAt_b(-100, -100, 'SPLASH', 75);
  VE_UploadVals(ve_stopwait, 0, 0);
  VE_Run(0);
  mdelay(500);
  LogoNr:= 0;
  AnimNr:= 0;
  State:= s_initclock;
end;

procedure ShowTestScreen;
begin
  VectorLoad('TEST.VEC', 0);
  VE_SetBeamInt(ve_beamhi);
  VE_DrawStringAt_b(-100, -100, 'TEST', 75);
  VE_UploadVals(ve_stopwait, 0, 0);
  VE_Run(0);
  mdelay(500);
  LogoNr:= 0;
  State:= s_stationaryscreen;
end;


end files.

