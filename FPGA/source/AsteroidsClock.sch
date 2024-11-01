<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="AST_AUDIO(7:0)" />
        <signal name="AST_DACX(9:0)" />
        <signal name="AST_DACY(9:0)" />
        <signal name="CLKs(7:0)" />
        <signal name="CLKs(2)" />
        <signal name="CLKs(3)" />
        <signal name="ClkIn" />
        <signal name="AST_DACZ(3:0)" />
        <signal name="CLKs(0)" />
        <signal name="P3_O(7:0)" />
        <signal name="AST_DAC_WR" />
        <signal name="XLXN_103" />
        <signal name="ADJUST(7:0)" />
        <signal name="DCF77" />
        <signal name="ADJUST(3)" />
        <signal name="F_SCK" />
        <signal name="F_MOSI" />
        <signal name="F_DS" />
        <signal name="F_RS" />
        <signal name="F_MISO" />
        <signal name="XLXN_306(31:0)" />
        <signal name="BUTTON(31:0)" />
        <signal name="CLKs(4)" />
        <signal name="XLXN_383(9:0)" />
        <signal name="DAC_MPX" />
        <signal name="P3_O(5)" />
        <signal name="AUDIO(3:0)" />
        <signal name="AST_AUDIO(7:4)" />
        <signal name="RAM_WR" />
        <signal name="RAM_OE" />
        <signal name="DAC_WR" />
        <signal name="P3_O(4)" />
        <signal name="TestENA" />
        <signal name="XLXN_434" />
        <signal name="XLXN_437" />
        <signal name="CLOCK_DACXY(9:0)" />
        <signal name="TestWR" />
        <signal name="CLOCK_DACZ(2)" />
        <signal name="CLOCK_DACZ(1)" />
        <signal name="CLOCK_DACZ(0)" />
        <signal name="XLXN_3" />
        <signal name="XLXN_504" />
        <signal name="DAC(1:0)" />
        <signal name="DAC(11:0)" />
        <signal name="DAC(11:2)" />
        <signal name="XLXN_519(9:0)" />
        <signal name="CONFIG(31:0)" />
        <signal name="XLXN_128" />
        <signal name="ADJUST(0)" />
        <signal name="CONFIG(0)" />
        <signal name="ADJUST(1)" />
        <signal name="CONFIG(4)" />
        <signal name="CONFIG(8)" />
        <signal name="AST_BTN(7:0)" />
        <signal name="AST_BTN(6)" />
        <signal name="AST_BTN(5)" />
        <signal name="AST_BTN(4)" />
        <signal name="AST_BTN(3)" />
        <signal name="AST_BTN(2)" />
        <signal name="AST_BTN(1)" />
        <signal name="AST_BTN(0)" />
        <signal name="AST_BTN(7)" />
        <signal name="BUTTON(0)" />
        <signal name="BUTTON(4)" />
        <signal name="BUTTON(8)" />
        <signal name="BUTTON(12)" />
        <signal name="BUTTON(16)" />
        <signal name="BUTTON(20)" />
        <signal name="BUTTON(24)" />
        <signal name="BUTTON(28)" />
        <signal name="CLOCK_DACZ(2:0)" />
        <signal name="P3_O(7)" />
        <signal name="XLXN_560" />
        <signal name="AST_DACZ(3:1)" />
        <signal name="TestClk" />
        <signal name="ZVID(2:0)" />
        <signal name="XLXN_562(2:0)" />
        <signal name="CONFIG(12)" />
        <signal name="P3_O(6)" />
        <signal name="TestLED" />
        <signal name="XLXN_570" />
        <signal name="XLXN_571" />
        <signal name="DAC_CLK" />
        <signal name="XLXN_572(7:0)" />
        <port polarity="Input" name="ClkIn" />
        <port polarity="Input" name="DCF77" />
        <port polarity="Input" name="F_SCK" />
        <port polarity="Input" name="F_MOSI" />
        <port polarity="Input" name="F_DS" />
        <port polarity="Input" name="F_RS" />
        <port polarity="Output" name="F_MISO" />
        <port polarity="Output" name="DAC_MPX" />
        <port polarity="Output" name="AUDIO(3:0)" />
        <port polarity="Output" name="RAM_WR" />
        <port polarity="Output" name="RAM_OE" />
        <port polarity="Output" name="DAC_WR" />
        <port polarity="Output" name="DAC(11:0)" />
        <port polarity="Output" name="ZVID(2:0)" />
        <port polarity="Output" name="TestLED" />
        <port polarity="Output" name="DAC_CLK" />
        <blockdef name="ASTEROIDS">
            <timestamp>2008-4-3T13:48:24</timestamp>
            <rect width="336" x="64" y="-384" height="384" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <line x2="0" y1="-192" y2="-192" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="464" y1="-352" y2="-352" x1="400" />
            <line x2="464" y1="-288" y2="-288" x1="400" />
            <rect width="64" x="400" y="-236" height="24" />
            <line x2="464" y1="-224" y2="-224" x1="400" />
            <rect width="64" x="400" y="-172" height="24" />
            <line x2="464" y1="-160" y2="-160" x1="400" />
            <rect width="64" x="400" y="-108" height="24" />
            <line x2="464" y1="-96" y2="-96" x1="400" />
            <rect width="64" x="400" y="-44" height="24" />
            <line x2="464" y1="-32" y2="-32" x1="400" />
        </blockdef>
        <blockdef name="gnd">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-96" x1="64" />
            <line x2="52" y1="-48" y2="-48" x1="76" />
            <line x2="60" y1="-32" y2="-32" x1="68" />
            <line x2="40" y1="-64" y2="-64" x1="88" />
            <line x2="64" y1="-64" y2="-80" x1="64" />
            <line x2="64" y1="-128" y2="-96" x1="64" />
        </blockdef>
        <blockdef name="vcc">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-32" y2="-64" x1="64" />
            <line x2="64" y1="0" y2="-32" x1="64" />
            <line x2="32" y1="-64" y2="-64" x1="96" />
        </blockdef>
        <blockdef name="buf">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <line x2="128" y1="-32" y2="-32" x1="224" />
            <line x2="128" y1="0" y2="-32" x1="64" />
            <line x2="64" y1="-32" y2="-64" x1="128" />
            <line x2="64" y1="-64" y2="0" x1="64" />
        </blockdef>
        <blockdef name="cb8ce">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="320" y1="-128" y2="-128" x1="384" />
            <rect width="64" x="320" y="-268" height="24" />
            <line x2="320" y1="-256" y2="-256" x1="384" />
            <line x2="64" y1="-192" y2="-192" x1="0" />
            <line x2="64" y1="-32" y2="-32" x1="192" />
            <line x2="192" y1="-64" y2="-32" x1="192" />
            <line x2="64" y1="-128" y2="-144" x1="80" />
            <line x2="80" y1="-112" y2="-128" x1="64" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <line x2="320" y1="-192" y2="-192" x1="384" />
            <rect width="256" x="64" y="-320" height="256" />
        </blockdef>
        <blockdef name="fd">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <rect width="256" x="64" y="-320" height="256" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="64" y1="-256" y2="-256" x1="0" />
            <line x2="320" y1="-256" y2="-256" x1="384" />
            <line x2="64" y1="-128" y2="-144" x1="80" />
            <line x2="80" y1="-112" y2="-128" x1="64" />
        </blockdef>
        <blockdef name="T4051">
            <timestamp>2008-4-30T5:55:56</timestamp>
            <line x2="0" y1="-800" y2="-800" x1="64" />
            <line x2="0" y1="-736" y2="-736" x1="64" />
            <line x2="0" y1="-672" y2="-672" x1="64" />
            <line x2="0" y1="-608" y2="-608" x1="64" />
            <line x2="0" y1="-544" y2="-544" x1="64" />
            <line x2="0" y1="-480" y2="-480" x1="64" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <rect width="64" x="0" y="-220" height="24" />
            <line x2="0" y1="-208" y2="-208" x1="64" />
            <rect width="64" x="480" y="-220" height="24" />
            <line x2="544" y1="-208" y2="-208" x1="480" />
            <rect width="64" x="480" y="-140" height="24" />
            <line x2="544" y1="-128" y2="-128" x1="480" />
            <rect width="64" x="0" y="-140" height="24" />
            <line x2="0" y1="-128" y2="-128" x1="64" />
            <rect width="416" x="64" y="-832" height="768" />
            <line x2="544" y1="-800" y2="-800" x1="480" />
            <line x2="544" y1="-736" y2="-736" x1="480" />
            <line x2="544" y1="-672" y2="-672" x1="480" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
        </blockdef>
        <blockdef name="pullup">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-108" y2="-128" x1="64" />
            <line x2="64" y1="-104" y2="-108" x1="80" />
            <line x2="80" y1="-88" y2="-104" x1="48" />
            <line x2="48" y1="-72" y2="-88" x1="80" />
            <line x2="80" y1="-56" y2="-72" x1="48" />
            <line x2="48" y1="-48" y2="-56" x1="64" />
            <line x2="64" y1="-32" y2="-48" x1="64" />
            <line x2="64" y1="-56" y2="-48" x1="48" />
            <line x2="48" y1="-72" y2="-56" x1="80" />
            <line x2="80" y1="-88" y2="-72" x1="48" />
            <line x2="48" y1="-104" y2="-88" x1="80" />
            <line x2="80" y1="-108" y2="-104" x1="64" />
            <line x2="64" y1="0" y2="-32" x1="64" />
            <line x2="32" y1="-128" y2="-128" x1="96" />
        </blockdef>
        <blockdef name="CTLAB_SPI">
            <timestamp>2008-4-27T16:39:38</timestamp>
            <rect width="320" x="64" y="-512" height="512" />
            <line x2="0" y1="-480" y2="-480" x1="64" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <rect width="64" x="384" y="-44" height="24" />
            <line x2="448" y1="-32" y2="-32" x1="384" />
            <rect width="64" x="384" y="-108" height="24" />
            <line x2="448" y1="-96" y2="-96" x1="384" />
            <rect width="64" x="384" y="-172" height="24" />
            <line x2="448" y1="-160" y2="-160" x1="384" />
            <rect width="64" x="384" y="-236" height="24" />
            <line x2="448" y1="-224" y2="-224" x1="384" />
            <line x2="448" y1="-480" y2="-480" x1="384" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-172" height="24" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-236" height="24" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
        </blockdef>
        <blockdef name="constant">
            <timestamp>2006-1-1T10:10:10</timestamp>
            <rect width="112" x="0" y="0" height="64" />
            <line x2="112" y1="32" y2="32" x1="144" />
        </blockdef>
        <blockdef name="m2_1">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="96" y1="-64" y2="-192" x1="96" />
            <line x2="96" y1="-96" y2="-64" x1="256" />
            <line x2="256" y1="-160" y2="-96" x1="256" />
            <line x2="256" y1="-192" y2="-160" x1="96" />
            <line x2="96" y1="-32" y2="-32" x1="176" />
            <line x2="176" y1="-80" y2="-32" x1="176" />
            <line x2="96" y1="-32" y2="-32" x1="0" />
            <line x2="256" y1="-128" y2="-128" x1="320" />
            <line x2="96" y1="-96" y2="-96" x1="0" />
            <line x2="96" y1="-160" y2="-160" x1="0" />
        </blockdef>
        <blockdef name="MPX10">
            <timestamp>2008-12-3T17:28:36</timestamp>
            <rect width="64" x="0" y="20" height="24" />
            <line x2="0" y1="32" y2="32" x1="64" />
            <rect width="64" x="0" y="84" height="24" />
            <line x2="0" y1="96" y2="96" x1="64" />
            <rect width="64" x="320" y="20" height="24" />
            <line x2="384" y1="32" y2="32" x1="320" />
            <rect width="256" x="64" y="-64" height="192" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
        </blockdef>
        <blockdef name="inv">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <line x2="160" y1="-32" y2="-32" x1="224" />
            <line x2="128" y1="-64" y2="-32" x1="64" />
            <line x2="64" y1="-32" y2="0" x1="128" />
            <line x2="64" y1="0" y2="-64" x1="64" />
            <circle r="16" cx="144" cy="-32" />
        </blockdef>
        <blockdef name="Teiler50T">
            <timestamp>2008-12-3T17:53:53</timestamp>
            <rect width="256" x="64" y="-128" height="128" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
        </blockdef>
        <blockdef name="MPX3_XOR">
            <timestamp>2022-9-24T23:7:25</timestamp>
            <rect width="256" x="64" y="-256" height="256" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-108" height="24" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
        </blockdef>
        <blockdef name="ftsre">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-128" y2="-144" x1="80" />
            <line x2="80" y1="-112" y2="-128" x1="64" />
            <line x2="64" y1="-32" y2="-32" x1="192" />
            <line x2="192" y1="-64" y2="-32" x1="192" />
            <line x2="64" y1="-352" y2="-352" x1="192" />
            <line x2="192" y1="-320" y2="-352" x1="192" />
            <line x2="320" y1="-256" y2="-256" x1="384" />
            <line x2="64" y1="-352" y2="-352" x1="0" />
            <line x2="64" y1="-256" y2="-256" x1="0" />
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <line x2="64" y1="-192" y2="-192" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <rect width="256" x="64" y="-320" height="256" />
        </blockdef>
        <blockdef name="scaler">
            <timestamp>2022-9-12T20:8:18</timestamp>
            <rect width="256" x="64" y="-64" height="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-44" height="24" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <block symbolname="ASTEROIDS" name="XLXI_11">
            <blockpin signalname="XLXN_3" name="RESET_6_L" />
            <blockpin signalname="CLKs(2)" name="CLK_6" />
            <blockpin signalname="AST_BTN(7:0)" name="BUTTON(7:0)" />
            <blockpin name="BEAM_ON" />
            <blockpin name="BEAM_ENA" />
            <blockpin signalname="AST_AUDIO(7:0)" name="AUDIO_OUT(7:0)" />
            <blockpin signalname="AST_DACX(9:0)" name="X_VECTOR(9:0)" />
            <blockpin signalname="AST_DACY(9:0)" name="Y_VECTOR(9:0)" />
            <blockpin signalname="AST_DACZ(3:0)" name="Z_VECTOR(3:0)" />
        </block>
        <block symbolname="cb8ce" name="XLXI_21">
            <blockpin signalname="ClkIn" name="C" />
            <blockpin signalname="XLXN_3" name="CE" />
            <blockpin signalname="XLXN_128" name="CLR" />
            <blockpin name="CEO" />
            <blockpin signalname="CLKs(7:0)" name="Q(7:0)" />
            <blockpin name="TC" />
        </block>
        <block symbolname="fd" name="XLXI_29">
            <blockpin signalname="CLKs(2)" name="C" />
            <blockpin signalname="CLKs(3)" name="D" />
            <blockpin signalname="AST_DAC_WR" name="Q" />
        </block>
        <block symbolname="T4051" name="MPU4051">
            <blockpin signalname="CLKs(0)" name="Clk" />
            <blockpin signalname="XLXN_103" name="Rst_n" />
            <blockpin signalname="XLXN_504" name="INT0" />
            <blockpin name="INT1" />
            <blockpin signalname="CLKs(0)" name="T0" />
            <blockpin name="T1" />
            <blockpin name="T2" />
            <blockpin name="T2EX" />
            <blockpin name="P1_in(7:0)" />
            <blockpin signalname="ADJUST(7:0)" name="P3_in(7:0)" />
            <blockpin signalname="XLXN_572(7:0)" name="P1_out(7:0)" />
            <blockpin signalname="P3_O(7:0)" name="P3_out(7:0)" />
            <blockpin name="RXD_IsO" />
            <blockpin name="RXD_O" />
            <blockpin name="TXD" />
            <blockpin name="RXD" />
        </block>
        <block symbolname="vcc" name="XLXI_196">
            <blockpin signalname="XLXN_103" name="P" />
        </block>
        <block symbolname="buf" name="XLXI_201">
            <blockpin signalname="DCF77" name="I" />
            <blockpin signalname="ADJUST(3)" name="O" />
        </block>
        <block symbolname="pullup" name="XLXI_202">
            <blockpin signalname="DCF77" name="O" />
        </block>
        <block symbolname="vcc" name="XLXI_6">
            <blockpin signalname="XLXN_3" name="P" />
        </block>
        <block symbolname="gnd" name="XLXI_5">
            <blockpin signalname="XLXN_128" name="G" />
        </block>
        <block symbolname="CTLAB_SPI" name="XLXI_183">
            <blockpin signalname="F_SCK" name="SCK" />
            <blockpin signalname="F_MOSI" name="MOSI" />
            <blockpin signalname="F_DS" name="SSDAT" />
            <blockpin signalname="F_RS" name="SSREG" />
            <blockpin signalname="BUTTON(31:0)" name="SPIQ0(31:0)" />
            <blockpin signalname="CONFIG(31:0)" name="SPIQ1(31:0)" />
            <blockpin name="SPIQ2(31:0)" />
            <blockpin name="SPIQ3(31:0)" />
            <blockpin signalname="F_MISO" name="MISO" />
            <blockpin name="SPID0(31:0)" />
            <blockpin name="SPID1(31:0)" />
            <blockpin name="SPID2(31:0)" />
            <blockpin signalname="XLXN_306(31:0)" name="SPID3(31:0)" />
        </block>
        <block symbolname="constant" name="XLXI_154">
            <attr value="04122008" name="CValue">
                <trait delete="all:1 sym:0" />
                <trait editname="all:1 sch:0" />
                <trait valuetype="BitVector 32 Hexadecimal" />
            </attr>
            <blockpin signalname="XLXN_306(31:0)" name="O" />
        </block>
        <block symbolname="m2_1" name="XLXI_256">
            <blockpin signalname="CLKs(4)" name="D0" />
            <blockpin signalname="P3_O(5)" name="D1" />
            <blockpin signalname="CONFIG(8)" name="S0" />
            <blockpin signalname="XLXN_434" name="O" />
        </block>
        <block symbolname="buf" name="XLXI_229">
            <blockpin signalname="XLXN_434" name="I" />
            <blockpin signalname="DAC_MPX" name="O" />
        </block>
        <block symbolname="buf" name="XLXI_228(3:0)">
            <blockpin signalname="AST_AUDIO(7:4)" name="I" />
            <blockpin signalname="AUDIO(3:0)" name="O" />
        </block>
        <block symbolname="vcc" name="XLXI_235">
            <blockpin signalname="RAM_WR" name="P" />
        </block>
        <block symbolname="vcc" name="XLXI_236">
            <blockpin signalname="RAM_OE" name="P" />
        </block>
        <block symbolname="buf" name="XLXI_230">
            <blockpin signalname="XLXN_437" name="I" />
            <blockpin signalname="DAC_WR" name="O" />
        </block>
        <block symbolname="m2_1" name="XLXI_275">
            <blockpin signalname="AST_DAC_WR" name="D0" />
            <blockpin signalname="P3_O(4)" name="D1" />
            <blockpin signalname="CONFIG(8)" name="S0" />
            <blockpin signalname="XLXN_437" name="O" />
        </block>
        <block symbolname="buf" name="XLXI_247">
            <blockpin signalname="XLXN_434" name="I" />
            <blockpin signalname="TestENA" name="O" />
        </block>
        <block symbolname="buf" name="XLXI_246">
            <blockpin signalname="XLXN_437" name="I" />
            <blockpin signalname="TestWR" name="O" />
        </block>
        <block symbolname="MPX10" name="XLXI_287">
            <blockpin signalname="AST_DACX(9:0)" name="DA(9:0)" />
            <blockpin signalname="AST_DACY(9:0)" name="DB(9:0)" />
            <blockpin signalname="XLXN_383(9:0)" name="Q(9:0)" />
            <blockpin signalname="CLKs(4)" name="SEL" />
        </block>
        <block symbolname="MPX10" name="XLXI_288">
            <blockpin signalname="XLXN_383(9:0)" name="DA(9:0)" />
            <blockpin signalname="CLOCK_DACXY(9:0)" name="DB(9:0)" />
            <blockpin signalname="XLXN_519(9:0)" name="Q(9:0)" />
            <blockpin signalname="CONFIG(8)" name="SEL" />
        </block>
        <block symbolname="buf" name="XLXI_18">
            <blockpin signalname="XLXN_560" name="I" />
            <blockpin signalname="CLOCK_DACZ(2)" name="O" />
        </block>
        <block symbolname="buf" name="XLXI_17">
            <blockpin signalname="XLXN_560" name="I" />
            <blockpin signalname="CLOCK_DACZ(1)" name="O" />
        </block>
        <block symbolname="buf" name="XLXI_289">
            <blockpin signalname="XLXN_560" name="I" />
            <blockpin signalname="CLOCK_DACZ(0)" name="O" />
        </block>
        <block symbolname="Teiler50T" name="XLXI_312">
            <blockpin signalname="ClkIn" name="Clk" />
            <blockpin signalname="XLXN_128" name="Reset" />
            <blockpin signalname="XLXN_504" name="Q" />
        </block>
        <block symbolname="inv" name="XLXI_315(9:0)">
            <blockpin signalname="XLXN_519(9:0)" name="I" />
            <blockpin signalname="DAC(11:2)" name="O" />
        </block>
        <block symbolname="gnd" name="XLXI_237(1:0)">
            <blockpin signalname="DAC(1:0)" name="G" />
        </block>
        <block symbolname="inv" name="XLXI_325">
            <blockpin signalname="CONFIG(0)" name="I" />
            <blockpin signalname="ADJUST(0)" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_326">
            <blockpin signalname="CONFIG(4)" name="I" />
            <blockpin signalname="ADJUST(1)" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_328">
            <blockpin signalname="BUTTON(4)" name="I" />
            <blockpin signalname="AST_BTN(1)" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_329">
            <blockpin signalname="BUTTON(8)" name="I" />
            <blockpin signalname="AST_BTN(2)" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_330">
            <blockpin signalname="BUTTON(12)" name="I" />
            <blockpin signalname="AST_BTN(3)" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_331">
            <blockpin signalname="BUTTON(16)" name="I" />
            <blockpin signalname="AST_BTN(4)" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_332">
            <blockpin signalname="BUTTON(20)" name="I" />
            <blockpin signalname="AST_BTN(5)" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_333">
            <blockpin signalname="BUTTON(24)" name="I" />
            <blockpin signalname="AST_BTN(6)" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_334">
            <blockpin signalname="BUTTON(0)" name="I" />
            <blockpin signalname="AST_BTN(0)" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_335">
            <blockpin signalname="BUTTON(28)" name="I" />
            <blockpin signalname="AST_BTN(7)" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_337">
            <blockpin signalname="P3_O(7)" name="I" />
            <blockpin signalname="XLXN_560" name="O" />
        </block>
        <block symbolname="buf" name="XLXI_245">
            <blockpin name="I" />
            <blockpin signalname="TestClk" name="O" />
        </block>
        <block symbolname="buf" name="XLXI_232(2:0)">
            <blockpin signalname="XLXN_562(2:0)" name="I" />
            <blockpin signalname="ZVID(2:0)" name="O" />
        </block>
        <block symbolname="MPX3_XOR" name="XLXI_338">
            <blockpin signalname="CONFIG(8)" name="SEL" />
            <blockpin signalname="CONFIG(12)" name="INVERT" />
            <blockpin signalname="AST_DACZ(3:1)" name="DA(3:0)" />
            <blockpin signalname="CLOCK_DACZ(2:0)" name="DB(2:0)" />
            <blockpin signalname="XLXN_562(2:0)" name="Q(2:0)" />
        </block>
        <block symbolname="ftsre" name="XLXI_339">
            <blockpin signalname="P3_O(6)" name="C" />
            <blockpin signalname="XLXN_571" name="CE" />
            <blockpin name="R" />
            <blockpin name="S" />
            <blockpin signalname="XLXN_571" name="T" />
            <blockpin signalname="XLXN_570" name="Q" />
        </block>
        <block symbolname="buf" name="XLXI_313">
            <blockpin signalname="XLXN_570" name="I" />
            <blockpin signalname="TestLED" name="O" />
        </block>
        <block symbolname="vcc" name="XLXI_341">
            <blockpin signalname="XLXN_571" name="P" />
        </block>
        <block symbolname="vcc" name="XLXI_342">
            <blockpin signalname="DAC_CLK" name="P" />
        </block>
        <block symbolname="scaler" name="XLXI_343">
            <blockpin signalname="XLXN_572(7:0)" name="D_IN(7:0)" />
            <blockpin signalname="CLOCK_DACXY(9:0)" name="D_OUT(9:0)" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="5440" height="3520">
        <instance x="2288" y="736" name="XLXI_11" orien="R0">
        </instance>
        <branch name="AST_AUDIO(7:0)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="2832" y="512" type="branch" />
            <wire x2="2832" y1="512" y2="512" x1="2752" />
        </branch>
        <branch name="AST_DACX(9:0)">
            <attrtext style="alignment:SOFT-BCENTER" attrname="Name" x="2944" y="576" type="branch" />
            <wire x2="2944" y1="576" y2="576" x1="2752" />
            <wire x2="3104" y1="576" y2="576" x1="2944" />
        </branch>
        <branch name="AST_DACY(9:0)">
            <attrtext style="alignment:SOFT-BCENTER" attrname="Name" x="2944" y="640" type="branch" />
            <wire x2="2944" y1="640" y2="640" x1="2752" />
            <wire x2="3104" y1="640" y2="640" x1="2944" />
        </branch>
        <branch name="CLKs(7:0)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1920" y="544" type="branch" />
            <wire x2="1920" y1="544" y2="544" x1="1888" />
        </branch>
        <branch name="CLKs(2)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="2176" y="544" type="branch" />
            <wire x2="2224" y1="544" y2="544" x1="2176" />
            <wire x2="2224" y1="544" y2="1104" x1="2224" />
            <wire x2="2416" y1="1104" y2="1104" x1="2224" />
            <wire x2="2288" y1="544" y2="544" x1="2224" />
        </branch>
        <instance x="2416" y="1232" name="XLXI_29" orien="R0" />
        <branch name="CLKs(3)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="2400" y="976" type="branch" />
            <wire x2="2416" y1="976" y2="976" x1="2400" />
        </branch>
        <branch name="ClkIn">
            <wire x2="1424" y1="672" y2="672" x1="1088" />
            <wire x2="1424" y1="672" y2="1712" x1="1424" />
            <wire x2="1536" y1="1712" y2="1712" x1="1424" />
            <wire x2="1504" y1="672" y2="672" x1="1424" />
        </branch>
        <branch name="CLKs(0)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="2144" y="1584" type="branch" />
            <wire x2="2176" y1="1584" y2="1584" x1="2144" />
            <wire x2="2288" y1="1584" y2="1584" x1="2176" />
            <wire x2="2176" y1="1584" y2="1840" x1="2176" />
            <wire x2="2288" y1="1840" y2="1840" x1="2176" />
        </branch>
        <branch name="P3_O(7:0)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="2864" y="2256" type="branch" />
            <wire x2="2864" y1="2256" y2="2256" x1="2832" />
        </branch>
        <text style="fontsize:36;fontname:Arial" x="868" y="1004">Buttons:</text>
        <text style="fontsize:36;fontname:Arial" x="868" y="1052">(0) = Fire</text>
        <text style="fontsize:36;fontname:Arial" x="868" y="1100">(1) = R Turn</text>
        <text style="fontsize:36;fontname:Arial" x="868" y="1148">(2) = Coin</text>
        <text style="fontsize:36;fontname:Arial" x="868" y="1196">(3) = L Turn</text>
        <text style="fontsize:36;fontname:Arial" x="1076" y="1148">(6) = Shield</text>
        <text style="fontsize:36;fontname:Arial" x="1076" y="1196">(7) = 2 Player</text>
        <branch name="XLXN_103">
            <wire x2="2224" y1="1552" y2="1648" x1="2224" />
            <wire x2="2288" y1="1648" y2="1648" x1="2224" />
        </branch>
        <branch name="ADJUST(7:0)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="2096" y="2256" type="branch" />
            <wire x2="2288" y1="2256" y2="2256" x1="2096" />
        </branch>
        <text style="fontsize:36;fontname:Arial" x="1076" y="1100">(5) = 1 Player</text>
        <text style="fontsize:36;fontname:Arial" x="1076" y="1052">(4) = Thrust</text>
        <branch name="DCF77">
            <wire x2="1280" y1="2672" y2="2672" x1="1152" />
            <wire x2="1584" y1="2672" y2="2672" x1="1280" />
            <wire x2="1280" y1="2640" y2="2672" x1="1280" />
        </branch>
        <branch name="ADJUST(3)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1920" y="2672" type="branch" />
            <wire x2="1920" y1="2672" y2="2672" x1="1808" />
        </branch>
        <instance x="1584" y="2704" name="XLXI_201" orien="R0" />
        <instance x="1216" y="2640" name="XLXI_202" orien="R0" />
        <iomarker fontsize="28" x="1152" y="2672" name="DCF77" orien="R180" />
        <instance x="640" y="1936" name="XLXI_183" orien="R0">
        </instance>
        <branch name="F_SCK">
            <wire x2="640" y1="1456" y2="1456" x1="608" />
        </branch>
        <branch name="F_MOSI">
            <wire x2="640" y1="1520" y2="1520" x1="608" />
        </branch>
        <branch name="F_DS">
            <wire x2="640" y1="1584" y2="1584" x1="608" />
        </branch>
        <branch name="F_RS">
            <wire x2="640" y1="1648" y2="1648" x1="608" />
        </branch>
        <branch name="F_MISO">
            <wire x2="1120" y1="1456" y2="1456" x1="1088" />
        </branch>
        <instance x="272" y="1680" name="XLXI_154" orien="R0">
        </instance>
        <branch name="XLXN_306(31:0)">
            <wire x2="640" y1="1712" y2="1712" x1="416" />
        </branch>
        <iomarker fontsize="28" x="608" y="1456" name="F_SCK" orien="R180" />
        <iomarker fontsize="28" x="608" y="1520" name="F_MOSI" orien="R180" />
        <iomarker fontsize="28" x="608" y="1584" name="F_DS" orien="R180" />
        <iomarker fontsize="28" x="608" y="1648" name="F_RS" orien="R180" />
        <iomarker fontsize="28" x="1120" y="1456" name="F_MISO" orien="R0" />
        <branch name="BUTTON(31:0)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1216" y="1904" type="branch" />
            <wire x2="1216" y1="1904" y2="1904" x1="1088" />
        </branch>
        <branch name="AST_DACZ(3:0)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="2832" y="704" type="branch" />
            <wire x2="2832" y1="704" y2="704" x1="2752" />
        </branch>
        <branch name="XLXN_383(9:0)">
            <wire x2="3616" y1="576" y2="576" x1="3488" />
        </branch>
        <branch name="AST_DAC_WR">
            <attrtext style="alignment:SOFT-BCENTER" attrname="Name" x="2944" y="976" type="branch" />
            <wire x2="2944" y1="976" y2="976" x1="2800" />
            <wire x2="3808" y1="976" y2="976" x1="2944" />
        </branch>
        <branch name="DAC_MPX">
            <wire x2="4496" y1="128" y2="128" x1="4432" />
        </branch>
        <branch name="P3_O(5)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="3728" y="160" type="branch" />
            <wire x2="3808" y1="160" y2="160" x1="3728" />
        </branch>
        <branch name="AUDIO(3:0)">
            <wire x2="4528" y1="1824" y2="1824" x1="4448" />
        </branch>
        <branch name="AST_AUDIO(7:4)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="4112" y="1824" type="branch" />
            <wire x2="4224" y1="1824" y2="1824" x1="4112" />
        </branch>
        <instance x="4256" y="2096" name="XLXI_235" orien="R0" />
        <branch name="RAM_WR">
            <wire x2="4320" y1="2096" y2="2128" x1="4320" />
            <wire x2="4528" y1="2128" y2="2128" x1="4320" />
        </branch>
        <branch name="RAM_OE">
            <wire x2="4320" y1="2288" y2="2320" x1="4320" />
            <wire x2="4528" y1="2320" y2="2320" x1="4320" />
        </branch>
        <instance x="4256" y="2288" name="XLXI_236" orien="R0" />
        <iomarker fontsize="28" x="4528" y="1824" name="AUDIO(3:0)" orien="R0" />
        <iomarker fontsize="28" x="4528" y="2128" name="RAM_WR" orien="R0" />
        <iomarker fontsize="28" x="4528" y="2320" name="RAM_OE" orien="R0" />
        <instance x="3808" y="256" name="XLXI_256" orien="R0" />
        <instance x="4208" y="160" name="XLXI_229" orien="R0" />
        <branch name="DAC_WR">
            <wire x2="4496" y1="1008" y2="1008" x1="4432" />
        </branch>
        <instance x="4208" y="1040" name="XLXI_230" orien="R0" />
        <iomarker fontsize="28" x="4496" y="128" name="DAC_MPX" orien="R0" />
        <iomarker fontsize="28" x="4496" y="1008" name="DAC_WR" orien="R0" />
        <branch name="P3_O(4)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="3728" y="1040" type="branch" />
            <wire x2="3808" y1="1040" y2="1040" x1="3728" />
        </branch>
        <branch name="CLKs(4)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="2752" y="96" type="branch" />
            <wire x2="3072" y1="96" y2="96" x1="2752" />
            <wire x2="3808" y1="96" y2="96" x1="3072" />
            <wire x2="3072" y1="96" y2="512" x1="3072" />
            <wire x2="3104" y1="512" y2="512" x1="3072" />
        </branch>
        <branch name="TestENA">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="4496" y="224" type="branch" />
            <wire x2="4496" y1="224" y2="224" x1="4432" />
        </branch>
        <instance x="4208" y="256" name="XLXI_247" orien="R0" />
        <branch name="XLXN_434">
            <wire x2="4160" y1="128" y2="128" x1="4128" />
            <wire x2="4208" y1="128" y2="128" x1="4160" />
            <wire x2="4160" y1="128" y2="224" x1="4160" />
            <wire x2="4208" y1="224" y2="224" x1="4160" />
        </branch>
        <instance x="3808" y="1136" name="XLXI_275" orien="R0" />
        <instance x="2288" y="2384" name="MPU4051" orien="R0">
        </instance>
        <branch name="TestWR">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="4496" y="1104" type="branch" />
            <wire x2="4496" y1="1104" y2="1104" x1="4432" />
        </branch>
        <instance x="4208" y="1136" name="XLXI_246" orien="R0" />
        <branch name="XLXN_437">
            <wire x2="4176" y1="1008" y2="1008" x1="4128" />
            <wire x2="4208" y1="1008" y2="1008" x1="4176" />
            <wire x2="4176" y1="1008" y2="1104" x1="4176" />
            <wire x2="4208" y1="1104" y2="1104" x1="4176" />
        </branch>
        <instance x="3104" y="544" name="XLXI_287" orien="R0">
        </instance>
        <instance x="2656" y="2448" name="XLXI_18" orien="R0" />
        <instance x="2656" y="2512" name="XLXI_17" orien="R0" />
        <instance x="2656" y="2576" name="XLXI_289" orien="R0" />
        <branch name="CLOCK_DACZ(2)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="2944" y="2416" type="branch" />
            <wire x2="2944" y1="2416" y2="2416" x1="2880" />
        </branch>
        <branch name="CLOCK_DACZ(1)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="2944" y="2480" type="branch" />
            <wire x2="2944" y1="2480" y2="2480" x1="2880" />
        </branch>
        <branch name="CLOCK_DACZ(0)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="2944" y="2544" type="branch" />
            <wire x2="2944" y1="2544" y2="2544" x1="2880" />
        </branch>
        <instance x="1536" y="1808" name="XLXI_312" orien="R0">
        </instance>
        <instance x="1360" y="304" name="XLXI_6" orien="R0" />
        <branch name="XLXN_3">
            <wire x2="1424" y1="304" y2="384" x1="1424" />
            <wire x2="2288" y1="384" y2="384" x1="1424" />
            <wire x2="1424" y1="384" y2="608" x1="1424" />
            <wire x2="1504" y1="608" y2="608" x1="1424" />
        </branch>
        <branch name="XLXN_504">
            <wire x2="2288" y1="1712" y2="1712" x1="1920" />
        </branch>
        <branch name="CONFIG(8)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="3280" y="1424" type="branch" />
            <wire x2="3568" y1="1424" y2="1424" x1="3280" />
            <wire x2="3808" y1="1424" y2="1424" x1="3568" />
            <wire x2="3568" y1="224" y2="512" x1="3568" />
            <wire x2="3616" y1="512" y2="512" x1="3568" />
            <wire x2="3568" y1="512" y2="1104" x1="3568" />
            <wire x2="3808" y1="1104" y2="1104" x1="3568" />
            <wire x2="3568" y1="1104" y2="1424" x1="3568" />
            <wire x2="3808" y1="224" y2="224" x1="3568" />
        </branch>
        <instance x="3616" y="544" name="XLXI_288" orien="R0">
        </instance>
        <bustap x2="4496" y1="624" y2="624" x1="4592" />
        <branch name="DAC(1:0)">
            <attrtext style="alignment:SOFT-BCENTER" attrname="Name" x="4416" y="624" type="branch" />
            <wire x2="4368" y1="624" y2="640" x1="4368" />
            <wire x2="4416" y1="624" y2="624" x1="4368" />
            <wire x2="4496" y1="624" y2="624" x1="4416" />
        </branch>
        <bustap x2="4496" y1="576" y2="576" x1="4592" />
        <branch name="DAC(11:0)">
            <wire x2="4688" y1="480" y2="480" x1="4592" />
            <wire x2="4592" y1="480" y2="576" x1="4592" />
            <wire x2="4592" y1="576" y2="624" x1="4592" />
            <wire x2="4592" y1="624" y2="672" x1="4592" />
        </branch>
        <branch name="DAC(11:2)">
            <attrtext style="alignment:SOFT-BCENTER" attrname="Name" x="4416" y="576" type="branch" />
            <wire x2="4416" y1="576" y2="576" x1="4288" />
            <wire x2="4496" y1="576" y2="576" x1="4416" />
        </branch>
        <iomarker fontsize="28" x="4688" y="480" name="DAC(11:0)" orien="R0" />
        <branch name="XLXN_519(9:0)">
            <wire x2="4064" y1="576" y2="576" x1="4000" />
        </branch>
        <instance x="4064" y="608" name="XLXI_315(9:0)" orien="R0" />
        <instance x="4304" y="768" name="XLXI_237(1:0)" orien="R0" />
        <branch name="CONFIG(31:0)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1216" y="1840" type="branch" />
            <wire x2="1216" y1="1840" y2="1840" x1="1088" />
        </branch>
        <instance x="1408" y="1952" name="XLXI_5" orien="R0" />
        <branch name="ADJUST(0)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1920" y="2064" type="branch" />
            <wire x2="1920" y1="2064" y2="2064" x1="1872" />
        </branch>
        <branch name="CONFIG(0)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="1600" y="2064" type="branch" />
            <wire x2="1648" y1="2064" y2="2064" x1="1600" />
        </branch>
        <branch name="ADJUST(1)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1920" y="2160" type="branch" />
            <wire x2="1920" y1="2160" y2="2160" x1="1872" />
        </branch>
        <branch name="CONFIG(4)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="1600" y="2160" type="branch" />
            <wire x2="1648" y1="2160" y2="2160" x1="1600" />
        </branch>
        <text style="fontsize:36;fontname:Arial" x="1496" y="2216">Adj Stunden</text>
        <instance x="2160" y="1552" name="XLXI_196" orien="R0" />
        <text style="fontsize:36;fontname:Arial" x="1500" y="2016">Adj Minuten</text>
        <instance x="1648" y="2096" name="XLXI_325" orien="R0" />
        <instance x="1648" y="2192" name="XLXI_326" orien="R0" />
        <branch name="AST_BTN(7:0)">
            <attrtext style="alignment:SOFT-BCENTER" attrname="Name" x="2096" y="704" type="branch" />
            <wire x2="2096" y1="704" y2="880" x1="2096" />
            <wire x2="2096" y1="880" y2="944" x1="2096" />
            <wire x2="2096" y1="944" y2="1008" x1="2096" />
            <wire x2="2096" y1="1008" y2="1072" x1="2096" />
            <wire x2="2096" y1="1072" y2="1136" x1="2096" />
            <wire x2="2096" y1="1136" y2="1200" x1="2096" />
            <wire x2="2096" y1="1200" y2="1264" x1="2096" />
            <wire x2="2096" y1="1264" y2="1328" x1="2096" />
            <wire x2="2096" y1="1328" y2="1360" x1="2096" />
            <wire x2="2288" y1="704" y2="704" x1="2096" />
        </branch>
        <instance x="1728" y="976" name="XLXI_328" orien="R0" />
        <instance x="1728" y="1040" name="XLXI_329" orien="R0" />
        <instance x="1728" y="1104" name="XLXI_330" orien="R0" />
        <instance x="1728" y="1168" name="XLXI_331" orien="R0" />
        <instance x="1728" y="1232" name="XLXI_332" orien="R0" />
        <instance x="1728" y="1296" name="XLXI_333" orien="R0" />
        <instance x="1728" y="912" name="XLXI_334" orien="R0" />
        <instance x="1728" y="1360" name="XLXI_335" orien="R0" />
        <bustap x2="2000" y1="1328" y2="1328" x1="2096" />
        <bustap x2="2000" y1="1264" y2="1264" x1="2096" />
        <branch name="AST_BTN(6)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1976" y="1264" type="branch" />
            <wire x2="2000" y1="1264" y2="1264" x1="1952" />
        </branch>
        <bustap x2="2000" y1="1200" y2="1200" x1="2096" />
        <branch name="AST_BTN(5)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1976" y="1200" type="branch" />
            <wire x2="2000" y1="1200" y2="1200" x1="1952" />
        </branch>
        <bustap x2="2000" y1="1136" y2="1136" x1="2096" />
        <branch name="AST_BTN(4)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1976" y="1136" type="branch" />
            <wire x2="2000" y1="1136" y2="1136" x1="1952" />
        </branch>
        <bustap x2="2000" y1="1072" y2="1072" x1="2096" />
        <branch name="AST_BTN(3)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1976" y="1072" type="branch" />
            <wire x2="2000" y1="1072" y2="1072" x1="1952" />
        </branch>
        <bustap x2="2000" y1="1008" y2="1008" x1="2096" />
        <branch name="AST_BTN(2)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1976" y="1008" type="branch" />
            <wire x2="2000" y1="1008" y2="1008" x1="1952" />
        </branch>
        <bustap x2="2000" y1="944" y2="944" x1="2096" />
        <branch name="AST_BTN(1)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1976" y="944" type="branch" />
            <wire x2="2000" y1="944" y2="944" x1="1952" />
        </branch>
        <bustap x2="2000" y1="880" y2="880" x1="2096" />
        <branch name="AST_BTN(0)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1976" y="880" type="branch" />
            <wire x2="2000" y1="880" y2="880" x1="1952" />
        </branch>
        <branch name="AST_BTN(7)">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1976" y="1328" type="branch" />
            <wire x2="2000" y1="1328" y2="1328" x1="1952" />
        </branch>
        <instance x="1504" y="800" name="XLXI_21" orien="R0" />
        <branch name="XLXN_128">
            <wire x2="1504" y1="768" y2="768" x1="1472" />
            <wire x2="1472" y1="768" y2="1776" x1="1472" />
            <wire x2="1536" y1="1776" y2="1776" x1="1472" />
            <wire x2="1472" y1="1776" y2="1824" x1="1472" />
        </branch>
        <iomarker fontsize="28" x="1088" y="672" name="ClkIn" orien="R180" />
        <branch name="BUTTON(0)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="1680" y="880" type="branch" />
            <wire x2="1728" y1="880" y2="880" x1="1680" />
        </branch>
        <branch name="BUTTON(4)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="1680" y="944" type="branch" />
            <wire x2="1728" y1="944" y2="944" x1="1680" />
        </branch>
        <branch name="BUTTON(8)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="1680" y="1008" type="branch" />
            <wire x2="1728" y1="1008" y2="1008" x1="1680" />
        </branch>
        <branch name="BUTTON(12)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="1680" y="1072" type="branch" />
            <wire x2="1728" y1="1072" y2="1072" x1="1680" />
        </branch>
        <branch name="BUTTON(16)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="1680" y="1136" type="branch" />
            <wire x2="1728" y1="1136" y2="1136" x1="1680" />
        </branch>
        <branch name="BUTTON(20)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="1680" y="1200" type="branch" />
            <wire x2="1728" y1="1200" y2="1200" x1="1680" />
        </branch>
        <branch name="BUTTON(24)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="1680" y="1264" type="branch" />
            <wire x2="1728" y1="1264" y2="1264" x1="1680" />
        </branch>
        <branch name="BUTTON(28)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="1680" y="1328" type="branch" />
            <wire x2="1728" y1="1328" y2="1328" x1="1680" />
        </branch>
        <instance x="4224" y="1856" name="XLXI_228(3:0)" orien="R0" />
        <branch name="CLOCK_DACZ(2:0)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="3280" y="1616" type="branch" />
            <wire x2="3808" y1="1616" y2="1616" x1="3280" />
        </branch>
        <branch name="P3_O(7)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="2256" y="2480" type="branch" />
            <wire x2="2352" y1="2480" y2="2480" x1="2256" />
        </branch>
        <instance x="2352" y="2512" name="XLXI_337" orien="R0" />
        <branch name="XLXN_560">
            <wire x2="2608" y1="2480" y2="2480" x1="2576" />
            <wire x2="2656" y1="2480" y2="2480" x1="2608" />
            <wire x2="2608" y1="2480" y2="2544" x1="2608" />
            <wire x2="2656" y1="2544" y2="2544" x1="2608" />
            <wire x2="2656" y1="2416" y2="2416" x1="2608" />
            <wire x2="2608" y1="2416" y2="2480" x1="2608" />
        </branch>
        <branch name="AST_DACZ(3:1)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="3280" y="1552" type="branch" />
            <wire x2="3808" y1="1552" y2="1552" x1="3280" />
        </branch>
        <branch name="TestClk">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="4496" y="1344" type="branch" />
            <wire x2="4496" y1="1344" y2="1344" x1="4432" />
        </branch>
        <instance x="4208" y="1376" name="XLXI_245" orien="R0" />
        <instance x="4224" y="1584" name="XLXI_232(2:0)" orien="R0" />
        <branch name="ZVID(2:0)">
            <wire x2="4496" y1="1552" y2="1552" x1="4448" />
        </branch>
        <branch name="XLXN_562(2:0)">
            <wire x2="4224" y1="1552" y2="1552" x1="4192" />
        </branch>
        <instance x="3808" y="1648" name="XLXI_338" orien="R0">
        </instance>
        <iomarker fontsize="28" x="4496" y="1552" name="ZVID(2:0)" orien="R0" />
        <branch name="CONFIG(12)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="3280" y="1488" type="branch" />
            <wire x2="3808" y1="1488" y2="1488" x1="3280" />
        </branch>
        <text style="fontsize:36;fontname:Arial" x="3252" y="2484">Beam On wenn High</text>
        <text style="fontsize:36;fontname:Arial" x="1984" y="1744">100 Hz</text>
        <instance x="3856" y="3072" name="XLXI_339" orien="R0" />
        <branch name="P3_O(6)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="3696" y="2944" type="branch" />
            <wire x2="3856" y1="2944" y2="2944" x1="3696" />
        </branch>
        <branch name="TestLED">
            <wire x2="4528" y1="2816" y2="2816" x1="4496" />
        </branch>
        <branch name="XLXN_570">
            <wire x2="4272" y1="2816" y2="2816" x1="4240" />
        </branch>
        <instance x="4272" y="2848" name="XLXI_313" orien="R0" />
        <text style="fontsize:36;fontname:Arial" x="3508" y="2900">Sekundentakt</text>
        <branch name="XLXN_571">
            <wire x2="3760" y1="2720" y2="2816" x1="3760" />
            <wire x2="3856" y1="2816" y2="2816" x1="3760" />
            <wire x2="3760" y1="2816" y2="2880" x1="3760" />
            <wire x2="3856" y1="2880" y2="2880" x1="3760" />
        </branch>
        <instance x="3696" y="2720" name="XLXI_341" orien="R0" />
        <iomarker fontsize="28" x="4528" y="2816" name="TestLED" orien="R0" />
        <branch name="DAC_CLK">
            <wire x2="4320" y1="2480" y2="2512" x1="4320" />
            <wire x2="4528" y1="2512" y2="2512" x1="4320" />
        </branch>
        <instance x="4256" y="2480" name="XLXI_342" orien="R0" />
        <iomarker fontsize="28" x="4528" y="2512" name="DAC_CLK" orien="R0" />
        <branch name="CLOCK_DACXY(9:0)">
            <attrtext style="alignment:SOFT-TVCENTER" attrname="Name" x="3488" y="1152" type="branch" />
            <wire x2="3488" y1="2176" y2="2176" x1="3280" />
            <wire x2="3616" y1="640" y2="640" x1="3488" />
            <wire x2="3488" y1="640" y2="1152" x1="3488" />
            <wire x2="3488" y1="1152" y2="2176" x1="3488" />
        </branch>
        <instance x="2896" y="2208" name="XLXI_343" orien="R0">
        </instance>
        <branch name="XLXN_572(7:0)">
            <wire x2="2896" y1="2176" y2="2176" x1="2832" />
        </branch>
        <text style="fontsize:36;fontname:Arial" x="3564" y="1684">Beam On wenn High</text>
        <text style="fontsize:36;fontname:Arial" x="3064" y="1380">Clock/Asteroids</text>
    </sheet>
</drawing>