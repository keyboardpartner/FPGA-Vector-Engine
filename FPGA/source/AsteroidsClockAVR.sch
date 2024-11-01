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
        <signal name="CLK50" />
        <signal name="AST_DACZ(3:0)" />
        <signal name="AST_DAC_WR" />
        <signal name="CLKs(4)" />
        <signal name="XLXN_383(9:0)" />
        <signal name="DAC_MPX" />
        <signal name="DAC_WR" />
        <signal name="VEC_DACXY(11:0)" />
        <signal name="XLXN_3" />
        <signal name="DAC(11:0)" />
        <signal name="XLXN_519(11:0)" />
        <signal name="SELECT_VECENG" />
        <signal name="AST_BTN(7:0)" />
        <signal name="VEC_DACZ(3:0)" />
        <signal name="ZVID(3:0)" />
        <signal name="XLXN_562(3:0)" />
        <signal name="TXDAC_CLK" />
        <signal name="XLXN_583" />
        <signal name="VECT_SEL" />
        <signal name="VECT_WRN" />
        <signal name="XLXN_640" />
        <signal name="VEC_DONE" />
        <signal name="XLXN_687(31:0)" />
        <signal name="F_SCK" />
        <signal name="F_MOSI" />
        <signal name="F_DS" />
        <signal name="F_RS" />
        <signal name="XLXN_695(11:0)" />
        <signal name="F_MISO" />
        <signal name="VE_PORT_0(7:0)" />
        <signal name="XLXN_703" />
        <signal name="VE_PORT_0(0)" />
        <signal name="XLXN_708(7:0)" />
        <signal name="XLXN_713" />
        <signal name="XLXN_714" />
        <signal name="XLXN_715(31:0)" />
        <signal name="XLXN_718" />
        <signal name="BLINK(7:0)" />
        <signal name="LED" />
        <signal name="BLINK(3)" />
        <signal name="VE_PORT_0(1)" />
        <signal name="XLXN_719" />
        <signal name="VE_PORT_0(2)" />
        <signal name="XLXN_720" />
        <signal name="XLXN_722" />
        <signal name="AUDIO(2:0)" />
        <signal name="AST_AUDIO(7:5)" />
        <port polarity="Input" name="CLK50" />
        <port polarity="Output" name="DAC_MPX" />
        <port polarity="Output" name="DAC_WR" />
        <port polarity="Output" name="DAC(11:0)" />
        <port polarity="Output" name="ZVID(3:0)" />
        <port polarity="Output" name="TXDAC_CLK" />
        <port polarity="Output" name="VEC_DONE" />
        <port polarity="Input" name="F_SCK" />
        <port polarity="Input" name="F_MOSI" />
        <port polarity="Input" name="F_DS" />
        <port polarity="Input" name="F_RS" />
        <port polarity="BiDirectional" name="F_MISO" />
        <port polarity="Output" name="LED" />
        <port polarity="Output" name="AUDIO(2:0)" />
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
        <blockdef name="MPX3_XOR">
            <timestamp>2024-8-23T14:1:14</timestamp>
            <line x2="0" y1="96" y2="96" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="320" y="-108" height="24" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="256" x="64" y="-256" height="380" />
            <rect width="64" x="0" y="20" height="24" />
            <line x2="0" y1="32" y2="32" x1="64" />
        </blockdef>
        <blockdef name="MPX10_12">
            <timestamp>2022-9-14T20:14:31</timestamp>
            <rect width="256" x="64" y="-192" height="192" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-108" height="24" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
        </blockdef>
        <blockdef name="SPI32">
            <timestamp>2022-9-21T7:13:57</timestamp>
            <line x2="0" y1="-480" y2="-480" x1="64" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <rect width="64" x="0" y="-172" height="24" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <line x2="480" y1="-480" y2="-480" x1="416" />
            <rect width="64" x="416" y="-108" height="24" />
            <line x2="480" y1="-96" y2="-96" x1="416" />
            <rect width="352" x="64" y="-512" height="580" />
            <line x2="480" y1="-224" y2="-224" x1="416" />
            <line x2="480" y1="-288" y2="-288" x1="416" />
            <line x2="480" y1="-352" y2="-352" x1="416" />
            <rect width="64" x="416" y="-428" height="24" />
            <line x2="480" y1="-416" y2="-416" x1="416" />
            <rect width="64" x="416" y="20" height="24" />
            <line x2="480" y1="32" y2="32" x1="416" />
            <rect width="64" x="416" y="-44" height="24" />
            <line x2="480" y1="-32" y2="-32" x1="416" />
        </blockdef>
        <blockdef name="vector_engine">
            <timestamp>2024-8-23T13:54:48</timestamp>
            <rect width="64" x="400" y="276" height="24" />
            <line x2="464" y1="288" y2="288" x1="400" />
            <rect width="64" x="400" y="148" height="24" />
            <line x2="464" y1="160" y2="160" x1="400" />
            <rect width="64" x="400" y="212" height="24" />
            <line x2="464" y1="224" y2="224" x1="400" />
            <rect width="64" x="400" y="84" height="24" />
            <line x2="464" y1="96" y2="96" x1="400" />
            <line x2="464" y1="-288" y2="-288" x1="400" />
            <line x2="464" y1="-224" y2="-224" x1="400" />
            <line x2="464" y1="-160" y2="-160" x1="400" />
            <rect width="64" x="400" y="-108" height="24" />
            <line x2="464" y1="-96" y2="-96" x1="400" />
            <rect width="64" x="400" y="-44" height="24" />
            <line x2="464" y1="-32" y2="-32" x1="400" />
            <line x2="-16" y1="-288" y2="-288" x1="48" />
            <rect width="64" x="-16" y="-44" height="24" />
            <line x2="-16" y1="-32" y2="-32" x1="48" />
            <line x2="-16" y1="-224" y2="-224" x1="48" />
            <line x2="-16" y1="-160" y2="-160" x1="48" />
            <line x2="-16" y1="96" y2="96" x1="48" />
            <rect width="352" x="48" y="-320" height="696" />
            <line x2="464" y1="32" y2="32" x1="400" />
            <line x2="464" y1="352" y2="352" x1="400" />
        </blockdef>
        <blockdef name="ASTEROIDS">
            <timestamp>2008-4-3T13:48:23</timestamp>
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
        <blockdef name="inv8">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <circle r="16" cx="144" cy="-32" />
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <rect width="64" x="160" y="-44" height="24" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="128" y1="-64" y2="-32" x1="64" />
            <line x2="64" y1="-32" y2="0" x1="128" />
            <line x2="64" y1="0" y2="-64" x1="64" />
            <line x2="160" y1="-32" y2="-32" x1="224" />
        </blockdef>
        <blockdef name="Teiler50">
            <timestamp>2022-9-22T14:12:21</timestamp>
            <line x2="416" y1="96" y2="96" x1="352" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="288" x="64" y="-60" height="184" />
            <line x2="416" y1="32" y2="32" x1="352" />
            <line x2="416" y1="-32" y2="-32" x1="352" />
        </blockdef>
        <block symbolname="cb8ce" name="XLXI_21">
            <blockpin signalname="CLK50" name="C" />
            <blockpin signalname="XLXN_3" name="CE" />
            <blockpin name="CLR" />
            <blockpin name="CEO" />
            <blockpin signalname="CLKs(7:0)" name="Q(7:0)" />
            <blockpin name="TC" />
        </block>
        <block symbolname="fd" name="XLXI_29">
            <blockpin signalname="CLKs(2)" name="C" />
            <blockpin signalname="CLKs(3)" name="D" />
            <blockpin signalname="AST_DAC_WR" name="Q" />
        </block>
        <block symbolname="vcc" name="XLXI_6">
            <blockpin signalname="XLXN_3" name="P" />
        </block>
        <block symbolname="m2_1" name="XLXI_256">
            <blockpin signalname="CLKs(4)" name="D0" />
            <blockpin signalname="VECT_SEL" name="D1" />
            <blockpin signalname="SELECT_VECENG" name="S0" />
            <blockpin signalname="XLXN_640" name="O" />
        </block>
        <block symbolname="buf" name="XLXI_229">
            <blockpin signalname="XLXN_640" name="I" />
            <blockpin signalname="DAC_MPX" name="O" />
        </block>
        <block symbolname="buf" name="XLXI_230">
            <blockpin signalname="XLXN_583" name="I" />
            <blockpin signalname="DAC_WR" name="O" />
        </block>
        <block symbolname="MPX10" name="XLXI_287">
            <blockpin signalname="AST_DACX(9:0)" name="DA(9:0)" />
            <blockpin signalname="AST_DACY(9:0)" name="DB(9:0)" />
            <blockpin signalname="XLXN_383(9:0)" name="Q(9:0)" />
            <blockpin signalname="CLKs(4)" name="SEL" />
        </block>
        <block symbolname="inv" name="XLXI_315(11:0)">
            <blockpin signalname="XLXN_519(11:0)" name="I" />
            <blockpin signalname="DAC(11:0)" name="O" />
        </block>
        <block symbolname="buf" name="XLXI_232(3:0)">
            <blockpin signalname="XLXN_562(3:0)" name="I" />
            <blockpin signalname="ZVID(3:0)" name="O" />
        </block>
        <block symbolname="MPX3_XOR" name="XLXI_338">
            <blockpin signalname="XLXN_720" name="BEAM_ON_AST" />
            <blockpin signalname="XLXN_722" name="BEAM_ON_VEC" />
            <blockpin signalname="SELECT_VECENG" name="SEL" />
            <blockpin signalname="VE_PORT_0(1)" name="INVERT" />
            <blockpin signalname="AST_DACZ(3:0)" name="DA(3:0)" />
            <blockpin signalname="VEC_DACZ(3:0)" name="DV(3:0)" />
            <blockpin signalname="XLXN_562(3:0)" name="Q(3:0)" />
        </block>
        <block symbolname="vcc" name="XLXI_342">
            <blockpin signalname="TXDAC_CLK" name="P" />
        </block>
        <block symbolname="m2_1" name="XLXI_275">
            <blockpin signalname="AST_DAC_WR" name="D0" />
            <blockpin signalname="VECT_WRN" name="D1" />
            <blockpin signalname="SELECT_VECENG" name="S0" />
            <blockpin signalname="XLXN_583" name="O" />
        </block>
        <block symbolname="MPX10_12" name="XLXI_372">
            <blockpin signalname="SELECT_VECENG" name="SEL" />
            <blockpin signalname="XLXN_383(9:0)" name="DA(9:0)" />
            <blockpin signalname="VEC_DACXY(11:0)" name="DB(11:0)" />
            <blockpin signalname="XLXN_519(11:0)" name="Q(11:0)" />
        </block>
        <block symbolname="constant" name="XLXI_154">
            <attr value="11092024" name="CValue">
                <trait delete="all:1 sym:0" />
                <trait editname="all:1 sch:0" />
                <trait valuetype="BitVector 32 Hexadecimal" />
            </attr>
            <blockpin signalname="XLXN_687(31:0)" name="O" />
        </block>
        <block symbolname="vector_engine" name="XLXI_376">
            <blockpin signalname="CLK50" name="SYSCLK" />
            <blockpin signalname="XLXN_713" name="LV_INCWR" />
            <blockpin signalname="XLXN_714" name="LV_CMD" />
            <blockpin signalname="XLXN_703" name="SYNC" />
            <blockpin signalname="XLXN_715(31:0)" name="LV_DATA(31:0)" />
            <blockpin signalname="VEC_DONE" name="DONE" />
            <blockpin signalname="XLXN_722" name="BEAM_ON" />
            <blockpin signalname="VECT_SEL" name="DAC_SEL" />
            <blockpin signalname="VECT_WRN" name="DAC_WRN" />
            <blockpin name="TEST" />
            <blockpin signalname="VEC_DACXY(11:0)" name="DAC_MPX(11:0)" />
            <blockpin signalname="VEC_DACZ(3:0)" name="DAC_Z(3:0)" />
            <blockpin signalname="XLXN_695(11:0)" name="LV_ADDR(11:0)" />
            <blockpin name="VEC_ADDR(11:0)" />
            <blockpin signalname="VE_PORT_0(7:0)" name="PORT_0(7:0)" />
            <blockpin signalname="XLXN_708(7:0)" name="PORT_1(7:0)" />
        </block>
        <block symbolname="SPI32" name="XLXI_379">
            <blockpin signalname="CLK50" name="SYSCLK" />
            <blockpin signalname="F_SCK" name="SCK" />
            <blockpin signalname="F_MOSI" name="MOSI" />
            <blockpin signalname="F_DS" name="DS_N" />
            <blockpin signalname="F_RS" name="RS_N" />
            <blockpin signalname="XLXN_695(11:0)" name="D0_STATUS(11:0)" />
            <blockpin signalname="XLXN_687(31:0)" name="D3(31:0)" />
            <blockpin signalname="F_MISO" name="MISO" />
            <blockpin name="STROBE" />
            <blockpin signalname="XLXN_714" name="CMD_LC" />
            <blockpin signalname="XLXN_713" name="INC_LC" />
            <blockpin name="RSEL(7:0)" />
            <blockpin signalname="XLXN_715(31:0)" name="DATA_LC(31:0)" />
            <blockpin name="Q1_CONF(7:0)" />
            <blockpin name="Q2_CONF(7:0)" />
        </block>
        <block symbolname="buf" name="XLXI_381">
            <blockpin signalname="VE_PORT_0(0)" name="I" />
            <blockpin signalname="SELECT_VECENG" name="O" />
        </block>
        <block symbolname="ASTEROIDS" name="XLXI_385">
            <blockpin signalname="XLXN_719" name="RESET_6_L" />
            <blockpin signalname="CLKs(2)" name="CLK_6" />
            <blockpin signalname="AST_BTN(7:0)" name="BUTTON(7:0)" />
            <blockpin signalname="XLXN_720" name="BEAM_ON" />
            <blockpin name="BEAM_ENA" />
            <blockpin signalname="AST_AUDIO(7:0)" name="AUDIO_OUT(7:0)" />
            <blockpin signalname="AST_DACX(9:0)" name="X_VECTOR(9:0)" />
            <blockpin signalname="AST_DACY(9:0)" name="Y_VECTOR(9:0)" />
            <blockpin signalname="AST_DACZ(3:0)" name="Z_VECTOR(3:0)" />
        </block>
        <block symbolname="inv8" name="XLXI_386">
            <blockpin signalname="XLXN_708(7:0)" name="I(7:0)" />
            <blockpin signalname="AST_BTN(7:0)" name="O(7:0)" />
        </block>
        <block symbolname="cb8ce" name="XLXI_387">
            <blockpin signalname="XLXN_703" name="C" />
            <blockpin signalname="XLXN_718" name="CE" />
            <blockpin name="CLR" />
            <blockpin name="CEO" />
            <blockpin signalname="BLINK(7:0)" name="Q(7:0)" />
            <blockpin name="TC" />
        </block>
        <block symbolname="vcc" name="XLXI_388">
            <blockpin signalname="XLXN_718" name="P" />
        </block>
        <block symbolname="buf" name="XLXI_391">
            <blockpin signalname="BLINK(3)" name="I" />
            <blockpin signalname="LED" name="O" />
        </block>
        <block symbolname="inv" name="XLXI_392">
            <blockpin signalname="VE_PORT_0(2)" name="I" />
            <blockpin signalname="XLXN_719" name="O" />
        </block>
        <block symbolname="Teiler50" name="XLXI_393">
            <blockpin signalname="CLK50" name="SYSCLK50" />
            <blockpin name="TICK_100HZ" />
            <blockpin signalname="XLXN_703" name="TICK_50HZ" />
            <blockpin name="SQW_50HZ" />
        </block>
        <block symbolname="buf" name="XLXI_228(2:0)">
            <blockpin signalname="AST_AUDIO(7:5)" name="I" />
            <blockpin signalname="AUDIO(2:0)" name="O" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="5440" height="3520">
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
        <text style="fontsize:36;fontname:Arial" x="868" y="1004">Buttons:</text>
        <text style="fontsize:36;fontname:Arial" x="868" y="1052">(0) = Fire</text>
        <text style="fontsize:36;fontname:Arial" x="868" y="1100">(1) = R Turn</text>
        <text style="fontsize:36;fontname:Arial" x="868" y="1148">(2) = Coin</text>
        <text style="fontsize:36;fontname:Arial" x="868" y="1196">(3) = L Turn</text>
        <text style="fontsize:36;fontname:Arial" x="1076" y="1148">(6) = Shield</text>
        <text style="fontsize:36;fontname:Arial" x="1076" y="1196">(7) = 2 Player</text>
        <text style="fontsize:36;fontname:Arial" x="1076" y="1100">(5) = 1 Player</text>
        <text style="fontsize:36;fontname:Arial" x="1076" y="1052">(4) = Thrust</text>
        <branch name="AST_DACZ(3:0)">
            <attrtext style="alignment:SOFT-BCENTER" attrname="Name" x="2944" y="704" type="branch" />
            <wire x2="2944" y1="704" y2="704" x1="2752" />
            <wire x2="3440" y1="704" y2="704" x1="2944" />
            <wire x2="3440" y1="704" y2="1552" x1="3440" />
            <wire x2="3808" y1="1552" y2="1552" x1="3440" />
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
        <instance x="3808" y="256" name="XLXI_256" orien="R0" />
        <instance x="4208" y="160" name="XLXI_229" orien="R0" />
        <branch name="DAC_WR">
            <wire x2="4496" y1="1008" y2="1008" x1="4432" />
        </branch>
        <instance x="4208" y="1040" name="XLXI_230" orien="R0" />
        <iomarker fontsize="28" x="4496" y="128" name="DAC_MPX" orien="R0" />
        <iomarker fontsize="28" x="4496" y="1008" name="DAC_WR" orien="R0" />
        <branch name="CLKs(4)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="2752" y="96" type="branch" />
            <wire x2="3072" y1="96" y2="96" x1="2752" />
            <wire x2="3808" y1="96" y2="96" x1="3072" />
            <wire x2="3072" y1="96" y2="512" x1="3072" />
            <wire x2="3104" y1="512" y2="512" x1="3072" />
        </branch>
        <instance x="3104" y="544" name="XLXI_287" orien="R0">
        </instance>
        <instance x="1360" y="304" name="XLXI_6" orien="R0" />
        <branch name="SELECT_VECENG">
            <attrtext style="alignment:SOFT-BCENTER" attrname="Name" x="3328" y="1424" type="branch" />
            <wire x2="3328" y1="1424" y2="1424" x1="3280" />
            <wire x2="3568" y1="1424" y2="1424" x1="3328" />
            <wire x2="3808" y1="1424" y2="1424" x1="3568" />
            <wire x2="3568" y1="224" y2="512" x1="3568" />
            <wire x2="3616" y1="512" y2="512" x1="3568" />
            <wire x2="3568" y1="512" y2="1104" x1="3568" />
            <wire x2="3808" y1="1104" y2="1104" x1="3568" />
            <wire x2="3568" y1="1104" y2="1424" x1="3568" />
            <wire x2="3808" y1="224" y2="224" x1="3568" />
        </branch>
        <branch name="DAC(11:0)">
            <wire x2="4496" y1="576" y2="576" x1="4352" />
        </branch>
        <instance x="1504" y="800" name="XLXI_21" orien="R0" />
        <iomarker fontsize="28" x="1088" y="672" name="CLK50" orien="R180" />
        <instance x="4224" y="1584" name="XLXI_232(3:0)" orien="R0" />
        <branch name="ZVID(3:0)">
            <wire x2="4496" y1="1552" y2="1552" x1="4448" />
        </branch>
        <branch name="XLXN_562(3:0)">
            <wire x2="4224" y1="1552" y2="1552" x1="4192" />
        </branch>
        <instance x="3808" y="1648" name="XLXI_338" orien="R0">
        </instance>
        <iomarker fontsize="28" x="4496" y="1552" name="ZVID(3:0)" orien="R0" />
        <branch name="TXDAC_CLK">
            <wire x2="4320" y1="2480" y2="2512" x1="4320" />
            <wire x2="4528" y1="2512" y2="2512" x1="4320" />
        </branch>
        <instance x="4256" y="2480" name="XLXI_342" orien="R0" />
        <iomarker fontsize="28" x="4528" y="2512" name="TXDAC_CLK" orien="R0" />
        <branch name="XLXN_583">
            <wire x2="4208" y1="1008" y2="1008" x1="4128" />
        </branch>
        <text style="fontsize:36;fontname:Arial" x="4296" y="1652">Beam On wenn High</text>
        <branch name="VEC_DACXY(11:0)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:20;fontname:Arial" attrname="Name" x="2544" y="2448" type="branch" />
            <wire x2="2544" y1="2448" y2="2448" x1="2096" />
            <wire x2="3488" y1="2448" y2="2448" x1="2544" />
            <wire x2="3616" y1="640" y2="640" x1="3488" />
            <wire x2="3488" y1="640" y2="2448" x1="3488" />
        </branch>
        <branch name="VECT_SEL">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:20;fontname:Arial" attrname="Name" x="2560" y="2320" type="branch" />
            <wire x2="2560" y1="2320" y2="2320" x1="2096" />
            <wire x2="3536" y1="2320" y2="2320" x1="2560" />
            <wire x2="3808" y1="160" y2="160" x1="3536" />
            <wire x2="3536" y1="160" y2="2320" x1="3536" />
        </branch>
        <instance x="3808" y="1136" name="XLXI_275" orien="R0" />
        <branch name="VECT_WRN">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:20;fontname:Arial" attrname="Name" x="2544" y="2384" type="branch" />
            <wire x2="2544" y1="2384" y2="2384" x1="2096" />
            <wire x2="3600" y1="2384" y2="2384" x1="2544" />
            <wire x2="3808" y1="1040" y2="1040" x1="3600" />
            <wire x2="3600" y1="1040" y2="2384" x1="3600" />
        </branch>
        <instance x="3616" y="672" name="XLXI_372" orien="R0">
        </instance>
        <branch name="XLXN_519(11:0)">
            <wire x2="4128" y1="576" y2="576" x1="4000" />
        </branch>
        <instance x="4128" y="608" name="XLXI_315(11:0)" orien="R0" />
        <iomarker fontsize="28" x="4496" y="576" name="DAC(11:0)" orien="R0" />
        <branch name="XLXN_640">
            <wire x2="4208" y1="128" y2="128" x1="4128" />
        </branch>
        <instance x="1632" y="2544" name="XLXI_376" orien="R0">
        </instance>
        <branch name="XLXN_687(31:0)">
            <wire x2="544" y1="3248" y2="3248" x1="352" />
        </branch>
        <branch name="F_SCK">
            <wire x2="544" y1="2928" y2="2928" x1="384" />
        </branch>
        <branch name="F_MOSI">
            <wire x2="544" y1="2992" y2="2992" x1="384" />
        </branch>
        <branch name="F_DS">
            <wire x2="544" y1="3056" y2="3056" x1="384" />
        </branch>
        <branch name="F_RS">
            <wire x2="544" y1="3120" y2="3120" x1="384" />
        </branch>
        <iomarker fontsize="28" x="384" y="2928" name="F_SCK" orien="R180" />
        <iomarker fontsize="28" x="384" y="2992" name="F_MOSI" orien="R180" />
        <iomarker fontsize="28" x="384" y="3056" name="F_DS" orien="R180" />
        <iomarker fontsize="28" x="384" y="3120" name="F_RS" orien="R180" />
        <instance x="3056" y="1456" name="XLXI_381" orien="R0" />
        <text style="fontsize:36;fontname:Arial" x="3068" y="1340">VecEng/Asteroids</text>
        <instance x="208" y="3216" name="XLXI_154" orien="R0">
        </instance>
        <branch name="F_MISO">
            <wire x2="1072" y1="2992" y2="2992" x1="1024" />
        </branch>
        <branch name="VE_PORT_0(7:0)">
            <attrtext style="alignment:SOFT-LEFT;fontsize:28;fontname:Arial" attrname="Name" x="2736" y="2704" type="branch" />
            <wire x2="2736" y1="2704" y2="2704" x1="2096" />
        </branch>
        <instance x="544" y="3344" name="XLXI_379" orien="R0">
        </instance>
        <branch name="XLXN_703">
            <wire x2="1280" y1="1904" y2="1904" x1="1008" />
            <wire x2="1280" y1="1904" y2="1968" x1="1280" />
            <wire x2="1280" y1="1968" y2="2640" x1="1280" />
            <wire x2="1616" y1="2640" y2="2640" x1="1280" />
            <wire x2="1648" y1="1968" y2="1968" x1="1280" />
        </branch>
        <instance x="2288" y="736" name="XLXI_385" orien="R0">
        </instance>
        <branch name="VE_PORT_0(0)">
            <attrtext style="alignment:SOFT-RIGHT;fontsize:28;fontname:Arial" attrname="Name" x="2944" y="1424" type="branch" />
            <wire x2="3056" y1="1424" y2="1424" x1="2944" />
        </branch>
        <branch name="XLXN_708(7:0)">
            <wire x2="2448" y1="2768" y2="2768" x1="2096" />
        </branch>
        <branch name="AST_BTN(7:0)">
            <attrtext style="alignment:SOFT-BCENTER" attrname="Name" x="2544" y="1728" type="branch" />
            <wire x2="2288" y1="704" y2="704" x1="2144" />
            <wire x2="2144" y1="704" y2="1728" x1="2144" />
            <wire x2="2544" y1="1728" y2="1728" x1="2144" />
            <wire x2="3040" y1="1728" y2="1728" x1="2544" />
            <wire x2="3040" y1="1728" y2="2768" x1="3040" />
            <wire x2="3040" y1="2768" y2="2768" x1="2672" />
        </branch>
        <branch name="VEC_DONE">
            <wire x2="2752" y1="2256" y2="2256" x1="2096" />
        </branch>
        <instance x="2448" y="2800" name="XLXI_386" orien="R0" />
        <text style="fontsize:36;fontname:Arial" x="3212" y="2548">Beam On wenn High</text>
        <branch name="XLXN_713">
            <wire x2="1344" y1="3056" y2="3056" x1="1024" />
            <wire x2="1344" y1="2320" y2="3056" x1="1344" />
            <wire x2="1616" y1="2320" y2="2320" x1="1344" />
        </branch>
        <branch name="XLXN_714">
            <wire x2="1360" y1="3120" y2="3120" x1="1024" />
            <wire x2="1360" y1="2384" y2="3120" x1="1360" />
            <wire x2="1616" y1="2384" y2="2384" x1="1360" />
        </branch>
        <branch name="XLXN_715(31:0)">
            <wire x2="1376" y1="3248" y2="3248" x1="1024" />
            <wire x2="1376" y1="2512" y2="3248" x1="1376" />
            <wire x2="1616" y1="2512" y2="2512" x1="1376" />
        </branch>
        <iomarker fontsize="28" x="1072" y="2992" name="F_MISO" orien="R0" />
        <iomarker fontsize="28" x="2752" y="2256" name="VEC_DONE" orien="R0" />
        <text style="fontsize:40;fontname:Arial" x="124" y="2852">AVR 644 CTLAB</text>
        <instance x="1648" y="2096" name="XLXI_387" orien="R0" />
        <instance x="1536" y="1856" name="XLXI_388" orien="R0" />
        <branch name="XLXN_718">
            <wire x2="1600" y1="1856" y2="1904" x1="1600" />
            <wire x2="1648" y1="1904" y2="1904" x1="1600" />
        </branch>
        <branch name="BLINK(7:0)">
            <attrtext style="alignment:SOFT-LEFT;fontsize:28;fontname:Arial" attrname="Name" x="2112" y="1840" type="branch" />
            <wire x2="2112" y1="1840" y2="1840" x1="2032" />
        </branch>
        <branch name="LED">
            <wire x2="2624" y1="1936" y2="1936" x1="2544" />
        </branch>
        <iomarker fontsize="28" x="2624" y="1936" name="LED" orien="R0" />
        <branch name="BLINK(3)">
            <attrtext style="alignment:SOFT-RIGHT;fontsize:28;fontname:Arial" attrname="Name" x="2256" y="1936" type="branch" />
            <wire x2="2320" y1="1936" y2="1936" x1="2256" />
        </branch>
        <instance x="2320" y="1968" name="XLXI_391" orien="R0" />
        <branch name="VE_PORT_0(1)">
            <attrtext style="alignment:SOFT-RIGHT;fontsize:28;fontname:Arial" attrname="Name" x="2944" y="1488" type="branch" />
            <wire x2="3808" y1="1488" y2="1488" x1="2944" />
        </branch>
        <branch name="XLXN_3">
            <wire x2="1424" y1="304" y2="608" x1="1424" />
            <wire x2="1504" y1="608" y2="608" x1="1424" />
        </branch>
        <instance x="2032" y="416" name="XLXI_392" orien="R0" />
        <branch name="XLXN_719">
            <wire x2="2288" y1="384" y2="384" x1="2256" />
        </branch>
        <branch name="VE_PORT_0(2)">
            <attrtext style="alignment:SOFT-RIGHT;fontsize:28;fontname:Arial" attrname="Name" x="1920" y="384" type="branch" />
            <wire x2="2032" y1="384" y2="384" x1="1920" />
        </branch>
        <instance x="592" y="1872" name="XLXI_393" orien="R0">
        </instance>
        <branch name="VEC_DACZ(3:0)">
            <attrtext style="alignment:SOFT-BCENTER;fontsize:20;fontname:Arial" attrname="Name" x="2528" y="2512" type="branch" />
            <wire x2="2528" y1="2512" y2="2512" x1="2096" />
            <wire x2="3664" y1="2512" y2="2512" x1="2528" />
            <wire x2="3808" y1="1680" y2="1680" x1="3664" />
            <wire x2="3664" y1="1680" y2="2512" x1="3664" />
        </branch>
        <branch name="XLXN_720">
            <wire x2="3024" y1="384" y2="384" x1="2752" />
            <wire x2="3024" y1="384" y2="1616" x1="3024" />
            <wire x2="3808" y1="1616" y2="1616" x1="3024" />
        </branch>
        <branch name="XLXN_722">
            <wire x2="3712" y1="2576" y2="2576" x1="2096" />
            <wire x2="3712" y1="1744" y2="2576" x1="3712" />
            <wire x2="3808" y1="1744" y2="1744" x1="3712" />
        </branch>
        <branch name="AUDIO(2:0)">
            <wire x2="4496" y1="1920" y2="1920" x1="4448" />
        </branch>
        <branch name="AST_AUDIO(7:5)">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="4112" y="1920" type="branch" />
            <wire x2="4224" y1="1920" y2="1920" x1="4112" />
        </branch>
        <instance x="4224" y="1952" name="XLXI_228(2:0)" orien="R0" />
        <iomarker fontsize="28" x="4496" y="1920" name="AUDIO(2:0)" orien="R0" />
        <branch name="XLXN_695(11:0)">
            <wire x2="544" y1="3184" y2="3184" x1="464" />
            <wire x2="464" y1="3184" y2="3504" x1="464" />
            <wire x2="2192" y1="3504" y2="3504" x1="464" />
            <wire x2="2192" y1="2640" y2="2640" x1="2096" />
            <wire x2="2192" y1="2640" y2="3504" x1="2192" />
        </branch>
        <branch name="CLK50">
            <wire x2="1424" y1="1712" y2="1712" x1="496" />
            <wire x2="1424" y1="1712" y2="2256" x1="1424" />
            <wire x2="1616" y1="2256" y2="2256" x1="1424" />
            <wire x2="496" y1="1712" y2="1840" x1="496" />
            <wire x2="592" y1="1840" y2="1840" x1="496" />
            <wire x2="496" y1="1840" y2="2864" x1="496" />
            <wire x2="544" y1="2864" y2="2864" x1="496" />
            <wire x2="1424" y1="672" y2="672" x1="1088" />
            <wire x2="1504" y1="672" y2="672" x1="1424" />
            <wire x2="1424" y1="672" y2="1712" x1="1424" />
        </branch>
    </sheet>
</drawing>