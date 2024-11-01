--------------------------------------------------------------------------------
-- Biquad-Oszillator 12 Bit, Signed
-- Idee und Implementierung (c) C. Meyer 3/2014
--------------------------------------------------------------------------------


library IEEE;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_signed.all;


library UNISIM;
use UNISIM.VComponents.all;

entity biquad_oscillator is

	GENERIC (
		
 	  WIDTH : integer := 12  -- Busbreite +1, max. 15
	);
	PORT (
		CLK	: in std_logic;
		K_FREQU: in std_logic_vector (2 downto 0); -- Shifts 1..7, bestimmt Oszillatorfrequenz, 1 = höchste, 7 = niedrigste 
		VAL_COUNT	: in std_logic_vector (width-1 downto 0);	-- Anzahl gewünschter Werte, bei 7 SHIFTS Vollkreis bei 805 dez. = $325
		LOAD_SCV	: in std_logic;		  -- Tick Load Start Condition
		OFS_X	: in std_logic_vector (width-1 downto 0);	-- Offset X-Richtung
		OFS_Y	: in std_logic_vector (width-1 downto 0);	-- Offset Y-Richtung
		SIN_START	: in std_logic_vector (width-1 downto 0);	-- Startbedingung Position X-Richtung
		COS_START	: in std_logic_vector (width-1 downto 0);	-- Startbedingung Position Y-Richtung
		MPX_OUT: OUT std_logic_vector (width-1 downto 0);
		DAC_WR: out std_logic;	 
		DAC_SEL: out std_logic;	 
		DONE: out std_logic;	 -- kann auch mit LOAD_SCV verbunden sein für selbsttätigen Refresh
		SIN_OUT: OUT std_logic_vector (width-1 downto 0);
		COS_OUT: OUT std_logic_vector (width-1 downto 0)
	);

end entity biquad_oscillator;

architecture behave of biquad_oscillator is

	signal sin_in, sin_added: std_logic_vector (23 downto 0);
	signal cos_in, cos_added: std_logic_vector (23 downto 0);
	signal sin_del: std_logic_vector (23 downto 0):= x"07FF00";
	signal cos_del: std_logic_vector (23 downto 0):= (others => '0');
	signal done_int: std_logic:= '1';
	signal frequ_int: Integer Range 0 to 7:= 7;
	signal val_count_int, val_count_dest: std_logic_vector (width-1 downto 0):= (others => '0');
	signal mpx_temp: std_logic_vector (width-1 downto 0);
	
	signal mpx_count: std_logic_vector (1 downto 0):= (others => '0');
	signal divider: std_logic_vector (5 downto 0);
	signal divider_tick: std_logic;
	
	-- signal mult_sin, mult_cos: std_logic_vector (23 downto 0);

begin

-- statt SHIFTS wäre auch "richtiger" Multiplizierer denkbar
cos_in <= to_stdlogicvector(to_bitvector(sin_added) sra frequ_int); -- kf-Multiplier 2, 1/256 = 32 Hz
cos_added <= cos_del - cos_in;

sin_in <= to_stdlogicvector(to_bitvector(cos_del) sra frequ_int);   -- kf-Multiplier 2, 1/256 = 32 Hz
sin_added <= sin_in + sin_del;

COS_OUT <= cos_del(width+7 downto 8);
SIN_OUT <= sin_del(width+7 downto 8);
DONE <= done_int;

prescaler: process (CLK)
begin
	if rising_edge(CLK) then
    divider_tick <= '0';
	  divider <= divider + 1;
		if divider = "000000" then
		  divider_tick <= '1';
		end if;
	end if;
end process;

biquad: process (CLK)
begin
	if rising_edge(CLK) then
	  DAC_WR <= '1';			

		if (val_count_dest /= 0) and (val_count_int >= val_count_dest) then 
			done_int <= '1';		
		end if;  

		if (mpx_count = "00") and (done_int = '0') then
			MPX_OUT <= OFS_X + sin_del(width+7 downto 8);
			mpx_temp <= OFS_Y + cos_del(width+7 downto 8);  -- Cosinus-Wert zwischenspeichern
			DAC_SEL <= '0';
		end if;				

		if (mpx_count = "10") and (done_int = '0') then
			MPX_OUT <= mpx_temp;		-- Cosinus-Wert ausgeben
			DAC_SEL <= '1';
		end if;		
		
		if (mpx_count = "01") or (mpx_count = "11") then
			DAC_WR <= done_int;
		end if;
		
	  mpx_count <= mpx_count + 1;
		
	  if LOAD_SCV = '1' then
			cos_del <= COS_START(11) & COS_START(11) & COS_START(11) & COS_START(11) & COS_START & x"00";
			sin_del <= SIN_START(11) & SIN_START(11) & SIN_START(11) & SIN_START(11) & SIN_START & x"00";			
	    mpx_count <= (others => '0');
	    val_count_int <= (others => '0');
			val_count_dest <= VAL_COUNT;
			frequ_int <= to_integer(unsigned(K_FREQU));
			done_int <= '0';
    end if;
		
		
	  if divider_tick = '1' then -- Kreis verlangsamen, sonst zu schnell für Anzeige
		  cos_del <= cos_added;
		  sin_del <= sin_added;
			val_count_int <= val_count_int + 1;
		end if;
	end if;
end process;

end behave;