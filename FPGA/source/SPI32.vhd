--------------------------------------------------------------------------------
-- SPI Interface for c't-Lab FPGA und c't-Lab UNIC
-- AVR SPI-Mode CPOL/CPHA 1.1 (SCK normally high)
-- by C. Meyer cm@ctmagazin.de
-- Creative Commons by-nc-sa, use by your own risk
-- Letzte Änderungen:
-- 02.07.2011 rs_tick und ds_tick besser mit SYSCLK synchronisiert
-- 11.01.2012 DNA_PORT auslesen auf SPI 240 und 241 ($F0, $F1)
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

entity SPI32 is
port (
	SYSCLK: in STD_LOGIC;
	SCK   : in STD_LOGIC;
	MOSI  : in STD_LOGIC;
	DS_N  : in STD_LOGIC;
	RS_N  : in STD_LOGIC;

	MISO  : inout STD_LOGIC;
	RSEL  : out STD_LOGIC_VECTOR(7 downto 0);	-- an weitere Ausgangsregister, Adresse
	STROBE : out STD_LOGIC;							      -- Schreibimpuls für Ausgangsregister
	DATA_LC: out STD_LOGIC_VECTOR(31 downto 0);
	Q1_CONF: out STD_LOGIC_VECTOR(7 downto 0);
	Q2_CONF: out STD_LOGIC_VECTOR(7 downto 0);

	D0_STATUS   : in STD_LOGIC_VECTOR(11 downto 0);
	D3   : in STD_LOGIC_VECTOR(31 downto 0);
	CMD_LC: out STD_LOGIC;	-- RESET für 1 Core
	INC_LC: out STD_LOGIC 	-- INCR für 1 Core
  );

	attribute clock_signal : string;
	attribute clock_signal of SYSCLK : signal is "yes";

end SPI32;

architecture behave of SPI32 is

signal q_int, q_sro, q_sro_tmp, q_sri, q1_saved, q2_saved : std_logic_vector(31 downto 0) := (others => '0');
signal r_int, r_sri : std_logic_vector(15 downto 0) := (others => '0');

signal rs_tick, ds_tick, ds_n_tick, miso_int : std_logic;
signal rs_n_d1, ds_n_d1, sck_d1: std_logic;
signal rs_n_d2, ds_n_d2, sck_d2: std_logic;
signal sck_tick: std_logic;
signal mosi_d1, mosi_d2: std_logic;

begin

sel_sync: process(SYSCLK)
-- Double buffered Synchronizer für Eingangsdaten
begin
	if rising_edge(SYSCLK) then
	  rs_n_d2 <= rs_n_d1;
	  ds_n_d2 <= ds_n_d1;
		sck_d2 <= sck_d1;
		
		rs_n_d1 <= RS_N;
		ds_n_d1 <= DS_N;
		sck_d1 <= SCK;
		
		rs_tick <= '0';
		ds_tick <= '0';
		sck_tick <= '0';
		ds_n_tick <= '0';
		
		mosi_d2 <= mosi_d1;
		
		if (rs_n_d1 = '1') and (rs_n_d2 = '0') then
		  -- steigende Flanke
		  rs_tick <= '1';
		  r_int <= r_sri;
		end if;
		
		if (ds_n_d1 = '1') and (ds_n_d2 = '0') then
		  -- steigende Flanke
		  ds_tick <= '1';
		end if;
		
		if (ds_n_d1 = '0') and (ds_n_d2 = '1') then
		  -- fallende Flanke
		  ds_n_tick <= '1';
		end if;
		
		if (sck_d1 = '1') and (sck_d2 = '0') then
		  -- steigende Flanke
		  sck_tick <= '1';
	  	mosi_d1 <= MOSI;
		end if;
	end if;
end process;

spi_shiftinout: process(SYSCLK)
-- Schieberegister für Eingangsdaten
begin
	if rising_edge(SYSCLK) then
		if (sck_tick = '1') and (ds_n_d1 = '0') then 
			q_sri <= ( q_sri(30 downto 0) & mosi_d1 );
		end if;
		
		if (sck_tick = '1') and (rs_n_d1 = '0') then 
			r_sri <= ( r_sri(14 downto 0) & mosi_d1 );
		end if;
		
		-- Eingangsregister Daten buffered
--		if (ds_tick = '1') then 
--		  q_int <= q_sri;
--		end if;
		
		-- Schieberegister für Ausgangsdaten
		if (ds_n_tick = '1') then 
			-- mit fallender /DS-Flanke übernehmen
			q_sro_tmp <= q_sro; 
		end if;
		
		if (sck_tick = '1') and (ds_n_d1 = '0') then 
			q_sro_tmp <= ( q_sro_tmp(30 downto 0) & '0' );	-- MSB first
		end if;
	end if;
end process;

miso_int <= q_sro_tmp(31);
MISO <= miso_int when ds_n_d1 = '0' else 'Z';
STROBE <= ds_tick;

DATA_LC <= q_sri;
RSEL <= r_int(7 downto 0);

spi_mosi_regs : process(SYSCLK)
-- SPI-Registerwerte zwischenspeichern
begin
	if rising_edge(SYSCLK) then
		INC_LC <= '0';
		CMD_LC <= '0';
		if ds_tick = '1' then -- and (r_int(15) = '1') then	-- Schreibfreigabe, neue Version
			case r_int(7 downto 0) is 
				when x"00" =>
				when x"01" =>
					Q1_CONF <= q_sri(7 downto 0);
					q1_saved <= q_sri;
				when x"02" =>
					Q2_CONF <= q_sri(7 downto 0);
					q2_saved <= q_sri;
				when x"80" =>
					INC_LC <= '1';	-- Daten von DS liegen bereits an
				when x"81" =>
					CMD_LC <= '1';	-- Daten von DS liegen bereits an
				when others =>
			end case;
		end if;
	end if;
end process;

spi_miso_regs : process(SYSCLK)
-- Eingangsmultiplexer, aktualisiert mit Schreiben von RS_N
begin
	if rising_edge(SYSCLK) then		
		if rs_tick = '1' then	-- Register-Select geschrieben?
			if (r_int(7 downto 4) = x"0") then
				case r_int(3 downto 0) is -- aktuelle Registeradresse
					when x"0" =>
						q_sro(31 downto 12) <= (others => '0');
						q_sro(11 downto 0) <= D0_STATUS;
					when x"1" =>
						q_sro <= q1_saved;
					when x"2" =>
						q_sro <= q2_saved;
					when x"3" => 	-- z.B. FPGA-Version
						q_sro <= D3;
					when others =>
				end case;
			end if;
		end if;
	end if;
end process;


end behave;
