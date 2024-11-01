VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "spartan3"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL SCK
        SIGNAL XLXN_139
        SIGNAL MOSI
        SIGNAL SSDAT
        SIGNAL MISO
        SIGNAL SSREG
        SIGNAL REGSEL(7:0)
        SIGNAL REGSEL(4)
        SIGNAL REGSEL(5)
        SIGNAL REGSEL(6)
        SIGNAL XLXN_194
        SIGNAL REGSEL(1)
        SIGNAL XLXN_197
        SIGNAL REGSEL(0)
        SIGNAL SPIQ3(31:0)
        SIGNAL SPIQ2(31:0)
        SIGNAL SPIQ1(31:0)
        SIGNAL SPIQ0(31:0)
        SIGNAL SPID2(31:0)
        SIGNAL SPID3(31:0)
        SIGNAL SPID0(31:0)
        SIGNAL SPID1(31:0)
        PORT Input SCK
        PORT Input MOSI
        PORT Input SSDAT
        PORT Output MISO
        PORT Input SSREG
        PORT Output SPIQ3(31:0)
        PORT Output SPIQ2(31:0)
        PORT Output SPIQ1(31:0)
        PORT Output SPIQ0(31:0)
        PORT Input SPID2(31:0)
        PORT Input SPID3(31:0)
        PORT Input SPID0(31:0)
        PORT Input SPID1(31:0)
        BEGIN BLOCKDEF SPI32_IN
            TIMESTAMP 2008 4 14 14 35 16
            LINE N 64 -288 0 -288 
            LINE N 64 -208 0 -208 
            RECTANGLE N 368 -300 432 -276 
            LINE N 368 -288 432 -288 
            RECTANGLE N 368 -236 432 -212 
            LINE N 368 -224 432 -224 
            RECTANGLE N 368 -172 432 -148 
            LINE N 368 -160 432 -160 
            RECTANGLE N 368 -108 432 -84 
            LINE N 368 -96 432 -96 
            RECTANGLE N 64 -320 368 112 
            LINE N 64 -128 0 -128 
            LINE N 64 -48 0 -48 
            LINE N 64 16 0 16 
            LINE N 64 80 0 80 
        END BLOCKDEF
        BEGIN BLOCKDEF obuft
            TIMESTAMP 2000 1 1 10 10 10
            LINE N 0 -96 64 -96 
            LINE N 96 -96 64 -96 
            LINE N 96 -48 96 -96 
            LINE N 224 -32 128 -32 
            LINE N 0 -32 64 -32 
            LINE N 64 -64 64 0 
            LINE N 128 -32 64 -64 
            LINE N 64 0 128 -32 
        END BLOCKDEF
        BEGIN BLOCKDEF SPI32_OUT
            TIMESTAMP 2008 4 14 17 4 54
            LINE N 64 -224 0 -224 
            LINE N 64 -288 0 -288 
            RECTANGLE N 64 -320 320 264 
            LINE N 64 -144 0 -144 
            LINE N 64 -96 0 -96 
            LINE N 64 -48 0 -48 
            RECTANGLE N 0 20 64 44 
            LINE N 64 32 0 32 
            LINE N 320 -144 384 -144 
            RECTANGLE N 0 148 64 172 
            LINE N 64 160 0 160 
            RECTANGLE N 0 212 64 236 
            LINE N 64 224 0 224 
            RECTANGLE N 0 84 64 108 
            LINE N 64 96 0 96 
        END BLOCKDEF
        BEGIN BLOCKDEF SPI8REG_IN
            TIMESTAMP 2008 4 14 14 7 12
            RECTANGLE N 64 -192 352 0 
            LINE N 64 -160 0 -160 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            RECTANGLE N 352 -172 416 -148 
            LINE N 352 -160 416 -160 
        END BLOCKDEF
        BEGIN BLOCKDEF d3_8e
            TIMESTAMP 2000 1 1 10 10 10
            LINE N 0 -576 64 -576 
            LINE N 0 -512 64 -512 
            LINE N 0 -448 64 -448 
            LINE N 384 -576 320 -576 
            LINE N 384 -512 320 -512 
            LINE N 384 -448 320 -448 
            LINE N 384 -384 320 -384 
            LINE N 384 -320 320 -320 
            LINE N 384 -256 320 -256 
            LINE N 384 -192 320 -192 
            LINE N 384 -128 320 -128 
            RECTANGLE N 64 -640 320 -64 
            LINE N 0 -128 64 -128 
        END BLOCKDEF
        BEGIN BLOCKDEF vcc
            TIMESTAMP 2000 1 1 10 10 10
            LINE N 64 -32 64 -64 
            LINE N 64 0 64 -32 
            LINE N 96 -64 32 -64 
        END BLOCKDEF
        BEGIN BLOCK XLXI_110 SPI32_OUT
            PIN SPI_CLK SCK
            PIN SPI_SSDATA SSDAT
            PIN A0 REGSEL(0)
            PIN A1 REGSEL(1)
            PIN ENABLE XLXN_197
            PIN DATA0(31:0) SPID0(31:0)
            PIN SPI_MISO XLXN_139
            PIN DATA2(31:0) SPID2(31:0)
            PIN DATA3(31:0) SPID3(31:0)
            PIN DATA1(31:0) SPID1(31:0)
        END BLOCK
        BEGIN BLOCK XLXI_44 obuft
            PIN I XLXN_139
            PIN T SSDAT
            PIN O MISO
        END BLOCK
        BEGIN BLOCK XLXI_168 SPI8REG_IN
            PIN SPI_MOSI MOSI
            PIN SPI_CLK SCK
            PIN SPI_SSREG SSREG
            PIN REGSEL(7:0) REGSEL(7:0)
        END BLOCK
        BEGIN BLOCK XLXI_171 d3_8e
            PIN A0 REGSEL(4)
            PIN A1 REGSEL(5)
            PIN A2 REGSEL(6)
            PIN E XLXN_194
            PIN D0 XLXN_197
            PIN D1
            PIN D2
            PIN D3
            PIN D4
            PIN D5
            PIN D6
            PIN D7
        END BLOCK
        BEGIN BLOCK XLXI_6 vcc
            PIN P XLXN_194
        END BLOCK
        BEGIN BLOCK XLXI_169 SPI32_IN
            PIN SPI_MOSI MOSI
            PIN SPI_CLK SCK
            PIN DATA3(31:0) SPIQ3(31:0)
            PIN DATA2(31:0) SPIQ2(31:0)
            PIN DATA1(31:0) SPIQ1(31:0)
            PIN DATA0(31:0) SPIQ0(31:0)
            PIN SPI_SSDATA SSDAT
            PIN A0 REGSEL(0)
            PIN A1 REGSEL(1)
            PIN ENABLE XLXN_197
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 3520 2720
        BEGIN BRANCH XLXN_139
            WIRE 1184 832 3152 832
            WIRE 3152 832 3152 1088
            WIRE 3088 1088 3152 1088
        END BRANCH
        INSTANCE XLXI_44 1184 800 R180
        BEGIN BRANCH MISO
            WIRE 352 832 960 832
        END BRANCH
        BEGIN BRANCH SSREG
            WIRE 352 528 736 528
        END BRANCH
        IOMARKER 352 1088 MOSI R180 28
        IOMARKER 352 1328 SSDAT R180 28
        IOMARKER 352 1168 SCK R180 28
        IOMARKER 352 832 MISO R180 28
        IOMARKER 352 528 SSREG R180 28
        BEGIN INSTANCE XLXI_168 736 560 R0
        END INSTANCE
        INSTANCE XLXI_171 1504 752 R0
        BEGIN BRANCH REGSEL(7:0)
            WIRE 1152 400 1232 400
            BEGIN DISPLAY 1232 400 ATTR Name
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH REGSEL(4)
            WIRE 1408 176 1504 176
            BEGIN DISPLAY 1408 176 ATTR Name
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH REGSEL(5)
            WIRE 1408 240 1504 240
            BEGIN DISPLAY 1408 240 ATTR Name
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH REGSEL(6)
            WIRE 1408 304 1504 304
            BEGIN DISPLAY 1408 304 ATTR Name
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        INSTANCE XLXI_6 1376 576 R0
        BEGIN BRANCH XLXN_194
            WIRE 1440 576 1440 624
            WIRE 1440 624 1504 624
        END BRANCH
        BEGIN BRANCH REGSEL(0)
            WIRE 2416 496 2528 496
            BEGIN DISPLAY 2416 496 ATTR Name
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH REGSEL(1)
            WIRE 2416 560 2528 560
            BEGIN DISPLAY 2416 560 ATTR Name
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE XLXI_169 2528 544 R0
        END INSTANCE
        IOMARKER 3168 320 SPIQ2(31:0) R0 28
        IOMARKER 3168 384 SPIQ1(31:0) R0 28
        IOMARKER 3168 448 SPIQ0(31:0) R0 28
        IOMARKER 3168 256 SPIQ3(31:0) R0 28
        BEGIN BRANCH XLXN_197
            WIRE 1888 176 2000 176
            WIRE 2000 176 2000 624
            WIRE 2000 624 2528 624
            WIRE 2000 624 2000 1184
            WIRE 2000 1184 2704 1184
        END BRANCH
        BEGIN BRANCH SPIQ3(31:0)
            WIRE 2960 256 3168 256
        END BRANCH
        BEGIN BRANCH SPIQ2(31:0)
            WIRE 2960 320 3168 320
        END BRANCH
        BEGIN BRANCH SPIQ1(31:0)
            WIRE 2960 384 3168 384
        END BRANCH
        BEGIN BRANCH SPIQ0(31:0)
            WIRE 2960 448 3168 448
        END BRANCH
        BEGIN BRANCH REGSEL(0)
            WIRE 2512 1088 2704 1088
            BEGIN DISPLAY 2512 1088 ATTR Name
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH REGSEL(1)
            WIRE 2512 1136 2704 1136
            BEGIN DISPLAY 2512 1136 ATTR Name
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE XLXI_110 2704 1232 R0
        END INSTANCE
        IOMARKER 2528 1264 SPID0(31:0) R180 28
        BEGIN BRANCH SPID2(31:0)
            WIRE 2528 1392 2704 1392
        END BRANCH
        BEGIN BRANCH SPID3(31:0)
            WIRE 2528 1456 2704 1456
        END BRANCH
        IOMARKER 2528 1328 SPID1(31:0) R180 28
        IOMARKER 2528 1392 SPID2(31:0) R180 28
        IOMARKER 2528 1456 SPID3(31:0) R180 28
        BEGIN BRANCH SPID0(31:0)
            WIRE 2528 1264 2704 1264
        END BRANCH
        BEGIN BRANCH SPID1(31:0)
            WIRE 2528 1328 2704 1328
        END BRANCH
        BEGIN BRANCH MOSI
            WIRE 352 1088 688 1088
            WIRE 688 1088 2096 1088
            WIRE 688 400 736 400
            WIRE 688 400 688 1088
            WIRE 2096 256 2528 256
            WIRE 2096 256 2096 1088
        END BRANCH
        BEGIN BRANCH SCK
            WIRE 352 1168 624 1168
            WIRE 624 1168 1520 1168
            WIRE 624 464 736 464
            WIRE 624 464 624 1168
            WIRE 1520 1008 2144 1008
            WIRE 2144 1008 2704 1008
            WIRE 1520 1008 1520 1168
            WIRE 2144 336 2528 336
            WIRE 2144 336 2144 1008
        END BRANCH
        BEGIN BRANCH SSDAT
            WIRE 352 1328 1216 1328
            WIRE 1216 1328 1616 1328
            WIRE 1184 896 1216 896
            WIRE 1216 896 1216 1328
            WIRE 1616 944 2192 944
            WIRE 2192 944 2704 944
            WIRE 1616 944 1616 1328
            WIRE 2192 416 2528 416
            WIRE 2192 416 2192 944
        END BRANCH
    END SHEET
END SCHEMATIC
