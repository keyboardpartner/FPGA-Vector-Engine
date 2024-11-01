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

entity MPX10_12 is
    Port ( Q : out STD_LOGIC_VECTOR (11 downto 0);
           DA : in  STD_LOGIC_VECTOR (9 downto 0);
           DB : in  STD_LOGIC_VECTOR (11 downto 0);
           SEL : in  STD_LOGIC);
end MPX10_12;

architecture Behavioral of MPX10_12 is

begin

process(DA,DB,SEL)
begin
  if SEL='1' then
    Q<=DB;
  else
    Q<=DA & "00";
  end if;
end process;

end Behavioral;

