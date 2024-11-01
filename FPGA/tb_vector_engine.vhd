--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:51:55 09/17/2022
-- Design Name:   
-- Module Name:   E:/AsteroidsClock/FPGA ctlab/tb_vector_engine.vhd
-- Project Name:  Main
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: vector_engine
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
 
ENTITY tb_vector_engine IS
END tb_vector_engine;
 
ARCHITECTURE behavior OF tb_vector_engine IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT vector_engine
    PORT(
         SYSCLK : IN  std_logic;
 		 SYNC: in std_logic;
         LV_INCWR : IN  std_logic;
         LV_CMD : IN  std_logic;
         LV_DATA : IN  std_logic_vector(31 downto 0);
        DAC_MPX : OUT  std_logic_vector(11 downto 0);
         DONE : OUT  std_logic;
         DAC_Z : OUT  std_logic_vector(2 downto 0);
         DAC_SEL : OUT  std_logic;
         DAC_WRN : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal SYSCLK : std_logic := '0';
   signal LV_INCWR : std_logic := '0';
   signal SYNC : std_logic := '1';
   signal LV_CMD : std_logic := '0';
   signal LV_DATA : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal DAC_MPX : std_logic_vector(11 downto 0);
   signal DONE : std_logic;
   signal DAC_Z : std_logic_vector(2 downto 0);
   signal DAC_SEL : std_logic;
   signal DAC_WRN : std_logic;

   -- Clock period definitions
   constant SYSCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: vector_engine PORT MAP (
          SYSCLK => SYSCLK,
          LV_INCWR => LV_INCWR,
          SYNC => SYNC,
          LV_CMD => LV_CMD,
          LV_DATA => LV_DATA,
          DAC_MPX => DAC_MPX,
          DONE => DONE,
          DAC_Z => DAC_Z,
          DAC_SEL => DAC_SEL,
          DAC_WRN => DAC_WRN
        );

   -- Clock process definitions
   SYSCLK_process :process
   begin
		SYSCLK <= '0';
		wait for SYSCLK_period/2;
		SYSCLK <= '1';
		wait for SYSCLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
	 
      -- hold reset state for 100 ns.
--			LV_CMD <= '1';
--      wait for 30 ns;	
--			LV_CMD <= '0';
--      wait for SYSCLK_period*5;
--			LV_DATA <= x"55";
--      wait for 30 ns;	
--			wait;
--			LV_INCWR <= '1';
--      wait for 20 ns;	
--			LV_INCWR <= '0';
--      wait for 20 ns;	
--			LV_INCWR <= '1';
--      wait for 20 ns;	
--			LV_INCWR <= '0';
--      wait for 20 ns;	
--			LV_INCWR <= '1';
--      wait for 20 ns;	
--			LV_INCWR <= '0';
--      wait for 20 ns;	
--			LV_INCWR <= '1';
--      wait for 20 ns;	
--			LV_INCWR <= '0';
--      wait for 20 ns;	
--			LV_DATA <= x"33";
--      wait for 20 ns;	
-- 			LV_INCWR <= '1';
--      wait for 20 ns;	
--			LV_INCWR <= '0';
--      wait for 20 ns;	
--			LV_INCWR <= '1';
--      wait for 20 ns;	
--			LV_INCWR <= '0';
--      wait for 20 ns;	
--			LV_INCWR <= '1';
--      wait for 20 ns;	
--			LV_INCWR <= '0';
--      wait for 20 ns;	
			

      -- insert stimulus here 

      wait;
   end process;

END;
