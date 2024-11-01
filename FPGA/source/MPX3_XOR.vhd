----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Carsten Meyer
-- 
-- Create Date:  17:17:17 04/27/2008 
-- Design Name: 
-- Module Name:  MPX3_XOR - Behavioral 
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

entity MPX3_XOR is
    Port ( Q : out STD_LOGIC_VECTOR (3 downto 0);
           DA : in  STD_LOGIC_VECTOR (3 downto 0);  -- Asteroids
					 BEAM_ON_AST : in  STD_LOGIC;
           DV : in  STD_LOGIC_VECTOR (3 downto 0);  -- Vector Engine
					 BEAM_ON_VEC : in  STD_LOGIC;
           SEL : in  STD_LOGIC;
			  INVERT : in  STD_LOGIC);
end MPX3_XOR;

architecture Behavioral of MPX3_XOR is

	signal ast_z, vec_z: std_logic_vector (3 downto 0);
	signal ast_on, vec_on: std_logic;

begin

-- für Asteroids 
ast_on <= (DA(3) or DA(2) or DA(1) or DA(0)) and BEAM_ON_AST;
ast_z <= BEAM_ON_AST & DA(3) & DA(2) & (DA(1) or DA(0)) when ast_on = '1' 
			else "0000"; 

-- für Vector Engine
vec_on <= (DV(3) or DV(2) or DV(1) or DV(0)) and BEAM_ON_VEC;
vec_z <= DV when vec_on = '1' else "0000"; 

process(vec_z, ast_z, SEL, INVERT)
begin
	if INVERT='1' then
		if SEL='1' then
				Q<= not vec_z;
			else
				Q<= not ast_z;
		end if;
	else
		if SEL='1' then
				Q<= vec_z;
			else
				Q<= ast_z; 
		end if;
	end if;
end process;
end Behavioral;

