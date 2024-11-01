----------------------------------------------------------------------------------
-- Company: 
-- Engineer: C. Meyer - cm@ct.de
-- 
-- Create Date:    12:39:23 04/30/2008 
-- Design Name:    Frequenzteiler 49.152 MHz auf 50 Hz
-- Module Name:    Teiler50 - Behavioral 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Teiler50 is
    Port ( SYSCLK50 : in  STD_LOGIC;
           TICK_50HZ : out  STD_LOGIC;
           TICK_100HZ : out  STD_LOGIC;
           SQW_50HZ : out  STD_LOGIC);
end Teiler50;

architecture behave of Teiler50 is

signal count: Integer range 0 to 1000000;

begin

process (SYSCLK50) is
begin
	if rising_edge(SYSCLK50) then
		TICK_50HZ <= '0';
		TICK_100HZ <= '0';
		count <= count +1;
		if count = 999999 then
			count <= 0;
			SQW_50HZ <= '0';
			TICK_50HZ <= '1';
			TICK_100HZ <= '1';
		end if;
		if count = 500000 then
			SQW_50HZ <= '1';		
			TICK_100HZ <= '1';
		end if;
	end if;
end Process;

end behave;

