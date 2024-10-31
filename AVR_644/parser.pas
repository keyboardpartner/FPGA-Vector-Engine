Unit parser;

interface

uses fpga_if, global_vars, vectorengine_spi, files;

// #############################################################################
// gekürzte Parser-Version ohne Script!
procedure ParseGetParam;
procedure ParseSetParam;
procedure ParseSubCh;

// #############################################################################
//Ausgabe-Prozeduren

procedure WriteIntSer(aInt: Integer);

procedure ParamIntToStr;
procedure ParamLongToStr;
procedure ParamLongToHex;
procedure ParamIntToHex;
procedure WriteParamStrSer;
procedure WriteParamIntSer;
procedure WriteParamByteSer;
procedure WriteParamHexSer;    // für verbose-Anfrage
procedure WriteParamLongSer;

procedure WriteChPrefix;
procedure WriteSerInp;
procedure SerPrompt(myErr:tError);

function CheckSer: Boolean;
function Chores: Boolean;
function ChoresDelay(timeout: Integer): Boolean;

implementation


// #############################################################################
// Ausgabe-Prozeduren
// #############################################################################


procedure WriteChPrefix;
begin
  SerOut('#');
end;

procedure WriteSerInp;
begin
  write(SerOut, SerInpStr);   // Befehl weiterreichen
  SerCRLF;
end;

procedure SerPrompt(myErr:tError);
var myFault, myStatus:Byte;
//Error-Meldung und Status-Request-Antwort,
//Status Bit 7=Busy, 6=UserSRQ, 5=OverLoad, 4=WriteEnable, 3..0=Fault/Error
begin
  SubCh:= ErrSubCh; // Fehler-Kanal
  WriteChPrefix;
  FileErrorFlag:=(FaultFlags<>0);
  if FileErrorFlag then
    myStatus:=Status or FaultFlags;
  else
    myStatus:=Status or ord(myErr);
    if myErr <> noErr then
      inc(ErrCount);
    endif;
  endif;
  write(SerOut, ByteToStr(myStatus));
  if FileErrorFlag then
    myFault:=FaultFlags;
    for i := 0 to 3 do
      if (myFault and 1) = 1 then
        SerOut(#32);
        write(SerOut,FaultStrArr[i]);
      endif;
      myFault:=myFault shr 1;
    endfor;
  endif;
  SerOut(#32);
  write(SerOut,ErrStrArr[ord(myErr)]);
  SerCRLF;
end;

procedure ParamIntToStr;
begin
  ParamStr:=IntToStr(ParamInt);
end;

procedure ParamLongToStr;
//mit einer Nachkommastelle in String wandeln
begin
  ParamStr:=LongToStr(ParamLong);
end;

procedure ParamLongToHex;
//Longint in Hex-String wandeln
begin
  ParamStr:=LongToHex(ParamLong);
end;

procedure ParamIntToHex;
//Integer in Hex-String wandeln
begin
  ParamStr:=IntToHex(ParamInt);
end;

procedure WriteParamStrSer;
begin
  WriteChPrefix;
  write(SerOut, ParamStr);
  SerCRLF;
end;


procedure WriteParamIntSer;
begin
  ParamStr:= IntToStr(ParamInt);
  WriteParamStrSer;
end;

procedure WriteIntSer(aInt: Integer);
begin
  ParamStr:= IntToStr(aInt);
  WriteParamStrSer;
end;

procedure WriteParamByteSer;
begin
  ParamStr:= ByteToStr(ParamByte);
  WriteParamStrSer;
end;

procedure WriteParamHexSer;    // für verbose-Anfrage
begin
  WriteChPrefix;
  ParamLongToStr;
  write(SerOut, ParamStr);
  SerOut(#32);
  SerOut('[');
  SerOut('$');
  ParamStr:= LongToHex(ParamLong);
  write(SerOut, ParamStr);
  SerOut(']');
  SerCRLF;
end;

procedure WriteParamLongSer;
begin
  ParamStr:= LongToStr(ParamLong);
  WriteParamStrSer;
end;

// #############################################################################
// gerätespezifischer Parser-Teil
// #############################################################################

procedure ParseGetParam;
var IntInOutFlag:boolean;
    myBranch:boolean;
    myByte:byte;
    myIndex:Byte;

begin
  myIndex:=byte(SubCh mod 10);  // angespr. Register 0..9 errechnen aus SubCh-Rest
  case SubCh of
    0..3:
      ParamLong:= ReceiveFPGA(lo(SubCh));
      WriteParamHexSer;
      |
    4..79:
      ParamLong:= ReceiveFPGA(lo(SubCh));
      WriteParamLongSer;
      |
    128:
      ParamInt:= SPI_GetCurrentVec;
      WriteParamIntSer;
      |
    230..233:
      DS_GetTime(second, minute, hour);
      ParamByte:= TimeDateArr[myIndex];
      WriteParamByteSer;
      |
    234..237:
      DS_GetDate(weekday, day, month, year);
      ParamByte:= TimeDateArr[myIndex];
      WriteParamByteSer;
      |
    200..219:
      ParamInt:= EE_OptionArray[SubCh-200];
      WriteParamIntSer;
      |
    220..223:
      ParamByte:= EE_BeamIntensities[myIndex];
      WriteParamByteSer;
      |
    224:
      ParamInt:= EE_BlankZ;
      WriteParamIntSer;
      |
    225:
      ParamByte:= byte(EE_InvertZ);
      WriteParamByteSer;
      |
    240:
      WriteChPrefix;
      write(SerOut, '0 ['+ EE_initFileName+']');
      SerCRLF;
      |
    253: // SerTest, gibt Input-String komplett und unverändert wieder aus
      write(SerOut, SerInpStr);
      SerCRLF;
      |
    254: // Version
      WriteChPrefix;
      write(SerOut,Vers1Str);
      SerCRLF;
      |
    255: // Status
      serprompt(NoErr);
      |
    990:
      CheckCard;
      SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Vector Engine aktiv
      State:= s_initclock;
      Ufo.trigger:= true;
      serprompt(NoErr);
      |
    991:
      CheckCard;
      SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Vector Engine aktiv
      State:= s_anim_1;
      serprompt(NoErr);
      |
    992:
      CheckCard;
      SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Vector Engine aktiv
      State:= s_anim_2;
      serprompt(NoErr);
      |
    993:
      CheckCard;
      SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Vector Engine aktiv
      State:= s_anim_3;
      serprompt(NoErr);
      |
    994:
      CheckCard;
      SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Vector Engine aktiv
      State:= s_msgscreen;
      serprompt(NoErr);
      |
    995:
      CheckCard;
      SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Vector Engine aktiv
      ShowLogoFiles;
      State:= s_initclock;
      serprompt(NoErr);
      |
    996:
      CheckCard;
      SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Vector Engine aktiv
      ShowTestScreen;
      State:= s_initclock;
      serprompt(NoErr);
      |
    997:
      CheckCard;
      SPI_LoaderCmd(lc_port0, InvertZ_Mask); // Asteroids aktiv
      State:= s_initasteroids;
      serprompt(NoErr);
      |
    999:
      serprompt(NoErr);
      System_Reset;
      |
  else
    serprompt(ParamErr);
  endcase;
end;

// #############################################################################

procedure ParseSetParam;
var myByte:byte;
    myIndex:Byte;
    myBranch:boolean;
    cmd: t_ve_cmd;
    x_vec, y_vec: Integer;

begin
  myIndex:= byte(SubCh mod 10);  // angespr. Register 0..9 errechnen aus SubCh-Rest
  case SubCh of
    0..127:
      SendLongToFPGA(ParamLong, lo(SubCh));
      |
    128..131:  // Default-Auto-Increment-Register
      FPGAreg:=Word(SubCh);
      SendFPGAreg;
      FPGAsendLong:=ParamLong;
      SendFPGA32;
      |
    140:  // send VE_UploadBegin (ParamInt)
      State:= s_stationaryscreen;
      VE_Stop;
      VE_UploadBegin(ParamInt);
      |
    141:  // send encoded VE command
      // 31 (3) 24   23 (2) 16   15 (1)  8   7  (0)  0       (In Klammern: Byte von MCU-IF)
      // CCCC YYYY   YYYY YYYY   CCCC XXXX   XXXX XXXX
      // C = Command, LSB in 15:12, MSB in 31:24
      // Y = Y-Wert oder Kreisabschnitt-Ende,
      // X = X-Wert, Kreis-Radius, Kreisabschnitt-Start oder Adresse
      VE_UploadLong(ParamLong);
      |
    142:  // send VE_Run (ParamInt)
      State:= s_stationaryscreen;
      VE_UploadVals(ve_stopwait, 0, 0);
      VE_Run(ParamInt);
      |
      |
    200..219:
      EE_OptionArray[SubCh-200]:= ParamInt;
      InitVars;
      |
    220..223:
      EE_BeamIntensities[myIndex]:= ParamByte;
      VE_InitVars;
      State:= s_initclock;
      Ufo.trigger:= true;
      |
    224:
      EE_BlankZ:= ParamInt;
      VE_InitVars;
      |
    225:
      EE_InvertZ:= ParamByte <> 0;
      VE_InitVars;
      |
    230..233:
      TimeDateArr[myIndex]:= ParamByte; // sec, min, h
      SetRTCtime;
      DS_SetTime(second, minute, hour);
      State:= s_startup;
      |
    234..237:
      TimeDateArr[myIndex]:= ParamByte; // weekday, day, month, year
      SetRTCdate;
      DS_SetDate(weekday, day, month, year);
      State:= s_startup;
      |
    240:
      EE_InitFileName:= ParamStr;
      FileLoad(EE_initFileName);
      if FaultFlags<>0 then
        serprompt(FileErr);
        return;
      endif;
      |
    251: //Error-Count
      ErrCount:=ParamInt;
      |
    253: // SerTest, gibt Input-String komplett und unverändert wieder aus
      write(SerOut, SerInpStr);
      SerCRLF;
      return;
      |
    280: //AutoIncrement-Register für DAT-Files
      AutoIncReg:= ParamByte;
      |
    281: //AutoIncrement-Select (AUX-Select auf SubCh <AutoIncReg> für DAT-Files
      AutoIncSel:= ParamByte;
      |
    282:  //  Auto-Increment-Registerbreite im SPI, Anzahl Bytes (1, 2 oder 4)
      AutoIncWidth:=ParamByte;
      |
    300..399:
      ReceiveBRAM16binary(byte(SubCh-300), ParamInt);
      |
    400:
      ReceiveFPGAbinary(ParamLong);
      |

    991:
      CheckCard;
      SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Vector Engine aktiv
      AnimNr:= ParamByte;
      State:= s_anim_1;
      |
    992:
      CheckCard;
      SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Vector Engine aktiv
      LogoNr:= ParamByte;
      State:= s_anim_2;
      |
    993:
      CheckCard;
      SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Vector Engine aktiv
      LogoNr:= ParamByte;
      State:= s_anim_3;
      |
    999:
      System_Reset;
      |
   else
    serprompt(ParamErr);
    return;
  endcase;
  serprompt(NoErr);
end;

// #############################################################################

// allgemeiner Parser-Teil

function Cmd2Index : byte;
// Umsetzen eines Text-Befehls in Index-Eintrag der Befehlstabelle
var myCmdIndex: byte;
begin
  ParamStr:= uppercase(ParamStr);
  for myCmdIndex := 0 to CmdAnzahl do
    if ParamStr = CmdStrArr[ord(myCmdIndex)] then
      return(myCmdIndex);
    endif;
  endfor;
  return(cmderr);
end;

function ParseExtract(nachGleich:boolean):boolean;
//extrahiert ParamStr oder CmdStr aus SerInpStr,
//liefert true, wenn Parameter, sonst false, wenn Command
//akzeptiert auch alphanumerische Parameter als String nach "="
var myChar: char; myBool:boolean;
begin
  ParamStr:='';
  ParamAlpha:=false;
  myBool:=false;
  while SerInpStr[SerInpPtr] =' ' do // Leerzeichen überspringen
    inc(serInpPtr);
  endwhile;
  if SerInpStr[SerInpPtr] in ['*'..'9'] then // Zahlen oder Wildcard, es wird ein Parameter
    myBool:=true;
    for i:=SerInpPtr to length(SerInpStr) do
      mychar:=SerInpStr[i];
      if myChar in ['*'..'9'] then
        append(mychar,ParamStr);
      else // Buchstabe oder sonstirgendwas, abbrechen
        SerInpPtr:=i;
        return(mybool);
      endif;
    endfor;
  else
    for i:=SerInpPtr to length(SerInpStr) do
      mychar:=SerInpStr[i];
      if mychar='"' then
        ParamAlpha:=true;
      else
        if (mychar>='A') or ParamAlpha then
          if (myChar in ['!','?','$']) then
            SerInpPtr:=i;
            return(mybool);
          else
            append(mychar,ParamStr);
          endif;
          if nachGleich then
            ParamAlpha:=true;
          endif;
        else // Ziffer oder sonstirgendwas, abbrechen
          SerInpPtr:=i;
          return(mybool);
        endif;
      endif;
    endfor;
  endif;
  return(mybool);
end;

procedure ParamStr2Param;
var DecPointPos:byte;
begin
  ParamLong:= StrToInt(ParamStr);
  ParamInt:= integer(ParamLong);
  ParamByte:= byte(ParamInt);
end;

// #############################################################################

procedure ParseSubCh;
//Überprüfen, ob Befehl oder Daten eingegangen und für uns, Parser-Vorbehandlung,
//Achtung: Erweitert um ParseResult für Anzeige-Auswertung, KEIN REFERENZ-PARSER!

var
  GleichPos,
  CheckSpos, myCheckSum,CheckSumIn:byte;
  SubChOffset:integer;

  myChar:char;
  hasMainCh, hasCRC, isResult, isOmni, isRequest: Boolean;

begin
  if SerInpStr='' then
    serprompt(NoErr);
    return;
  endif;
  hasMainCh:=(pos(':',SerInpStr)>0); // Kanaltrenner-':'
  gleichPos:=pos('=',SerInpStr); // Set-'='
  isRequest:=(GleichPos=0); // Abfrage
  myChar:=SerInpStr[1];
  isOmni:=(myChar='*');    // Omni-Flag
  isResult:=(myChar='#');  // Ergebnis-'#'
  SerInpPtr:=1;
  if isResult then
    SerInpPtr:=2;
  endif;
  if hasMainCh then
    ParseExtract(false);
    inc(SerInpPtr);
    if isOmni then // Omni-Befehl
      WriteSerInp; // weiterleiten
    endif;
  endif;
  if isResult then
    WriteSerInp;
    ParseResult:=true;
  endif;

// Befehl/Parameter ist für uns, ab hier eigentliche Behandlung
// Wenn vorhanden, XOR-Prüfsumme checken, Präfix-"$" zählt nicht mit!
  verbose:=(pos('!',SerInpStr)>0) OR (pos('?',SerInpStr)>0); // Ausführliche Antwort erwünscht
  CheckSpos:=pos('$',SerInpStr);
  hasCRC:=CheckSpos>0; // CheckSumIn-'$'

  if hasCRC then
    ParamStr:=copy(SerInpStr,CheckSpos+1, 2);
    CheckSumIn:=HexToInt(ParamStr); // erhaltene XOR-Checksumme
    myCheckSum:=0;
    for i:= 1 to CheckSpos-1 do
      myChar:=SerInpStr[i];
      myCheckSum:=myCheckSum xor ord(myChar);
    endfor;
    if myCheckSum <> CheckSumIn then
      serprompt(CheckSumErr);
      return;
    endif;
  endif;
//  SerInpStr:=trim(SerInpStr);

//Parse einzelnen Befehl
  if ParseExtract(false) then
    SubChOffset:=0; // direkter SubCh-Aufruf
  else
    CmdWhich:=Cmd2Index; // Klartext übersetzen
    if CmdWhich = cmderr then
      serprompt(SyntaxErr);
      return;
    endif;
    SubChOffset:=Cmd2SubChArr[ord(CmdWhich)];
    ParseExtract(false); // SubCh-Parameter holen
  endif;
  SubCh:=StrToInt(ParamStr)+SubChOffset; //auf neuen SubCh umrechnen
{$IFDEF PARSERESULT}        // Results entgegennehmen
  if ParseResult then
    if not isRequest then
      SerInpPtr:=gleichPos+1; // Set-'='
      ParseExtract(true);
      ParamStr2Param;
    endif;
  else
{$ENDIF}
    if isRequest then
      ParseGetParam;
    else
      SerInpPtr:=gleichPos+1; // Set-'='
      if ParseExtract(true) then
        ParamStr2Param;
      else
        ParamLong:=0;
        ParamInt:=0;
        ParamByte:=0;
      endif;
      ParseSetParam;
    endif;
{$IFDEF PARSERESULT}        // Results entgegennehmen
  endif;
  ParseResult:=false;
{$ENDIF}
end;


// #############################################################################
// Regelmäßig aufgerufen, aber nicht im Interrupt
// #############################################################################

procedure onSysTick;
// mod / div führt zu Störungen!
// alle Hundertstel Sekunden aufgerufen
begin
  Inc(TickCount);
  SysTickSema:= true;
  Inc(Sec100);
  if Sec100 >= 100 then
    Sec100:= 0;
  endif;
end;



function CheckSer: Boolean;
var
  myChar: char;
  result: Boolean;
begin
  result:= false;
  if serStat then //
    repeat
      myChar:=serInp;
      if myChar in [#32..#127] then // nur 7-Bit-ASCII ohne Controls
        append(myChar, SerInpStr);
      endif;
      if (length(SerInpStr)>0) and (mychar=#8) then // Backspace
        setlength(SerInpStr, length(SerInpStr)-1);
      endif;
      if myChar=#13 then
        setSysTimer(LEDtimer, 25);
        LEDactivity:= low;  // LED on
        FaultFlags:=0;
        ParseSubCh;               // Befehl interpretieren, wenn für uns
        SerInpStr:='';
        result:= true;
        setSysTimer(LEDtimer, 25);
        LEDactivity:= low;
      endif;
    until not serStat;
  endif;
  return(result);
end;

function Chores: Boolean;
begin
  repeat
  until SysTickSema; // 10 ms Delay
  SysTickSema:= false;
  if CheckSer then
    return(true);
  endif;
  if GetButtonPort then
    return(true);
  endif;
  return(false);
end;

function ChoresDelay(timeout: Integer): Boolean;
var exit: Boolean;
begin
  repeat
    exit:= Chores; // 10 ms
    dec(timeout);
  until exit or timeout <= 0;
  return(exit);
end;


end.

