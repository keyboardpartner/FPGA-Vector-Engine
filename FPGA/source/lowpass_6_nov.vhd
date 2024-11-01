--------------------------------------------------------------------------------
-- FILTER 1. Ordnung als Hoch- oder Tiefpass
-- by Carsten Meyer, cm@ct.de, 10/2011
-- Frequenzen ermittelt mit IIR_Filter_Coef_Generator.xls
-- Ohne Überlauf-Protection!
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
--use IEEE.numeric_std.all;

library UNISIM;
use UNISIM.VComponents.all;

entity lowpass_6_nov is
	generic (
		FREQU: Integer range 0 to 7:=3 	-- shifts
		-- 1=7640, 2=2560, 3=1091, 4=510, 5=246, 6=120, 7=60 Hz 
		-- fc = a/((1-a)*2*pi*dt) mit a = 1/(2^shifts) und dt = 1/fs Sampling-Periode
		);
	port (
		SYSCLK	: in std_logic;
		SYNC		: in std_logic;
		ENABLE	: in std_logic; -- wenn 0, wird Eingangssignal direkt übernommen
		INP	: in std_logic_vector (15 downto 0);	-- input wave data
		OUT_6 : out std_logic_vector(15 downto 0)
	);
end entity lowpass_6_nov;

architecture behave of lowpass_6_nov is
	
	-- 24 Bit (16 Bit plus 8 Bit "Nachkommastellen") ohne Überlauf
	signal in_temp_6, out_temp_6, diff_6_shifted, diff_6: std_logic_vector (23 downto 0) := (others => '0');

begin

in_temp_6(23 downto 8) <= INP;

--OUT_6 <= out_temp_6(23 downto 8);	-- Tiefpass 6 dB/Okt.
--OUT_6 <= diff_6(23 downto 8);			-- Hochpass 6 dB/Okt.
diff_6 <= in_temp_6 - out_temp_6;		-- hier bei Tiefpass
--OUT_6 <= x"7FFF" when out_temp_6(24 downto 23) = "01" -- positiver Überlauf
--		else x"8000" when out_temp_6(24 downto 23) = "10"	-- negativer Überlauf
--		else out_temp_6(23 downto 8); 	-- kein überlauf
OUT_6 <= out_temp_6(23 downto 8); 	-- kein überlauf

-- Je größer diff_6_shifted, desto höher die Grenzfrequenz
diff_6_shifted <= to_stdlogicvector(to_bitvector(diff_6) sra FREQU);	-- Faktor k2


delay_register: process (SYSCLK)
begin
	if rising_edge(SYSCLK) then
--		diff_6 <= in_temp_6 - out_temp_6; -- hier bei Hochpass
		if ENABLE = '1' then
			if SYNC = '1' then
				out_temp_6 <= out_temp_6 + diff_6_shifted;
			end if;
		else
			out_temp_6 <= in_temp_6;
		end if;
	end if;
end process;

end behave;