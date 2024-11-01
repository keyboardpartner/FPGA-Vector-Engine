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
 
ENTITY tb_biquad_oscillator IS
END tb_biquad_oscillator;
 
ARCHITECTURE behavior OF tb_biquad_oscillator IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	COMPONENT biquad_oscillator
	PORT(
		CLK : IN  std_logic;
		LOAD_SCV : IN  std_logic;
		VAL_COUNT : std_logic_vector(11 downto 0) := (others => '0');
		SIN_START : IN  std_logic_vector(11 downto 0);
		COS_START : IN  std_logic_vector(11 downto 0);
		OFS_X	: in std_logic_vector (11 downto 0);	-- Offset X-Richtung
		OFS_Y	: in std_logic_vector (11 downto 0);	-- Offset Y-Richtung
		DAC_WR: out std_logic;	 
		DAC_SEL: out std_logic;	 
		DONE: out std_logic;	 
		MPX_OUT : OUT  std_logic_vector(11 downto 0);
		SIN_OUT : OUT  std_logic_vector(11 downto 0);
		COS_OUT : OUT  std_logic_vector(11 downto 0)
		);
	END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal VAL_COUNT : std_logic_vector(11 downto 0) := (others => '0');
   signal LOAD_SCV : std_logic := '0';
   signal SIN_START, COS_START, OFS_X, OFS_Y : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal DAC_WR: std_logic;	 
   signal DAC_SEL: std_logic;	 
   signal DONE: std_logic;	 
   signal MPX_OUT : std_logic_vector(11 downto 0);
   signal SIN_OUT : std_logic_vector(11 downto 0);
   signal COS_OUT : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: biquad_oscillator PORT MAP (
          CLK => CLK,
          LOAD_SCV => LOAD_SCV,
          VAL_COUNT => VAL_COUNT,
          SIN_START => SIN_START,
          COS_START => COS_START,
					OFS_X => OFS_X,
					OFS_Y => OFS_Y,
          DAC_WR => DAC_WR,
          DAC_SEL => DAC_SEL,
          DONE => DONE,
          MPX_OUT => MPX_OUT,
          SIN_OUT => SIN_OUT,
          COS_OUT => COS_OUT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
	 
   LOAD_SCV <= DONE;

   -- Stimulus process
   stim_proc: process
   begin		
			SIN_START <= x"3e8";
			VAL_COUNT <= x"050";
      wait for CLK_period;
      wait for CLK_period/2;
			LOAD_SCV <= '1';
      wait for CLK_period;
			LOAD_SCV <= '0';
      wait;
   end process;

END;
