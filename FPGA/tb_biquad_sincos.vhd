--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:54:20 09/19/2022
-- Design Name:   
-- Module Name:   E:/AsteroidsClock/FPGA ctlab/tb_biquad_sincos.vhd
-- Project Name:  Main
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: biquad_sincos
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
USE ieee.numeric_std.ALL;
 
ENTITY tb_biquad_sincos IS
END tb_biquad_sincos;
 
ARCHITECTURE behavior OF tb_biquad_sincos IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT biquad_sincos
    PORT(
         CLK : IN  std_logic;
         PI2_STEP : IN  std_logic_vector(11 downto 0);
         START : IN  std_logic;
         DONE : OUT  std_logic;
         SIN_OUT : OUT  std_logic_vector(11 downto 0);
         COS_OUT : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal PI2_STEP : std_logic_vector(11 downto 0) := (others => '0');
   signal START : std_logic := '0';

 	--Outputs
   signal DONE : std_logic;
   signal SIN_OUT : std_logic_vector(11 downto 0);
   signal COS_OUT : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: biquad_sincos PORT MAP (
          CLK => CLK,
          PI2_STEP => PI2_STEP,
          START => START,
          DONE => DONE,
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
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 20 ns;	
			PI2_STEP <= std_logic_vector(to_signed(0, PI2_STEP'length));
      wait for CLK_period/2;
			START <= '1';
      wait for CLK_period;
			START <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
