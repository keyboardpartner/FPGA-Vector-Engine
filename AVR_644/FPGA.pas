// #############################################################################
// Scope Clock on FPGA-Board
// #############################################################################
program FPGA;
(*

(c) by c't magazin und Carsten Meyer, cm@ctmagazin.de

31.10.2022 #2.7  Vereinfachte Version für VectorEngine/ScopeClock
18.05.2010 #2.63 Directory-SubCh-Bug behoben (240, 241)
09.06.2009 #2.62 XMR jetzt auch mit 2 und 4 Bytes Breite bei AIW
29.04.2009 #2.61 Checkser bereinigt, PanelTimer eingeführt
                 Panel-LED ist jetzt nur Seriell-Indikator (Panel abgeschaltet)
27.04.2009 #2.60 Latenzzeiten FPGA-Core <-> AVR stark verringert
                 Interrupt-Handling verbessert
                 INI/CFG-Default-Filename jetzt auch in Klartext möglich

*)

// PCA9532D, I2C Port $60 (Port-Adr. 0)
// Buttons (Bit-Nr.) ButtonPort_0:
// 0-Fire, 1=Rturn, 2=Coin, 3=Lturn, 4=Thrust, 5=Start, 6=Shield
// Buttons (Bit-Nr.) ButtonPort_1:
// 0-DEC, 1-INC, 2-Set (H, M, S, Weekday, Day, Month, Year, DaysLeft, Run)
// 3-END SetMode

// Vektordaten für Bilder MIT Initialisierungssequenz, aber ohne JUMP 0 erstellen!

//Defines aktivieren durch Entfernen des 1. Leerzeichens!


{$NOSHADOW}
{$W- Warnings}            {Warnings off}
{$TYPEDCONST OFF}

{ $DEFINE debug}         // Fehler-Anzeige auf LCD
{ $DEFINE MAKEMAGAZIN}           // MAKE-Logo statt KeyboardPartner

Device = mega644, VCC = 5;

Import SysTick, FAT16_32, TWImaster, SerPort, RTclock;  // ADCport,
From System Import LongWord, LongInt, Random;

Define
  ProcClock      = 16000000;        {Hertz}
  TWIpresc       = TWI_BR400;

  SysTick        = 10;              //msec
  SerPort        = 57600, Stop1, timeout;    {Baud, StopBits|Parity}
  RxBuffer       = 32, iData;
  TxBuffer       = 32, iData;

  StackSize      = $0100, iData;
  FrameSize      = $0100, iData;

  FAT16          = MMC_SPI, iData;
  F16_MMCspeed   = fast;
  F16_FileHandles   = 1;
  F16_Dirlevels     = 1;

  RTclock     = iData, DateTime;
  RTCsource   = SysTick;

uses
  UFAT16_32, fpga_if, rtc_maxim, vectorengine_spi, scope_clock,
  files, global_vars, parser;


Implementation


{###########################################################################}


procedure RTCtickHour;
begin
  HourSema:= true;
end;

procedure RTCtickMinute;
begin
  MinuteSema:= true;
end;

procedure RTCtickSecond;
begin
  SecondSema:= true;
end;

procedure serDummy;
begin
  serout('#');
end;

// #############################################################################
// allg. Menü-Prozeduren
// #############################################################################


procedure InitAll;
//nach Reset aufgerufen
begin
  DDRB:=  DDRBinit;            {PortB dir}
  PortB:= PortBinit;           {PortB}
  DDRC:=  DDRCinit;            {PortC dir}
  PortC:= PortCinit;           {PortC}
  DDRD:=  DDRDinit;            {PortD dir}
  PortD:= PortDinit;           {PortD}

//  serBaud(EESerbaud);        // nur mit 644

  ADMUX := ADMUX OR %11000000;  {Internal ADC Reference}
  // EIMSK := EIMSK or %00000100;  // external IRQ F_INT auf INT2
  // EICRA := EICRA or %00100000;  // Bit 4 und 5 = INT2 falling Edge

  InitVars;       // Optionen-Defaults

  udelay(1);
  MainCh:= 0;
  LEDactivity:= low;

  Status:= 0;
  EnableInts;
  while serstat do
    i:=SerInp;
  endwhile;
  SubCh:= 254;

  SerCRLF;
  write(SerOut,'/ ' + Vers1Str);
  SerCRLF;
  if EE_initialised <> $AA55 then
    write(SerOut, '/ ' + EEnotProgrammedStr);
    SerCRLF;
  endif;

  DS_Init;

  errcount:= 0;
  ButtonTemp := $FF;

  InvertZ:= EE_InvertZ <> false;
  CheckCard;
  if CardOK and (EE_initFileName<>'') then
    FileLoad(EE_initFileName);
    if FaultFlags<>0 then
      serprompt(FileErr);
    endif;
  endif;

  mdelay(500);
  if MainCh>0 then
    for i := 0 to MainCh-1 do
      LEDactivity:= not LEDactivity;
      mdelay(150);
      LEDactivity:= not LEDactivity;
      mdelay(150);
    endfor;
  endif;
  LEDactivity:= high;
end;

// #############################################################################

begin
  Initall;
  InitButtonPort;

  write(SerOut,'/ Ready');
  SerCRLF;

  if BoardMode = board_asteroids then
    InitScopeClock;
    // ShowLogoFiles;
  endif;

// Hauptschleife
  loop
    CheckSer;  // Serinp parsen
    if BoardMode = board_asteroids then
      HandleScopeClock;
    endif;
    if isSysTimerZero(LEDtimer) then
      LEDactivity:= high; // LED aus
    endif;
  endloop;

end FPGA.

