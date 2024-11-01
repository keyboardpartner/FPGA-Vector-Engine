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

entity scaler is
    Port ( 
		   D_OUT : out STD_LOGIC_VECTOR (9 downto 0);
       D_IN : in  STD_LOGIC_VECTOR (7 downto 0)
			 );
end scaler;



architecture Behavioral of scaler is

signal mult_temp: std_logic_vector(15 downto 0);

begin

D_OUT <= ('0' & D_IN(7 downto 0) & '0') + D_IN(7 downto 0) + 128;


end Behavioral;

