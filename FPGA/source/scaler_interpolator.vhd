----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Carsten Meyer
-- 
-- Create Date:  17:17:17 04/27/2008 
-- Design Name: 
-- Module Name:  MPX10 - Behavioral 
-- Project Name: ct-Lab AsteroidsClock
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity scaler_interpolator is
    Port (
		   SYSCLK: in std_logic;
		   BEAM_ON: in std_logic;
		   BEAM_HI: in std_logic;
		   REG: in std_logic_vector(1 downto 0); -- wählt X1 (00), Y1 (01), X2 (10), Y2 (11), Linie startet mit Y2
			 WRN_IN: in std_logic; -- neg-Logik!
       D_IN : in  STD_LOGIC_VECTOR (7 downto 0);
		   D_OUT : out STD_LOGIC_VECTOR (11 downto 0);
		   DONE: out std_logic;
		   DAC_Z : out STD_LOGIC_VECTOR (2 downto 0);
		   SEL_OUT: out std_logic;
			 WRN_OUT: out std_logic
			 );
end scaler_interpolator;

architecture Behavioral of scaler_interpolator is

COMPONENT bresenham
PORT(
	CLK : IN std_logic;
	LOAD_XY : IN std_logic;
	X1 : IN std_logic_vector(11 downto 0);
	Y1 : IN std_logic_vector(11 downto 0);
	X2 : IN std_logic_vector(11 downto 0);
	Y2 : IN std_logic_vector(11 downto 0);          
	DAC_WR : OUT std_logic;
	DAC_SEL : OUT std_logic;
	DONE : OUT std_logic;
	MPX_OUT : OUT std_logic_vector(11 downto 0)
	);
END COMPONENT;

COMPONENT biquad_oscillator
PORT(
	CLK : IN std_logic;
	VAL_COUNT : IN std_logic_vector(15 downto 0);
	LOAD_SCV : IN std_logic;
	SIN_START : IN std_logic_vector(11 downto 0);
	COS_START : IN std_logic_vector(11 downto 0);          
	MPX_OUT : OUT std_logic_vector(11 downto 0);
	DAC_WR : OUT std_logic;
	DAC_SEL : OUT std_logic;
	DONE : OUT std_logic;
	SIN_OUT : OUT std_logic_vector(11 downto 0);
	COS_OUT : OUT std_logic_vector(11 downto 0)
	);
END COMPONENT;


	signal dacz_del: std_logic_vector(2 downto 0); 

	signal x_reg1, y_reg1, x_reg2, y_reg2: std_logic_vector(11 downto 0);

	signal mpx_circle, mpx_line: std_logic_vector(11 downto 0);
	signal circle_done, line_done, start, start_del: std_logic;
	signal line_wrn, line_sel: std_logic;
	signal wrn_del, wrn_del2: std_logic;
	signal sync_counter: std_logic_vector(3 downto 0); -- zählt bis 32
	signal sync_tick: std_logic;

begin

dacz_del <= "000" when line_done = '1' else BEAM_ON & '0' & BEAM_HI;

main: process(SYSCLK)
begin
  if rising_edge(SYSCLK) then
	  start_del <= start;
		start <= '0';
--		if start_del = '1' then
--		end if;
--		if line_done = '1' then
--			dacz_del(0) <= '0';
--			dacz_del(1) <= '0';
--			dacz_del(2) <= '0';
--		else
--			dacz_del(0) <= BEAM_HI;
--			dacz_del(1) <= '0';
--			dacz_del(2) <= BEAM_ON;
--		end if;
	  if (wrn_del = '0') and (wrn_del2 = '1') then
		  case REG is	-- übernehme aus D_IN
				when "00" =>
					x_reg1 <= D_IN & "0000";
				when "01" =>
					y_reg1 <= D_IN & "0000";
				when "10" =>
					x_reg2 <= D_IN & "0000";
				when others =>
					y_reg2 <= D_IN & "0000";
				  start <= '1';
			end case;	
		end if;
		
    wrn_del2<= wrn_del;	    
    wrn_del <= WRN_IN;
		
  end if;
end process;

Inst_bresenham: bresenham PORT MAP(
	CLK => SYSCLK,
	LOAD_XY => start,
	X1 => x_reg1,
	Y1 => y_reg1,
	X2 => x_reg2,
	Y2 => y_reg2,
	DAC_WR => WRN_OUT,
	DAC_SEL => SEL_OUT,
	DONE => line_done,
	MPX_OUT => mpx_line
);

--Inst_biquad_oscillator: biquad_oscillator PORT MAP(
--	CLK => SYSCLK,
--	VAL_COUNT => x"0325", -- $325 = Vollkreis
--	LOAD_SCV => circle_done,
--	SIN_START => x"500",
--	COS_START => x"000",
--	MPX_OUT => mpx_circle,
--	DAC_WR => WRN_OUT,
--	DAC_SEL => SEL_OUT,
--	DONE => circle_done,
--	SIN_OUT => open,
--	COS_OUT => open
--);
	
--D_OUT <= mpx_circle + x"800";
D_OUT <= mpx_line + x"800";  -- Offset addieren
DONE <= line_done;

DAC_Z <= dacz_del;

end Behavioral;

