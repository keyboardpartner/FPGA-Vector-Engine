--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:03:04 09/16/2022
-- Design Name:   
-- Module Name:   E:/AsteroidsClock/FPGA ctlab/tb_bresenham.vhd
-- Project Name:  Main
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bresenham
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
 
ENTITY tb_bresenham IS
END tb_bresenham;
 
ARCHITECTURE behavior OF tb_bresenham IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	COMPONENT bresenham
	PORT(
		CLK : IN  std_logic;
		LOAD_XY : IN  std_logic;
		X1 : IN  std_logic_vector(11 downto 0);
		Y1 : IN  std_logic_vector(11 downto 0);
		X2 : IN  std_logic_vector(11 downto 0);
		Y2 : IN  std_logic_vector(11 downto 0);
		DEFL_TIMER: in std_logic_vector(11 downto 0);
		BEAM_VALID : out std_logic; 	-- positive Logik
		DONE : out std_logic;
    DAC_RDY : in std_logic;
		STROBE: out std_logic;		-- Tick, Punkt fertig
		X_VAL : out std_logic_vector(11 downto 0);
		Y_VAL : out std_logic_vector(11 downto 0)
	);
	END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal LOAD_XY : std_logic := '0';
   signal DEFL_TIMER : std_logic_vector(11 downto 0) := x"008";
   signal X1 : std_logic_vector(11 downto 0) := (others => '0');
   signal Y1 : std_logic_vector(11 downto 0) := (others => '0');
   signal X2 : std_logic_vector(11 downto 0) := (others => '0');
   signal Y2 : std_logic_vector(11 downto 0) := (others => '0');
   signal DAC_RDY : std_logic := '1';

 	--Outputs
   signal DONE, BEAM_VALID, STROBE : std_logic;
   signal X_VAL, Y_VAL : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
-- Instantiate the Unit Under Test (UUT)
uut: bresenham PORT MAP (
			CLK => CLK,
			LOAD_XY => LOAD_XY,
			X1 => X1,
			Y1 => Y1,
			X2 => X2,
			Y2 => Y2,
			DEFL_TIMER => DEFL_TIMER,
			DONE => DONE,
			BEAM_VALID => BEAM_VALID,
      DAC_RDY => DAC_RDY,
			STROBE => STROBE,
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
	-- hold reset state for 100 ns.
  X1 <= x"010";
  Y1 <= x"010";
  X2 <= x"013";
  Y2 <= x"017";
	wait for CLK_period * 2;
	wait for CLK_period / 4;
	LOAD_XY <= '1';
	wait for CLK_period;
	LOAD_XY <= '0';
	

	wait;
end process;

END;
