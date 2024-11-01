--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:36:19 09/20/2022
-- Design Name:   
-- Module Name:   E:/AsteroidsClock/FPGA ctlab/tb_spi32.vhd
-- Project Name:  Main
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SPI32
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
 
ENTITY tb_spi32 IS
END tb_spi32;
 
ARCHITECTURE behavior OF tb_spi32 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SPI32
    PORT(
         SYSCLK : IN  std_logic;
         SCK : IN  std_logic;
         MOSI : IN  std_logic;
         DS_N : IN  std_logic;
         RS_N : IN  std_logic;
         MISO : INOUT  std_logic;
         RSEL : OUT  std_logic_vector(7 downto 0);
         STROBE : OUT  std_logic;
         DATA_LC : OUT  std_logic_vector(31 downto 0);
         Q1_CONF : OUT  std_logic_vector(7 downto 0);
         Q2_CONF : OUT  std_logic_vector(7 downto 0);
         D0_STATUS : IN  std_logic_vector(11 downto 0);
         D3 : IN  std_logic_vector(31 downto 0);
         RST_LC0 : OUT  std_logic;
         INC_LC0 : OUT  std_logic;
         RST_LC1 : OUT  std_logic;
         INC_LC1 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal SYSCLK : std_logic := '0';
   signal SCK : std_logic := '1';
   signal MOSI : std_logic := '0';
   signal DS_N : std_logic := '1';
   signal RS_N : std_logic := '1';
   signal D0_STATUS : std_logic_vector(11 downto 0) := (others => '0');
   signal D3 : std_logic_vector(31 downto 0) := (others => '0');

	--BiDirs
   signal MISO : std_logic;

 	--Outputs
   signal RSEL : std_logic_vector(7 downto 0);
   signal STROBE : std_logic;
   signal DATA_LC : std_logic_vector(31 downto 0);
   signal Q1_CONF : std_logic_vector(7 downto 0);
   signal Q2_CONF : std_logic_vector(7 downto 0);
   signal RST_LC0 : std_logic;
   signal INC_LC0 : std_logic;
   signal RST_LC1 : std_logic;
   signal INC_LC1 : std_logic;

   -- Clock period definitions
   constant SYSCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SPI32 PORT MAP (
          SYSCLK => SYSCLK,
          SCK => SCK,
          MOSI => MOSI,
          DS_N => DS_N,
          RS_N => RS_N,
          MISO => MISO,
          RSEL => RSEL,
          STROBE => STROBE,
          DATA_LC => DATA_LC,
          Q1_CONF => Q1_CONF,
          Q2_CONF => Q2_CONF,
          D0_STATUS => D0_STATUS,
          D3 => D3,
          RST_LC0 => RST_LC0,
          INC_LC0 => INC_LC0,
          RST_LC1 => RST_LC1,
          INC_LC1 => INC_LC1
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
		wait for 55ns;	
		RS_N <= '0';
		MOSI <= '1';
		for ii in 0 to 15 loop
		--report("r_Data at Index " & integer'image(ii) & " is " & integer'image(r_Data(ii)));
			wait for 23 ns;
			SCK <= '0';
			if ii = 1 then
				MOSI <= '0';
			end if;			  			
			if ii = 15 then
				MOSI <= '1';
			end if;			  			
			wait for 23 ns;
			SCK <= '1';
		end loop;
		wait for 23 ns;
		SCK <= '1';
		wait for 42 ns;
		RS_N <= '1';
		wait for 40 ns;
		DS_N <= '0';
		MOSI <= '0';
		for ii in 0 to 31 loop
		----      report("r_Data at Index " & integer'image(ii) & " is " &
		----             integer'image(r_Data(ii)));
			wait for 23 ns;
			SCK <= '0';
			if ii = 29 then
				MOSI <= '1';
			end if;			  			
			wait for 23 ns;
			SCK <= '1';
		end loop;
		wait for 23 ns;
		SCK <= '1';
		wait for 40 ns;
		DS_N <= '1';

		wait;
 end process;

END;
