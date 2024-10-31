// ############################################################################
// ###                       FPGA LOWLEVEL-FUNKTIONEN                        ###
// #############################################################################
unit fpga_if;

interface

uses global_vars, ports;


  procedure InitSPI;
  procedure ShiftFPGAconf;  // Sende ein Byte an FPGA-Configuration
  procedure ShiftFPGAconfblock;  // Sende einen Block an FPGA-Configuration

  procedure SendFPGAreg;
  procedure SendFPGA8;
  procedure SendFPGA16;
  procedure SendFPGA32;

  function ReceiveFPGA(const myreg:byte): LongInt;
  procedure SendByteToFPGA(const myparam: byte; const myreg:byte);

  procedure SendWordToFPGA(const myparam: word; const myreg:byte);
  procedure SendLongToFPGA(const myparam: LongInt; const myreg:byte);

var
{$Data}
  idx: Byte;

{$PData}
  FPGA_PROG[ConFPGABitPort, c_PROG]: bit;  // Prog-Leitung FPGA Configuration
  FPGA_DONE[ConFPGABitPin,  c_DONE]: bit;  // Done-Leitung FPGA Configuration
  F_Aux[FPGAport, b_AUX]:bit;
  F_Int[FPGApin, b_INT2]:bit;   // Daten-abholen-Interrupt


{$IData}
  FPGAreg        : word;   // FPGA-Registerauswahl mit Write Enable Bit 15
  FPGAsendLong, FPGAreceiveLong: LongInt;  // FPGA-Registerwert Langwort

  FPGAsendLong0[@FPGAsendLong+0]: byte;
  FPGAsendLong1[@FPGAsendLong+1]: byte;
  FPGAsendLong2[@FPGAsendLong+2]: byte;
  FPGAsendLong3[@FPGAsendLong+3]: byte;

  FPGAsendLong_int0[@FPGAsendLong+0]: Integer;
  FPGAsendLong_int1[@FPGAsendLong+2]: Integer;

  FPGAreceiveLong0[@FPGAreceiveLong+0]: byte;
  FPGAreceiveLong1[@FPGAreceiveLong+1]: byte;
  FPGAreceiveLong2[@FPGAreceiveLong+2]: byte;
  FPGAreceiveLong3[@FPGAreceiveLong+3]: byte;

  FPGAreceiveInt[@FPGAreceiveLong+0]: Integer;  // FPGA-Registerwert Integer


{$VALIDATE_ON}
// Für Assembler-Routinen in DF_ benötigt!
  FPGAsendword, FPGAreceiveword: word;
  FPGAsendWord0[@FPGAsendWord+0]: byte;
  FPGAsendWord1[@FPGAsendWord+1]: byte;
  FPGAsendByte, FPGAreceiveByte, FPGAbyte: byte;  // FPGA-Registerwert Byte
{$VALIDATE_OFF}

  BlockTable: Table[0..255] of byte;
  BlockArray[@BlockTable]:  Array[0..255] of byte; // für FAT16
  BlockArray2[@BlockTable]: Array[0..127] of Word; // für FAT16
  BlockArray4[@BlockTable]: Array[0..63] of LongInt; // für FAT16
  BlockStr[@BlockTable]:    String[255];


implementation
{ implementation-Abschnitte }
// #############################################################################
// ###             Tabs und gesetzte Parameter an FPGA senden                ###
// #############################################################################

procedure InitSPI;
begin
// SPIE SPE DORD MSTR CPOL CPHA SPR1 SPR0
  //SPCR := %01011100;        // Enable SPI, Master, CPOL/CPHA=1,1 Mode 3
  SPCR := %01011100;          // Enable SPI, Master, CPOL/CPHA=1,1 Mode 3
  SPSR := %00000001;          // %00000001 = Double Rate, %00000000 = Normal Rate
end;

// #############################################################################
// FPGA Lowlevel functions
// #############################################################################

procedure ShiftFPGAconf;  // Sende ein Byte an FPGA-Configuration
begin
  asm;
    lds  _ACCA, fpga_if.FPGAbyte
    ldi  _ACCB, 8
    fpga_if.confloop1:    ; höherwertiges Byte rausschieben
    cbi  ports.ConFPGABitPort, ports.c_DATA
    sbrc _ACCA,7 // Bit high?
    sbi  ports.ConFPGABitPort, ports.c_DATA
    sbi  ports.ConFPGABitPort, ports.c_CCLK
    LSL  _ACCA
    cbi  ports.ConFPGABitPort, ports.c_CCLK
    dec _ACCB
    brne  fpga_if.confloop1
  endasm;
end;


procedure ShiftFPGAconfblock;  // Sende einen Block an FPGA-Configuration
begin
  asm;
    CLR  FPGA_IF.IDX  ; idx:= 0;
    LDI  _ACCCLO, FPGA_IF.BlockTable AND 0FFh  ;Z-Register
    LDI  _ACCCHI, FPGA_IF.BlockTable SHRB 8
    in   _ACCB, ports.ConFPGABitPort
    cbi  ports.ConFPGABitPort, ports.c_CCLK
    FPGA_IF.shiftFPGAbyte:
   ; schleifenloses, auf Schnelligkeit optimiertes Ausschieben eines Bytes
   ; DATA  __--__--__
   ; CCLK  _---_---_-
   ; Z-Pointer auf Array-Eintrag
    ld   _ACCA, Z
    bst  _ACCA,7  ; MSBit in T Flag
    bld  _ACCB, ports.c_DATA  ; T Flag in Register speichern
    out  ports.ConFPGABitPort, _ACCB ; mit CCLK auf low
    sbi  ports.ConFPGABitPort, ports.c_CCLK  ; CCLK high
    bst  _ACCA,6
    bld  _ACCB, ports.c_DATA  ; T Flag in Register speichern
    out  ports.ConFPGABitPort, _ACCB ; mit CCLK auf low
    sbi  ports.ConFPGABitPort, ports.c_CCLK  ; CCLK high
    bst  _ACCA,5
    bld  _ACCB, ports.c_DATA  ; T Flag in Register speichern
    out  ports.ConFPGABitPort, _ACCB ; mit CCLK auf low
    sbi  ports.ConFPGABitPort, ports.c_CCLK  ; CCLK high
    bst  _ACCA,4
    bld  _ACCB, ports.c_DATA  ; T Flag in Register speichern
    out  ports.ConFPGABitPort, _ACCB ; mit CCLK auf low
    sbi  ports.ConFPGABitPort, ports.c_CCLK  ; CCLK high
    bst  _ACCA,3
    bld  _ACCB, ports.c_DATA  ; T Flag in Register speichern
    out  ports.ConFPGABitPort, _ACCB ; mit CCLK auf low
    sbi  ports.ConFPGABitPort, ports.c_CCLK  ; CCLK high
    bst  _ACCA,2
    bld  _ACCB, ports.c_DATA  ; T Flag in Register speichern
    out  ports.ConFPGABitPort, _ACCB ; mit CCLK auf low
    sbi  ports.ConFPGABitPort, ports.c_CCLK  ; CCLK high
    bst  _ACCA,1
    bld  _ACCB, ports.c_DATA  ; T Flag in Register speichern
    out  ports.ConFPGABitPort, _ACCB ; mit CCLK auf low
    sbi  ports.ConFPGABitPort, ports.c_CCLK  ; CCLK high
    bst  _ACCA,0
    bld  _ACCB, ports.c_DATA  ; T Flag in Register speichern
    out  ports.ConFPGABitPort, _ACCB ; mit CCLK auf low
    sbi  ports.ConFPGABitPort, ports.c_CCLK  ; CCLK high
    ADIW  _ACCCLO, 1
    cbi  ports.ConFPGABitPort, ports.c_CCLK  ; CCLK wieder low
    inc  fpga_if.idx
    brne FPGA_IF.shiftFPGAbyte  ; wenn 0 => 256 Durchläufe
  endasm;
end;

procedure SendFPGA8;
//Sende und empfange ein Daten-Byte an den FPGA-Chip über SPI
begin
  asm;
;    cli ; Disable interrupts
    lds  _ACCA, fpga_if.FPGAsendByte
    cbi  ports.FPGAport, fpga_if.b_DATASEL
    out SPDR, _ACCA    ; SPI wurde von FAT16-Treiber eingeschaltet!
  SPIwait8_1:
    in _ACCA, SPSR
    sbrs _ACCA,7
    rjmp SPIwait8_1
    in _ACCA, SPDR
    sts  fpga_if.FPGAreceiveByte, _ACCA  ;Lesewert zurück ins Datenbyte
    sbi  ports.FPGAport, ports.b_DATASEL
;    sei ; Enable interrupts
  endasm;
end;

procedure SendFPGA16;
//Sende und empfange ein Daten-Wort (16 Bit-Register) an den FPGA-Chip über SPI
begin
  asm;
;    cli ; Disable interrupts
    lds  _ACCA, fpga_if.FPGAsendWord+1
    cbi  ports.FPGAport, ports.b_DATASEL
    out SPDR, _ACCA    ; SPI wurde von FAT16-Treiber eingeschaltet!
  SPIwait16_3:
    in _ACCA, SPSR
    sbrs _ACCA,7
    rjmp SPIwait16_3
    in _ACCA, SPDR
    sts  fpga_if.FPGAreceiveWord+1, _ACCA

    lds  _ACCA, fpga_if.FPGAsendWord+0
    out SPDR, _ACCA
  SPIwait16_4:
    in _ACCA, SPSR
    sbrs _ACCA,7
    rjmp SPIwait16_4
    in _ACCA, SPDR
    sts  fpga_if.FPGAreceiveWord+0, _ACCA

    sbi  ports.FPGAport, ports.b_DATASEL
;    sei ; Enable interrupts
  endasm;
end;

procedure SendFPGA32;
//Sende und empfange ein Daten-Langwort (32 Bit-Register) an den FPGA-Chip über SPI
begin
  asm;
;    cli ; Disable interrupts
    lds  _ACCA, fpga_if.FPGAsendLong+3
    cbi  ports.FPGAport, ports.b_DATASEL
    out SPDR, _ACCA    ; SPI wurde von FAT16-Treiber eingeschaltet!
  SPIwait32_1:
    in _ACCA, SPSR
    sbrs _ACCA,7       ; SPIF gesetzt?
    rjmp SPIwait32_1   ; auf Ende des SPI-Transfer warten
    in _ACCA, SPDR     ; und empfangenes Byte wieder in FPGAsendLong ablegen
    sts  fpga_if.FPGAreceiveLong+3, _ACCA

    lds  _ACCA, fpga_if.FPGAsendLong+2
    out SPDR, _ACCA     ; SPI von FAT16-Treiber eingeschaltet!
  SPIwait32_2:
    in _ACCA, SPSR
    sbrs _ACCA,7
    rjmp SPIwait32_2
    in _ACCA, SPDR
    sts  fpga_if.FPGAreceiveLong+2, _ACCA

    lds  _ACCA, fpga_if.FPGAsendLong+1
    out SPDR, _ACCA
  SPIwait32_3:
    in _ACCA, SPSR
    sbrs _ACCA,7
    rjmp SPIwait32_3
    in _ACCA, SPDR
    sts  fpga_if.FPGAreceiveLong+1, _ACCA

    lds  _ACCA, fpga_if.FPGAsendLong+0
    out SPDR, _ACCA
  SPIwait32_4:
    in _ACCA, SPSR
    sbrs _ACCA,7
    rjmp SPIwait32_4
    in _ACCA, SPDR
    sts  fpga_if.FPGAreceiveLong+0, _ACCA

    sbi  ports.FPGAport, ports.b_DATASEL
;    sei ; Enable interrupts
  endasm;
end;

procedure SendFPGAreg;
//Sende ein Byte (Registeradresse) an den FPGA-Chip
begin
  asm;
;    cli ; Disable interrupts
    cbi  ports.FPGAport, ports.b_REGSEL
;    lds  _ACCA, fpga_if.FPGAreg+1  ; Adresse Word MSB
;    out SPDR, _ACCA     ; SPI von FAT16-Treiber eingeschaltet!
;  SPIwaitReg_1:
;    in _ACCA, SPSR
;    sbrs _ACCA,7 ; SPIF?
;    rjmp SPIwaitReg_1     ;  auf Ende des SPI-Transfer warten

    lds  _ACCA, fpga_if.FPGAreg  ; Adresse Word LSB
    out SPDR, _ACCA     ; SPI von FAT16-Treiber eingeschaltet!
  SPIwaitReg_2:
    in _ACCA, SPSR
    sbrs _ACCA,7 ; SPIF?
    rjmp SPIwaitReg_2     ;  auf Ende des SPI-Transfer warten

    sbi  ports.FPGAport, ports.b_REGSEL
;    sei ; Enable interrupts
  endasm;
end;

// #############################################################################
// FPGA SPI communication functions
// #############################################################################

function ReceiveFPGA(const myreg:byte): LongInt;
begin
  FPGAreg:=word(myreg);     // Schreib-Register
  SendFPGAreg;
  SendFPGA32;
  return(FPGAreceiveLong);
end;

procedure SendByteToFPGA(const myparam: byte; const myreg:byte);
// schreib unskalierten Wert "myparam" nach SPI "myreg"
begin
  FPGAreg:=word(myreg);     // Schreib-Register
  SendFPGAreg;
  hi(FPGAsendWord):= 0;
  lo(FPGAsendWord):= myparam;
  SendFPGA16;
end;


procedure SendWordToFPGA(const myparam: word; const myreg:byte);
// schreib unskalierten Wert "myparam" nach SPI "myreg"
begin
  FPGAreg:=word(myreg);     // Schreib-Register
  SendFPGAreg;
  FPGAsendWord := myparam;
  SendFPGA16;
end;

procedure SendLongToFPGA(const myparam: LongInt; const myreg:byte);
// schreib unskalierten Wert "myparam" nach SPI "myreg"
begin
  FPGAreg:=word(myreg);     // Schreib-Register
  SendFPGAreg;
  FPGAsendLong:= myparam;
  SendFPGA32;
end;

end fpga_if.

