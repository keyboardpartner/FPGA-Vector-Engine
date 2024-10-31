Unit ports;

interface
// global part

{ $W+}                  // enable/disable warnings for this unit

const
// Port B: 7-SCK, 6-MISO, 5-MOSI, 4-CD_SS, 3-F_DS, 2-F_INT, 1-F_RS, 0-F_AUX
  DDRBinit:              Byte = %10111011;            {PortB dir }
  PortBinit:             Byte = %10111110;            {PortB }

// Port C: 7-F_DONE, 6-F_PROG, 5-F_CCLK, 4-F_DIN, 3-CD_SW, 2-nn, 1-I2C_SDA, 0-I2C_SCL
  DDRCinit:              Byte = %01110000;            {PortC dir, 0..1=Incr4 }
  PortCinit:             Byte = %11001111;            {PortC }

// Jumper und LEDs PortBits
  DDRDinit:              Byte = %00001100;            {PortD dir, 0..1=Serial }
  PortDinit:             Byte = %11111100;            {PortD }

{$TYPEDCONST OFF}

// Port B: 7-SCK, 6-MISO, 5-MOSI, 4-CD_SS, 3-F_DS, 2-F_INT, 1-F_RS, 0-F_AUX
// Port C: 7-F_DONE, 6-F_PROG, 5-F_CCLK, 4-F_DIN, 3-CD_SW, 2-nn, 1-I2C_SDA, 0-I2C_SCL
  FPGAport                   = @PortB;   {FPGA-SPI-Port}
  FPGApin                    = @PinB;    {FPGA-SPI-Port}
  ConFPGABitPort             = @PortC;   {FPGA-Config-Port}
  ConFPGABitPin              = @PinC;    {FPGA-Config-Port}
  b_SCK                      = 7; // Takt für alle, SPI-Belegung!
  b_MISO                     = 6; // SPI Daten von allen
  b_MOSI                     = 5; // Daten an alle
  b_SS                       = 4; // für MMC-Karte benutzt, HW-SPI!
  b_DATASEL                  = 3; // FPGA 32-Bit-Register
  b_INT2                     = 2; // INT2 ausgelöst vom FPGA
  b_REGSEL                   = 1; // FPGA Registerauswahl
  b_AUX                      = 0; // Testpin Trigger LA

  c_DATA                     = 4; // Daten FPGA Configuration
  c_CCLK                     = 5; // Takt FPGA Configuration
  c_PROG                     = 6; // Prog-Leitung FPGA Configuration
  c_DONE                     = 7; // Done-Leitung FPGA Configuration

  BtnInPortReg               = @PinD;    {Taster-Eingangsport}
  LEDOutPort                 = @PortD;   {LED-Port}

  c_CDSW                     = 3; // CD_SW Card insert switch, low = inserted
{$TYPEDCONST ON}
{$PDATA}  {Ports}
var
  LEDactivity[LEDOutPort, 2]    : bit; {Bit 2 LED Remote-Activity}
  LEDswitch[LEDOutPort, 3]      : bit; {Bit 3 LED über dem Display}

  SD_CDSW[ConFPGABitPin,  c_CDSW]: bit;    // Card Insertion Switch, low = inserted

{$IDATA}

var
  ButtonPort: Word;
  ButtonPort_0[@ButtonPort]: Byte;
  ButtonPort_1[@ButtonPort + 1]: Byte;

procedure InitButtonPort;
function GetButtonPort: Boolean;
procedure WaitButtonRelease;

implementation

procedure InitButtonPort;
var
  i2c_addr: Byte;
  temp_leds: LongWord;
begin
  ButtonsPresent:= TWIStat(PCA9532_0);
  if ButtonsPresent then
    write(SerOut, '/ Button Port detected');
    SerOut(#$0D);
    SerOut(#$0A);
    i2c_addr:= PCA9532_0;
    temp_leds:= $55555555;
    TWIout(i2c_addr, $16, temp_leds); // 16 LEDs abschalten, 4 Bytes - 72µs!
    mdelay(100);
    temp_leds:= 0;
    TWIout(i2c_addr, $16, temp_leds); // 16 LEDs abschalten, 4 Bytes - 72µs!
  endif;
end;

function GetButtonPort: Boolean;
// Liefert aktuellen Port-Wert vom PCA9532 zurück (16 Bit)
var
  i2c_addr: Byte;
  temp_word: Word;
  temp_word_0[@temp_word]: Byte;
  temp_word_1[@temp_word + 1]: Byte;
begin
  if ButtonsPresent then
    i2c_addr:= PCA9532_0;
    // In-Ports müssen bein 9532 einzeln gelesen werden!
    TWIout(i2c_addr, 0);    // Lesen Port 0
    TWIinp(i2c_addr, temp_word_0);
    TWIout(i2c_addr, 1);    // Lesen Port 1
    TWIinp(i2c_addr, temp_word_1);
    ButtonPort:= not temp_word;
  else
    ButtonPort:= 0;
  endif;
  return(ButtonPort <> 0);
end;

procedure WaitButtonRelease;
begin
  repeat
    mdelay(10);
  until not GetButtonPort;
end;

end ports.

