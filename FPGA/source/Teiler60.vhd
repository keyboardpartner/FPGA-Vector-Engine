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

entity Teiler60 is
    Port ( SYSCLK50 : in  STD_LOGIC;
           TICK_60HZ : out  STD_LOGIC;
           TICK_120HZ : out  STD_LOGIC;
           SQW_60HZ : out  STD_LOGIC);
end Teiler60;

architecture behave of Teiler60 is

signal count: Integer range 0 to 1000000;

begin

process (SYSCLK50) is
begin
	if rising_edge(SYSCLK50) then
		TICK_60HZ <= '0';
		TICK_120HZ <= '0';
		count <= count +1;
		if count = 833332 then
			count <= 0;
			SQW_60HZ <= '0';
			TICK_60HZ <= '1';
			TICK_120HZ <= '1';
		end if;
		if count = 416666 then
			SQW_60HZ <= '1';		
			TICK_120HZ <= '1';
		end if;
	end if;
end Process;

end behave;

