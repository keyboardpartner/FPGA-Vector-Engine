# FPGA Vector Engine with Scope Clock and Asteroids Game

![GitHub Logo](https://github.com/keyboardpartner/FPGA-Vector-Engine/blob/main/ast_clk_2.jpg)

Dual DAC XY + Z Vector Engine with Asteroids Game and Scope Clock for use with [CTLAB FPGA Board](https://www.sn7400.de/ctlab/), containing [XC3S400 FPGA](https://www.sn7400.de/ctlab/Schematics/schem_FPGA-IO.pdf) and [ATmega644 controller](https://www.sn7400.de/ctlab/Schematics/schem_FPGA-MC.pdf). Needs [DACRAM extension](https://www.sn7400.de/ctlab/Schematics/schem_FPGA-DACRAM.pdf) with Dual DAC AD5447 output and Z/Audio R-DAC. Omit SRAM, AD9752 TxDAC and FreqZ input components.

Vector engine for scope clock and animations uses a BRAM in FPGA containing a list of vector commands. BRAM is loaded via SPI from ATmega644 controller.

AVR 644 firmware written in AVRco Pascal, download for free [from e-lab website](https://www.e-lab.de/downloads/AVRco/rev4/index.html). AVR flash and EEPROM may also be programmed with AVRdude programmer via ISP. Please note AVR fuse settings: SPIEN, EESAVE, CKSEL3, BODLEVEL0 and BODLEVEL1 must be set (JTAGEN unchecked!).

HPGL Converter written in Delphi 10.1 (free community edition), requires CPORT library by [Dejan Crnila and Lars B. Dybdahl](https://sourceforge.net/projects/comport/), converts HPGL vector graphics to BRAM vector engine format. Vector data for logos and animations are stored on SD card, will be transferred to FPGA by AVR controller. Clock face and clock hands are created by AVR firmware as vectors for FPGA vector engine.

![GitHub Logo](https://github.com/keyboardpartner/FPGA-Vector-Engine/blob/main/ast_clk_1.jpg)

The Asteroids game is a re-creation of the original 1979 Atari game. It runs separately in FPGA with its own 6502 processor emulation and vector generator. It just receives game button states via SPI from AVR 644. In idle/demo mode, the clock, logo animations and Asteroids game are displayed alternately.
