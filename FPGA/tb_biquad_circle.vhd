--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   07:17:33 09/16/2022
-- Design Name:   
-- Module Name:   E:/AsteroidsClock/FPGA ctlab/tb_biquad_oscillator.vhd
-- Project Name:  Main
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: biquad_oscillator
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_biquad_circle IS
END tb_biquad_circle;
 
ARCHITECTURE behavior OF tb_biquad_circle IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	COMPONENT biquad_circle
	PORT(
		CLK : IN  std_logic;
		LOAD_SCV : IN  std_logic;
		K_FREQU: in std_logic_vector (2 downto 0); -- Shifts 1..7, bestimmt Oszillatorfrequenz, 1 = höchste, 7 = niedrigste 
		PI_START : IN  std_logic_vector(11 downto 0);
		PI_End : IN  std_logic_vector(11 downto 0);
		DEFL_TIMER: in std_logic_vector(11 downto 0);			-- Verlangsamer für Vektor-Display
		OFS_X	: in std_logic_vector (11 downto 0);	-- Offset X-Richtung
		OFS_Y	: in std_logic_vector (11 downto 0);	-- Offset Y-Richtung
		RADIUS	: in std_logic_vector (11 downto 0);	-- Startbedingung Position X-Richtung
    BEAM_VALID: out std_logic;		
		STROBE: out std_logic;   -- Tick, Punkt fertig
    DAC_RDY : in std_logic;
		X_VAL : out std_logic_vector(11 downto 0);
		Y_VAL : out std_logic_vector(11 downto 0);
		DONE: out std_logic	 -- kann auch mit LOAD_SCV verbunden sein für selbsttätigen Refresh
		);
	END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal K_FREQU : std_logic_vector(2 downto 0) := "100";
   signal VAL_COUNT : std_logic_vector(11 downto 0) := (others => '0');
   signal DEFL_TIMER : std_logic_vector(11 downto 0) := x"008";
   signal LOAD_SCV : std_logic := '0';
   signal DAC_RDY : std_logic := '1';
   signal PI_START, PI_END, OFS_X, OFS_Y, RADIUS : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal STROBE, DONE, BEAM_VALID: std_logic;	 
   signal X_VAL, Y_VAL : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: biquad_circle PORT MAP (
          CLK => CLK,
          LOAD_SCV => LOAD_SCV,
          K_FREQU => K_FREQU,
          PI_START => PI_START,
          PI_END => PI_END,
					OFS_X => OFS_X,
					OFS_Y => OFS_Y,
					RADIUS => RADIUS,
					DEFL_TIMER => DEFL_TIMER,
          BEAM_VALID => BEAM_VALID,
          DAC_RDY => DAC_RDY,
          STROBE => STROBE,
          DONE => DONE,
          X_VAL => X_VAL,
          Y_VAL => Y_VAL
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
	 

   -- Stimulus process
   stim_proc: process
   begin		
			PI_START <= x"008";
			PI_END <= x"018";
			RADIUS <= x"100";
      wait for CLK_period;
      wait for CLK_period/2;
			LOAD_SCV <= '1';
      wait for CLK_period;
			LOAD_SCV <= '0';
      wait;
   end process;

END;
