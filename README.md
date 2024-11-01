![GitHub Logo](https://github.com/keyboardpartner/FPGA-Vector-Engine/blob/main/ast_clk_1.jpg)
![GitHub Logo](https://github.com/keyboardpartner/FPGA-Vector-Engine/blob/main/ast_clk_2.jpg)

# FPGA Vector Engine with Scope Clock and Asteroids Game

Dual DAC XY + Z Vector Engine with Asteroids Game and Scope Clock for use with [CTLAB FPGA Board](https://www.sn7400.de/ctlab/), [XC3S400 FPGA](https://www.sn7400.de/ctlab/Schematics/schem_FPGA-IO.pdf) plus [ATmega644 controller](https://www.sn7400.de/ctlab/Schematics/schem_FPGA-MC.pdf) with [DACRAM extension](https://www.sn7400.de/ctlab/Schematics/schem_FPGA-DACRAM.pdf)
Uses Dual DAC AD5447 output and Z/Audio R-DAC. Omit SRAM, AD9752 TxDAC and FreqZ input components.

Vector engine for scope clock and animations uses a BRAM in FPGA containing a list of vector commands. BRAM is loaded via SPI from ATmega644 controller.

AVR 644 firmware written in AVRco Pascal, download for free [from e-lab website](https://www.e-lab.de/downloads/AVRco/rev4/index.html)

HPGL Converter written in Delphi 10.1, requires CPORT library by [Dejan Crnila and Lars B. Dybdahl](https://sourceforge.net/projects/comport/), converts HPGL vector graphics to BRAM vector engine format. Vector data for logos and animations are stored on SD card, will be transferred to FPGA by AVR controller. Clock face and clock hands are created by AVR firmware as vectors for FPGA vector engine.

The Asteroids game is a re-creation of the original 1979 Atari game. It runs separately in FPGA with its own 6502 processor and vector generator. It just receives game button states via SPI from AVR 644.
