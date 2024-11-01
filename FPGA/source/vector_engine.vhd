----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Carsten Meyer
-- 
-- Create Date:  17:17:17 04/27/2008 
-- Design Name: 
-- Module Name:  MPX10 - Behavioral 
-- Project Name: ct-Lab AsteroidsClock

-- Vector Data (LV_INC = 1):
-- Vector Data:
-- 31 (3) 24   23 (2) 16   15 (1)  8   7  (0)  0       (In Klammern: Byte von MCU-IF)
-- CCCC YYYY   YYYY YYYY   CCCC XXXX   XXXX XXXX
-- C = Command, LSB in 15:12, MSB in 31:24  
-- Y = Y-Wert oder Kreisabschnitt-Ende,
-- X = X-Wert, Kreis-Radius, Kreisabschnitt-Start oder Adresse
-- Commands:
-- 0  - Setze Startpunkt oder Kreismitte X/Y absolut
-- 1  - Setze Startpunkt oder Kreismitte X/Y relativ
-- 2  - Zeichne Linie nach X/Y absolut
-- 3  - Zeichne Linie nach X/Y relativ, Beam Low
-- 4  - Setze Kreisabschnitt (Winkel) nach X-Wert, 825 = Vollkreis
-- 5  - Setze Kreis-SIN/COS, zeichne Kreis
-- 6  - Setze Offset für nächste Objekte, X/Y
-- 7  - Setze Rotations-Mittelpunkt für nächste Objekte, X/Y
-- 8  - Setze Rotation für nächste Objekte um Offset-Nullpunkt, X = Winkel in 2 * pi * 128
-- 9  - Setze Skalierung nach X/Y-Werten, $400 = 100%
-- 10 - Pause, X-Wert * 5µs
-- 11 - NOP
-- 12 - Stop, warte auf Reset (Load-Command) oder Sync
-- 13 - Jump/Loop, Ende der Vektoren, Start wieder mit Adresse X
-- 14 - Aufruf Subroutine an Adresse X
-- 15 - Return aus Subroutine

-- 16 - Set Beam Intenity 0..7 (in X-Wert) für alle folgenden Draw-Funktionen
-- 17 - Set Deflection Timer 0..4095 (Vektor-Schreibgeschwindigkeit) nach X-Wert
-- 18 - Set DAX XY Point (Punkt zeichnen mit anschließender Pause, letzter Wert aus #10)

-- 19 - SKIP, JUMP Relativ

-- Lade-Kommandos (LV_CMD = 1):
-- 31 (3) 24   23 (2) 16   15 (1)  8   7  (0)  0  (In Klammern: Byte von MCU-IF)
-- CCCC 0000   0000 0000   0000 PPPP   PPPP PPPP
-- CCCC YYYY   YYYY YYYY   ZZZZ XXXX   XXXX XXXX  (für Command 6 = direct DAC)
-- C = Command, P = Parameter
-- CCCC = 0 - Set Load Addr, nächste Lade-Adresse VECRAM (oder 0) in P-Wert
-- CCCC = 1 - Starte Vector Engine mit Reset-State, Loop nach nächstem SYNC
-- CCCC = 2 - Starte Vector Engine mit Reset-State, einmaliger Durchlauf
-- CCCC = 3 - Starte Vector Engine mit Reset-State, Loop wartet nicht auf SYNC
-- CCCC = 6 - Stop Vector Engine, DACs = YYYY YYYY YYYY 0ZZZ XXXX XXXX XXXX
-- CCCC = 7 - Stop Vector Engine, DACs = 0, 0, 0
-- CCCC = 8 - Set Auxiliary Port 0
-- CCCC = 9 - Set Auxiliary Port 1
-- CCCC = 12  Anzahl Pausentakte bei MOVE, 64 = 1,28µs, default 400 = 8µs			

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vector_engine is
	Port (
		 SYSCLK: in std_logic;
		 LV_INCWR: in std_logic;
		 LV_CMD: in std_logic;
		 LV_DATA : in  STD_LOGIC_VECTOR (31 downto 0);
		 DAC_MPX : out STD_LOGIC_VECTOR (11 downto 0);
		 SYNC: in std_logic;
		 DONE: out std_logic;
		 DAC_Z : out STD_LOGIC_VECTOR (3 downto 0);
		 BEAM_ON: out std_logic;
		 DAC_SEL: out std_logic;
		 DAC_WRN: out std_logic;
		 LV_ADDR : out STD_LOGIC_VECTOR (11 downto 0);
		 VEC_ADDR : out STD_LOGIC_VECTOR (11 downto 0);	-- current vector
		 PORT_0 : out STD_LOGIC_VECTOR (7 downto 0);
		 PORT_1 : out STD_LOGIC_VECTOR (7 downto 0);
		 TEST: out std_logic
		 );
end vector_engine;

architecture Behavioral of vector_engine is

COMPONENT bresenham
PORT(
	CLK : IN std_logic;
	LOAD_XY : IN std_logic;
	X1 : IN std_logic_vector(11 downto 0);
	Y1 : IN std_logic_vector(11 downto 0);
	X2 : IN std_logic_vector(11 downto 0);
	Y2 : IN std_logic_vector(11 downto 0);
	DEFL_TIMER : IN std_logic_vector(11 downto 0);          
	BEAM_VALID : OUT std_logic;
	DONE : OUT std_logic;
	STROBE : OUT std_logic;
	DAC_RDY : IN std_logic;
	X_VAL : OUT std_logic_vector(11 downto 0);
	Y_VAL : OUT std_logic_vector(11 downto 0)
	);
END COMPONENT;

COMPONENT biquad_circle
PORT(
	CLK : IN std_logic;
	K_FREQU : IN std_logic_vector(2 downto 0);
	PI_START : IN std_logic_vector(11 downto 0);
	PI_END : IN std_logic_vector(11 downto 0);
	LOAD_SCV : IN std_logic;
	DEFL_TIMER : IN std_logic_vector(11 downto 0);
	OFS_X : IN std_logic_vector(11 downto 0);
	OFS_Y : IN std_logic_vector(11 downto 0);
	RADIUS : IN std_logic_vector(11 downto 0);          
	BEAM_VALID : OUT std_logic;
	STROBE : OUT std_logic;
	DAC_RDY : IN std_logic;
	X_VAL : OUT std_logic_vector(11 downto 0);
	Y_VAL : OUT std_logic_vector(11 downto 0);
	DONE : OUT std_logic
	);
END COMPONENT;

COMPONENT biquad_sincos
PORT(
	CLK : IN std_logic;
	PI2_STEP : IN std_logic_vector(11 downto 0);
	START : IN std_logic;          
	DONE : OUT std_logic;
	SIN_OUT : OUT std_logic_vector(11 downto 0);
	COS_OUT : OUT std_logic_vector(11 downto 0)
	);
END COMPONENT;


COMPONENT vec_ram_32
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

  type state_t is (s_reset, s_getvec, s_parsevec, s_incvec, s_wait,
									 s_startline, s_waitline, 
									 s_startcircle, s_waitcircle, 
									 s_startsincos, s_waitsincos1, s_waitsincos2, 
									 s_startblankpulse, s_waitblankpulse,
									 s_startpoint, s_waitpoint, s_stop);
	signal state : state_t := s_reset;
									 
  type state_dac_t is (s_dac_idle, s_dac_prep_x, s_dac_write_x, s_dac_prep_y, s_dac_write_y, s_dac_write_z);
	signal state_dac: state_dac_t := s_dac_idle;

	signal beam, beam_saved: std_logic_vector(3 downto 0);
	signal defl_timer: std_logic_vector(11 downto 0);

	signal x_reg1, y_reg1, x_reg2, y_reg2: std_logic_vector(11 downto 0);
	signal x_offs, y_offs: std_logic_vector(11 downto 0);
	signal x_rot_mid, y_rot_mid: std_logic_vector(11 downto 0);

	signal cos_a, sin_a, rotation_a: std_logic_vector(11 downto 0);
	signal x_cos_a_mult, x_sin_a_mult, y_cos_a_mult, y_sin_a_mult: std_logic_vector(25 downto 0);
	signal x_cos_a, x_sin_a, y_cos_a, y_sin_a: std_logic_vector(13 downto 0);
	signal x_demux, y_demux: std_logic_vector(13 downto 0);
	signal x_rot_d1, y_rot_d1: std_logic_vector(13 downto 0);
	signal x_scale, y_scale: std_logic_vector(11 downto 0);	-- 1024 =100%
	signal x_scale_mult, y_scale_mult: std_logic_vector(25 downto 0);

	signal frequ_shifts: std_logic_vector(2 downto 0);
	
	signal start_line, line_done, start_circle, circle_done: std_logic;
	signal start_sincos, sincos_done: std_logic;	

	signal line_data: std_logic_vector(11 downto 0);			-- Circle Cosinus-Startbedingung (Y-Richtung)
	signal vec_ram_addr, vec_ram_return_addr: std_logic_vector(11 downto 0); 			-- zählt bis 1023
	signal vec_ram_data: std_logic_vector(31 downto 0); 
	signal vec_ram_x: std_logic_vector(11 downto 0); 
	signal vec_ram_y: std_logic_vector(11 downto 0); 
	signal vec_ram_cmd: std_logic_vector(7 downto 0); 
--	signal vec_ram_beam: std_logic_vector(3 downto 0); 
	signal vec_x1_cm: std_logic_vector(11 downto 0); 		-- X oder Circle Midpoint
	signal vec_y1_cm: std_logic_vector(11 downto 0); 		-- Y oder Circle Midpoint 
	signal vec_x2: std_logic_vector(11 downto 0); 
	signal vec_y2: std_logic_vector(11 downto 0); 
	signal vec_cw: std_logic_vector(11 downto 0);				-- Circle Winkel Count (825=Vollkreis)
	signal vec_sin: std_logic_vector(11 downto 0);			-- Circle Sinus-Startbedingung   (X-Richtung)
	signal vec_cos: std_logic_vector(11 downto 0);			-- Circle Cosinus-Startbedingung (Y-Richtung)

	signal x_circle, x_line, x_circle_offs, x_line_offs: std_logic_vector(11 downto 0);
	signal y_circle, y_line, y_circle_offs, y_line_offs: std_logic_vector(11 downto 0);
	signal x_point, x_point_offs: std_logic_vector(11 downto 0);
	signal y_point, y_point_offs: std_logic_vector(11 downto 0);
	
	signal strobe_tick, strobe_circle, strobe_line, strobe_point, strobe_move: std_logic;
	signal point_active, line_active, circle_active, move_active: std_logic;
	signal dac_rdy, dac_z_ena, load_point: std_logic;
	signal line_beam_valid, circle_beam_valid: std_logic;
	signal ve_enable: std_logic;
	
	signal circle_radius, circle_startval, circle_endval: std_logic_vector(11 downto 0);

	
	-- Vorteiler für Pause und Blank-Timeout, 50 MHz / 256 = 195 kHz, alle 5 µs
	signal prescaler: std_logic_vector(7 downto 0);
	signal prescaler_tick: std_logic;
	
	-- Impulsweite negativer Blank-Impuls für Z für Move und Blank-Timeout, 1 = 5µs 
	signal blankwidth_counter: std_logic_vector(7 downto 0);
	signal blankwidth_counter_loadval: std_logic_vector(7 downto 0):= x"10"; 
	
	signal pause_counter: std_logic_vector(11 downto 0);

	signal delay_z_count: std_logic_vector(11 downto 0);

	signal restart, restart_nosync: std_logic:= '0';
	signal restart_on_sync: std_logic:= '1';
	
	signal load_addr, next_start_addr: std_logic_vector(11 downto 0):= (others => '0'); -- zählt bis 4095
	signal load_data: std_logic_vector(31 downto 0); 		-- Daten von AVR
	signal wr_ram: std_logic_vector(0 downto 0); 				-- Schreib-Tick
	signal cmd_del1, inc_del1, rst_del1: std_logic;
	signal cmd_del2, inc_del2, inc_del3, rst_del2: std_logic;
	signal load_cmd: std_logic_vector(3 downto 0); 
	signal load_cmd_param: std_logic_vector(27 downto 0); 
	
	-- DAC direkt laden über Load-Command
	signal lc_dac_x, lc_dac_y: std_logic_vector(11 downto 0);
	signal lc_dac_z: std_logic_vector(3 downto 0);

	
begin

vec_ram : vec_ram_32
PORT MAP (
	clka => SYSCLK,
	wea => wr_ram,
	addra => load_addr(10 downto 0),  -- hier nur 1024 Adressen
	dina => LV_DATA,
	clkb => SYSCLK,
	addrb => vec_ram_addr(10 downto 0),
	doutb => vec_ram_data
);

-- Lade-Kommandos (LV_CMD = 1):
-- 31 (3) 24   23 (2) 16   15 (1)  8   7  (0)  0  (In Klammern: Byte von MCU-IF)
-- CCCC 0000   0000 0000   0000 PPPP   PPPP PPPP
-- CCCC YYYY   YYYY YYYY   ZZZZ XXXX   XXXX XXXX  (für Command 6 = direct DAC)
-- C = Command, P = Parameter
-- CCCC = 0 - Set Load Addr, nächste Lade-Adresse VECRAM (oder 0) in P-Wert
-- CCCC = 1 - Starte Vector Engine mit Reset-State, Loop nach nächstem SYNC
-- CCCC = 2 - Starte Vector Engine mit Reset-State, einmaliger Durchlauf
-- CCCC = 3 - Starte Vector Engine mit Reset-State, Loop wartet nicht auf SYNC
-- CCCC = 6 - Stop Vector Engine, DACs = YYYY YYYY YYYY 0ZZZ XXXX XXXX XXXX
-- CCCC = 7 - Stop Vector Engine, DACs = 0, 0, 0
-- CCCC = 8 - Set Auxiliary Port 0
-- CCCC = 9 - Set Auxiliary Port 1
-- CCCC = 12  Anzahl Pausentakte bei MOVE, 64 = 1,28µs, default 400 = 8µs			

wr_ram(0) <= inc_del3;						-- Schreib-Impuls verzögert
LV_ADDR <= load_addr;

load_counter : process(SYSCLK)
-- Adresszähler für Auto-Increment
begin
	if rising_edge(SYSCLK) then
		inc_del3 <= inc_del2;
		inc_del2 <= inc_del1;
		inc_del1 <= LV_INCWR;
		cmd_del2 <= cmd_del1;
		cmd_del1 <= LV_CMD;
		
		if (inc_del1 = '1') and (inc_del2 = '0') then	
			-- Nach Schreiben um 1 erhöhen
			load_addr <= load_addr + 1;
		end if;

		if (cmd_del1 = '1') and (cmd_del2 = '0') then	
			-- Load-Command LV_CMD
			load_cmd <= LV_DATA(31 downto 28);
			load_cmd_param <= LV_DATA(27 downto 0);
		end if;

		restart <= '0';
		if (cmd_del1 = '0') and (cmd_del2 = '1') then	
			-- nächster State *nach* LV_CMD-Impuls
			case load_cmd is	
				when "0000" =>	-- 0 = Set Load Addr
					load_addr <= load_cmd_param(11 downto 0);
				when "0001" =>	-- 1 = Start VE at Addr, wait for SYNC
					restart_on_sync <= '1';
					restart_nosync <= '0';
					ve_enable <= '1';
					-- restart <= '1';
					next_start_addr <= load_cmd_param(11 downto 0);
				when "0010" =>	-- 2 = Start VE at Addr, SingleRun				
					restart_on_sync <= '0';
					restart_nosync <= '0';
					restart <= '1';
					next_start_addr <= load_cmd_param(11 downto 0);
					ve_enable <= '1';
				when "0011" =>	-- 3 = Start VE at Addr, no wait			
					restart_on_sync <= '0';
					restart_nosync <= '1';
					restart <= '1';
					next_start_addr <= load_cmd_param(11 downto 0);
					ve_enable <= '1';
					
				when "0110" =>	
					-- 6 = Stop Vector Engine, 
					-- DACs direkt = YYYY YYYY YYYY 0ZZZ XXXX XXXX XXXX
					restart_on_sync <= '0';
					restart_nosync <= '0';
					ve_enable <= '0';
					next_start_addr <= x"000";
					lc_dac_x <= load_cmd_param(11 downto 0);
					lc_dac_y <= load_cmd_param(27 downto 16);
					lc_dac_z <= load_cmd_param(15 downto 12);
				when "0111" =>	-- 7 = Stop VE, DACs = 0
					restart_on_sync <= '0';
					restart_nosync <= '0';
					next_start_addr <= x"000";
					ve_enable <= '0';
					lc_dac_x <= (others => '0');
					lc_dac_y <= (others => '0');
					lc_dac_z <= (others => '0');
				when "1000" =>	-- 8 = Port 0 setzen
					PORT_0 <= load_cmd_param(7 downto 0);
				when "1001" =>	-- 9 = Port 1 setzen
					PORT_1 <= load_cmd_param(7 downto 0);
					
				when "1100" =>	
				  -- 12 = Anzahl Pausentakte (CRT-Blank) bei MOVE	
					blankwidth_counter_loadval <= load_cmd_param(blankwidth_counter_loadval'length-1 downto 0);
				when others =>
			end case;	
		end if;
  end if;
end process;

Inst_bresenham: bresenham PORT MAP(
	CLK => SYSCLK,
	LOAD_XY => start_line,
	X1 => x_reg1,
	Y1 => y_reg1,
	X2 => x_reg2,
	Y2 => y_reg2,
	DEFL_TIMER => defl_timer,
	STROBE => strobe_line,
--	DAC_ACK => dac_ack,
	X_VAL => x_line,
	Y_VAL => y_line,
	DAC_RDY => dac_rdy,
	BEAM_VALID => line_beam_valid,
	DONE => line_done
);	
	
Inst_biquad_circle: biquad_circle PORT MAP(
	CLK => SYSCLK,
	K_FREQU => frequ_shifts,
	PI_START => circle_startval,
	PI_END => circle_endval,
	DEFL_TIMER => defl_timer,
	LOAD_SCV => start_circle,
	OFS_X => x_reg1,	-- Offset X-Richtung
	OFS_Y => y_reg1,	-- Offset Y-Richtung
	RADIUS => circle_radius,
	STROBE => strobe_circle,
	DAC_RDY => dac_rdy,
	X_VAL => x_circle,
	Y_VAL => y_circle,
	BEAM_VALID => circle_beam_valid,
	DONE => circle_done
);

Inst_biquad_sincos: biquad_sincos PORT MAP(
	CLK => SYSCLK,
	PI2_STEP => rotation_a,
	START => start_sincos,
	DONE => sincos_done,
	SIN_OUT => sin_a,
	COS_OUT => cos_a
);

	
demux_registers : process (SYSCLK)
begin
	if rising_edge(SYSCLK) then
	  if (circle_active = '1') then
			x_demux <= (x_circle(11) & x_circle(11) & x_circle) - x_rot_mid;
			y_demux <= (y_circle(11) & y_circle(11) & y_circle) - y_rot_mid;
			strobe_tick <= strobe_circle;
		end if;
	  if (line_active = '1') then
			x_demux <= (x_line(11) & x_line(11) & x_line) - x_rot_mid;
			y_demux <= (y_line(11) & y_line(11) & y_line) - y_rot_mid;
			strobe_tick <= strobe_line;
		end if;
	  if (point_active = '1') then
			x_demux <= (x_point(11) & x_point(11) & x_point) - x_rot_mid;
			y_demux <= (y_point(11) & y_point(11) & y_point) - y_rot_mid;
			strobe_tick <= strobe_point;
		end if;
	  if (move_active = '1') then
			x_demux <= (x_reg1(11) & x_reg1(11) & x_reg1) - x_rot_mid;
			y_demux <= (y_reg1(11) & y_reg1(11) & y_reg1) - y_rot_mid;
			strobe_tick <= strobe_move;
		end if;
		dac_z_ena <= point_active or line_beam_valid or circle_beam_valid;
  end if;
end process;

-- Rotieren der Punkte um Nullpunkt über sin/cos
-- demux-Werte um 1 CLK delayed
-- Signed-Bit wird auch multipliziert, 
-- Ergebnis deshalb um 1 Bit nach unten verschoben
x_cos_a_mult <= x_demux * cos_a;
x_cos_a <= x_cos_a_mult(24 downto 11); 

x_sin_a_mult <= x_demux * sin_a;
x_sin_a <= x_sin_a_mult(24 downto 11); 

y_cos_a_mult <= y_demux * cos_a;
y_cos_a <= y_cos_a_mult(24 downto 11); 

y_sin_a_mult <= y_demux * sin_a;
y_sin_a <= y_sin_a_mult(24 downto 11); 

x_rot_d1 <= x_cos_a + x_rot_mid - y_sin_a;
y_rot_d1 <= x_sin_a + y_rot_mid + y_cos_a;

x_scale_mult <= x_rot_d1 * x_scale;
y_scale_mult <= y_rot_d1 * y_scale;

mux_dac : process (SYSCLK)
begin
	if rising_edge(SYSCLK) then
		-- DAC SEL und Wert werden mit steigender Flanke von DAC_WRN übernommen
		if strobe_tick = '1' then
			state_dac <= s_dac_prep_x;
			dac_rdy <= '0';
		end if;

		case state_dac is	
			when s_dac_idle =>
				DAC_WRN <= '1';
				dac_rdy <= '1';
			when s_dac_prep_x =>
				if ve_enable = '1' then
					DAC_MPX <= x_scale_mult(21 downto 10) + x_offs + 2048;	-- X-Ergebnis Skalierung/Rotation
				else
					DAC_MPX <= lc_dac_x; -- ist 0 bei Stop
				end if;
				DAC_SEL <= '0';
				DAC_WRN <= '0'; 
				state_dac <= s_dac_write_x;
			when s_dac_write_x =>
				DAC_WRN <= '1';
				state_dac <= s_dac_prep_y;
			when s_dac_prep_y =>
				if ve_enable = '1' then
					DAC_MPX <= y_scale_mult(21 downto 10) + y_offs + 2048;	-- Y-Ergebnis Skalierung/Rotation
				else
					DAC_MPX <= lc_dac_y; -- ist 0 bei Stop
				end if;
				DAC_SEL <= '1';
				DAC_WRN <= '0'; 
				state_dac <= s_dac_write_y;
			when s_dac_write_y =>
				DAC_WRN <= '1';
				state_dac <= s_dac_write_z;
			when s_dac_write_z =>
				if ve_enable = '1' then
					if dac_z_ena = '1' then
						DAC_Z <= beam;
					end if;
				else
					DAC_Z <= lc_dac_z; -- ist 0 bei Stop
				end if;
				state_dac <= s_dac_idle;
			when others =>
		end case;
		
		if (ve_enable = '1') and (dac_z_ena = '0') then
			DAC_Z <= (others => '0');
		end if;
		
	end if;
end process;


-- Vector Data:
-- 31 (3) 24   23 (2) 16   15 (1)  8   7  (0)  0       (In Klammern: Byte von MCU-IF)
-- CCCC YYYY   YYYY YYYY   CCCC XXXX   XXXX XXXX
-- C = Command, LSB in 15:12, MSB in 31:24  
-- Y = Y-Wertoder Kreisabschnitt-Ende,
-- B = Beam-Intensität (DACZ) 
-- X = X-Wert, Kreis-Radius, Kreisabschnitt-Start oder Adresse
-- Commands:
-- 0  - Setze Startpunkt oder Kreismitte X/Y absolut
-- 1  - Setze Startpunkt oder Kreismitte X/Y relativ
-- 2  - Zeichne Linie nach X/Y absolut
-- 3  - Zeichne Linie nach X/Y relativ
-- 4  - Setze Kreisabschnitt (Winkel) nach X-Wert, 825 = Vollkreis
-- 5  - Setze Kreis-SIN/COS, zeichne Kreis
-- 6  - Setze Offset für nächste Objekte, X/Y
-- 7  - Setze Rotations-Mittelpunkt für nächste Objekte, X/Y
-- 8  - Setze Rotation für nächste Objekte um Offset-Nullpunkt, X = Winkel in 2 * pi * 128
-- 9  - Setze Skalierung nach X/Y-Werten, $400 = 100%
-- 10 - Pause, X-Wert * 5µs
-- 11 - Dummy Cycle, NOP
-- 12 - Stop, warte auf Reset (Load-Command)
-- 13 - Jump/Loop, Ende der Vektoren, Start wieder mit Adresse X
-- 14 - Aufruf Subroutine an Adresse X
-- 15 - Return aus Subroutine

-- 16 - Set Beam Intenity 0..15 (in X-Wert) für alle folgenden Draw-Funktionen
-- 17 - Set Deflection Timer 0..4095 (Vektor-Schreibgeschwindigkeit)

-- 18 - Point, Setze DAC X/Y direkt, absolut, mit anschließender Pause (letzter Wert aus Command 10)
-- 19 - SKIP, JUMP Relativ

vec_ram_cmd <= vec_ram_data(31 downto 28) & vec_ram_data(15 downto 12);
vec_ram_x <= vec_ram_data(11 downto 0);
vec_ram_y <= vec_ram_data(27 downto 16);				  
--vec_ram_beam <= vec_ram_data(15 downto 12);
VEC_ADDR <= vec_ram_addr;

states : process (SYSCLK, SYNC, restart)
-- Adresszähler für Auto-Increment
begin
	if rising_edge(SYSCLK) then
		start_line <= '0';
		start_circle <= '0';
		start_sincos <= '0';
		strobe_point <= '0';
		strobe_move <= '0';
		prescaler <= prescaler + 1;
		-- Prescaler-Tick für Pausen-Timer
		if prescaler = 0 then
			if pause_counter /= 0 then
				pause_counter <= pause_counter - 1;
			end if;	
			
--			if blanktimeout_counter /= 0 then
--				blanktimeout_counter <= blanktimeout_counter - 1;
--			end if;		
	
			if blankwidth_counter /= 0 then
				blankwidth_counter <= blankwidth_counter - 1;
			end if;
		end if;

		case state is	
			when s_reset =>
				vec_ram_addr <= next_start_addr;
				x_offs <= (others => '0');
				y_offs <= (others => '0');
				x_rot_mid <= (others => '0');
				y_rot_mid <= (others => '0');
				rotation_a <= (others => '0');
				x_reg1 <= (others => '0');
				y_reg1 <= (others => '0');
				x_reg2 <= (others => '0');
				y_reg2 <= (others => '0');
				x_scale <= x"400";
				y_scale <= x"400";
				circle_radius <= x"010";
				frequ_shifts <= "100";
			  defl_timer <= x"010";
				beam <= "0000";
				line_active <= '0';
				circle_active <= '0';
				point_active <= '0';
				move_active <= '0';
				state <= s_getvec;
--				blanktimeout_counter <= (others => '1');
				
			when s_getvec =>
				-- Warte auf RAM-Daten
			  state <= s_parsevec;

			when s_parsevec =>				
				-- Command Parser
				case vec_ram_cmd is	
				when x"00" =>							
					-- 0 - Setze Startpunkt oder Kreismitte X/Y absolut
					x_reg1 <= vec_ram_x;
					x_reg2 <= vec_ram_x;
					y_reg1 <= vec_ram_y;
					y_reg2 <= vec_ram_y;
					move_active <= '1';
					strobe_move <= '1';
					state <= s_startblankpulse;
				when x"01" =>							
					-- 1 - Setze Startpunkt oder Kreismitte X/Y relativ
					x_reg1 <= x_reg1 + vec_ram_x;
					x_reg2 <= x_reg2 + vec_ram_x;
					y_reg1 <= y_reg1 + vec_ram_y;
					y_reg2 <= y_reg2 + vec_ram_y;
					move_active <= '1';
					strobe_move <= '1';
					state <= s_startblankpulse;
				when x"02" =>
					-- 2 - Zeichne Linie nach X/Y absolut
					x_reg1 <= x_reg2;
					y_reg1 <= y_reg2;
					x_reg2 <= vec_ram_x;
					y_reg2 <= vec_ram_y;
				  start_line <= '1';	  
					state <= s_startline;
				when x"03"  =>		
					-- 3 - Zeichne Linie nach X/Y relativ
					x_reg1 <= x_reg2;
					y_reg1 <= y_reg2;
					x_reg2 <= x_reg2 + vec_ram_x;
					y_reg2 <= y_reg2 + vec_ram_y;
				  start_line <= '1';	  
					state <= s_startline;
				when x"04" =>							
					-- 4  - Setze Kreisabschnitt (Winkel) nach XY-Werten, 825 = Vollkreis bei 7 shifts
					circle_startval <= vec_ram_x;
					circle_endval <= vec_ram_y;
					state <= s_incvec;
				when x"05" =>							
					-- 5  - Setze Kreis-Radius nach X-Wert und Auflösung nach Y-Wert, zeichne Kreis
					circle_radius <= vec_ram_x;
					frequ_shifts <= vec_ram_y(2 downto 0);
				  start_circle <= '1';	  
					state <= s_startcircle;
				when x"06" =>							
					-- 6 - Setze Offset für nächste Objekte, X/Y
					x_offs <= vec_ram_x;
					y_offs <= vec_ram_y;
					state <= s_incvec;
				when x"07" =>							
					-- 7 - Setze Rotations-Mittelpunkt für nächste Objekte, X/Y
					x_rot_mid <= vec_ram_x;
					y_rot_mid <= vec_ram_y;
					state <= s_incvec;
				when x"08" =>							
					-- 8 - Setze Rotation für nächste Objekte um Offset-Nullpunkt, X = Winkel in 2 * pi * 128
					rotation_a <= vec_ram_x;
					state <= s_startsincos;
				when x"09" =>							
					-- 9 - Setze Skalierung für nächste Objekte, X/Y
					x_scale <= vec_ram_x;
					y_scale <= vec_ram_y;
					state <= s_incvec;
				when x"0A" =>							
				  -- 10 - Pause, X * 0,02ms
			    BEAM_ON <= '0';
					pause_counter <= vec_ram_x;
					state <= s_waitpoint;
				when x"0B" =>							
				  -- 11 - NOP wenn X=0
					state <= s_incvec;
				when x"0C" =>							
					-- 12 - Stop, warte auf Reset, state ändert sich nicht
					state <= s_stop;
				when x"0D" =>							
					-- 13 - Jump to Addr X
				  vec_ram_addr <= vec_ram_x;
					state <= s_getvec;
				when x"0E" =>							
					-- 14 - Aufruf Subroutine an Adresse X
				  vec_ram_return_addr <= vec_ram_addr;
				  vec_ram_addr <= vec_ram_x;
					state <= s_getvec;
				when x"0F" =>							
					-- 15 - Return from Subroutine
				  vec_ram_addr <= vec_ram_return_addr;
					state <= s_incvec;
				when x"10" =>							
					-- 16 - Set Beam intensity
				  beam <= vec_ram_x(3 downto 0);
					beam_saved <= vec_ram_x(3 downto 0);
					state <= s_incvec;
				when x"11" =>							
					-- 17 - Set Write Speed Timer
				  defl_timer <= vec_ram_x;
					state <= s_incvec;
				when x"12" =>							
					-- 18 - Set DAC Point
				  x_point <= vec_ram_x;
				  y_point <= vec_ram_y;
					pause_counter <= defl_timer;
					state <= s_startpoint;
				when x"13" =>							
					-- 19 - SKIP, Jump relativ
				  vec_ram_addr <= vec_ram_addr + vec_ram_x;
					state <= s_getvec;
				when others =>
				  -- Dummy Cycle, NOP
					state <= s_incvec;
				end case;	
				-- Ende Command Parser
			
			when s_startpoint =>	
				-- Pausenzähler auf 0 dekrementieren
				state <= s_waitpoint;
			when s_waitpoint =>	
				-- Pausenzähler auf 0 dekrementieren
		    BEAM_ON <= '1';
				strobe_point <= '1';
				point_active <= '1';
				if pause_counter = 0 then
					state <= s_incvec;
				  point_active <= '0';
				end if;
				
			when s_startline =>	
			  BEAM_ON <= '1';
				line_active <= '1';
				state <= s_waitline;
			when s_waitline =>
				-- Warte auf Beendigung des Linien-Zeichenvorgangs
				if (line_done = '1') then
					state <= s_incvec;
				end if;
				
			when s_startcircle =>	
			  BEAM_ON <= '1';
				circle_active <= '1';
				state <= s_waitcircle;
			when s_waitcircle =>	
				-- Warte auf Beendigung des Kreis-Zeichenvorgangs
				if (circle_done = '1') then		
					-- Kreissegment immer mit Blank-Impuls abschließen
					state <= s_startblankpulse;
				end if;
				
			when s_startsincos =>	
				start_sincos <= '1';	  
				state <= s_waitsincos1;
			when s_waitsincos1 =>	
				state <= s_waitsincos2;
			when s_waitsincos2 =>	
				-- Warte auf Beendigung des Kreis-Zeichenvorgangs
				if (sincos_done = '1') then		
					state <= s_incvec;
				end if;
			
			when s_incvec =>
				  vec_ram_addr <= vec_ram_addr + 1;
					state <= s_getvec;
				
			when s_startblankpulse =>
			  BEAM_ON <= '0';
				line_active <= '0';
				circle_active <= '0';
				point_active <= '0';
				move_active <= '0';
				blankwidth_counter <= blankwidth_counter_loadval;
				state <= s_waitblankpulse;
			
			when s_waitblankpulse => 
				-- Schwarzschulter für nicht gleichspannungsgekoppelte Z-Eingänge
				if blankwidth_counter = 0 then
				  vec_ram_addr <= vec_ram_addr + 1;
					state <= s_getvec;
				  beam <= beam_saved;
			    BEAM_ON <= '1';
				end if;
				
			when s_stop =>
				-- state bleibt
				line_active <= '0';
				circle_active <= '0';
				point_active <= '0';
				move_active <= '0';
			  BEAM_ON <= '0';
				if (restart_nosync = '1') or ((restart_on_sync = '1') and (SYNC = '1')) then
					state <= s_reset;
					DONE <= '0';
				else
			    DONE <= '1';
				end if;

			when others =>
				state <= s_incvec;
		end case;	
		
		if (ve_enable = '0') or (restart = '1') then
			line_active <= '0';
			circle_active <= '0';
			point_active <= '0';
			BEAM_ON <= '0';
			state <= s_reset;
			DONE <= '0';
		end if;
		
  end if;
end process;

end Behavioral;

