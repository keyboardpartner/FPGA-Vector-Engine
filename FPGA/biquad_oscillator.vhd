--------------------------------------------------------------------------------
-- Biquad-Filter, einfach, ohne Multiplizierer, mit Overflow-Schutz
-- Idee und Implementierung (c) C. Meyer 3/2014

-- Feste Grenzfrequenz, als Oversampling-Restaurationsfilter
-- 1=7640, 2=2560, 3=1091, 4=510, 5=246, 6=120, 7=60 Hz 
-- fc = a/((1-a)*2*pi*dt) mit a = 1/(2^shifts) und dt = 1/fs Sampling-Periode

-- SHIFTS bestimmt Grenzfrequenz (Bandpass-Mittenfrequenz)
-- bei 48 kHz		768 kHz (x16)
-- 1= 7640 Hz		122 kHz
-- 2= 2560 Hz		41 kHz
-- 3= 1091 Hz		17,5 kHz
-- 4= 510 Hz		8,1 kHz
-- 5= 246 Hz		3,9 kHz

-- KQ bestimmt Peaking jedes einzelnen Filters: 
-- Q = 2     mit KQ = 0 (shift left 1), neutrales Filter ohne Peak
-- Q = 1     mit KQ = 1 (kein Shift), Filter mit leichtem Peak
-- Q = 0.5   mit KQ = 2
-- Q = 0.25  mit KQ = 3 ausgeprägter Peak (Vorsicht vor Übersteuerung!)
-- Q = 0.125 mit KQ = 4 sehr starker Peak (Vorsicht vor Übersteuerung!)
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity biquad_oszillator is
	GENERIC (
		-- SHIFTS bestimmt Oszillatorfrequenz
		SHIFTS: Integer range 0 to 7:= 6
	);
	PORT (
		CLK	: in std_logic;
		LOAD_SC	: in std_logic;		-- Load Start Condition	
		SIN_START	: in std_logic_vector (11 downto 0);	-- Startbedingungen
		COS_START	: in std_logic_vector (11 downto 0);
		SIN_OUT: OUT std_logic_vector (11 downto 0);
		COS_OUT: OUT std_logic_vector (11 downto 0)
	);
end entity biquad_oszillator;

architecture behave of biquad_oszillator is

	signal sin_shifted, sin_added: std_logic_vector (19 downto 0);
	signal cos_shifted, cos_added: std_logic_vector (19 downto 0);
	signal sin_del: std_logic_vector (23 downto 0):= x"07FFF00";
	signal cos_del: std_logic_vector (23 downto 0):= (others => '0');

begin


sin_shifted <= to_stdlogicvector(to_bitvector(sin_del) sra SHIFTS); -- kf-Multiplier 2, 1/256 = 32 Hz
cos_shifted <= to_stdlogicvector(to_bitvector(cos_del) sra SHIFTS); -- kf-Multiplier 2, 1/256 = 32 Hz

sin_added <= sin_del + cos_shifted;
cos_added <= cos_del - sin_added;

COS_OUT <= cos_del(19 downto 8);
SIN_OUT <= sin_del(19 downto 8);

process (CLK)
begin
	if rising_edge(CLK) then
		cos_del <= cos_added;
		sin_del <= sin_added;			
	  if LOAD_SC = '1' then
			cos_del <= COS_START(11) & COS_START(11) & COS_START(11) & COS_START(11) & COS_START & x"00";
			sin_del <= SIN_START(11) & SIN_START(11) & SIN_START(11) & SIN_START(11) & SIN_START & x"00";			
    end if;
	end if;
end process;

end behave;