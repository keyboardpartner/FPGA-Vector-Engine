--------------------------------------------------------------------------------
-- Biquad-Sin/Cos-Berechnung 12 Bit, Signed
-- Idee und Implementierung (c) C. Meyer 09/2022
--------------------------------------------------------------------------------


library IEEE;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_signed.all;


library UNISIM;
use UNISIM.VComponents.all;

entity biquad_sincos is

GENERIC (
	constant width : integer := 12  -- Busbreite +1, max. 15
	);
	
PORT (
	CLK	: in std_logic;
	PI2_STEP	: in std_logic_vector (width-1 downto 0);	-- Winkel, bei 7 SHIFTS Vollkreis bei 804 dez. = $324
	START	: in std_logic;		  											-- Tick Start Condition
	DONE: out std_logic;
	SIN_OUT: OUT std_logic_vector (width-1 downto 0);
	COS_OUT: OUT std_logic_vector (width-1 downto 0)
);

end entity biquad_sincos;

architecture behave of biquad_sincos is

	signal sin_in, sin_added: std_logic_vector (width*2-1 downto 0);
	signal cos_in, cos_added: std_logic_vector (width*2-1 downto 0);
	signal sin_del: std_logic_vector (width*2-1 downto 0):= (others => '0');
	signal cos_del: std_logic_vector (width*2-1 downto 0):= x"07FF00";
	signal done_int: std_logic:= '1';
	signal frequ_int: Integer Range 0 to 7:= 7;
	signal val_count_int, val_count_dest: std_logic_vector (width-1 downto 0):= (others => '0');
	
begin

-- statt SHIFTS wäre auch "richtiger" Multiplizierer denkbar
cos_in <= to_stdlogicvector(to_bitvector(sin_added) sra 7); -- kf-Multiplier 2, 1/256 = 32 Hz
cos_added <= cos_del - cos_in;

sin_in <= to_stdlogicvector(to_bitvector(cos_del) sra 7);   -- kf-Multiplier 2, 1/256 = 32 Hz
sin_added <= sin_in + sin_del;


biquad: process (CLK)
begin
	if rising_edge(CLK) then
		COS_OUT <= cos_del(19 downto 8);
		SIN_OUT <= sin_del(19 downto 8);
		DONE <= done_int;
		
    if done_int = '0' then		
			cos_del <= cos_added;
			sin_del <= sin_added;
			val_count_int <= val_count_int + 1;
		end if;

		if val_count_int > val_count_dest then 
			done_int <= '1';		
		end if;  

		-- sin(45°) * 2048 = 0,70711 * 2048 = 1448,15 dez.
	  if START = '1' then
	    val_count_int <= (others => '0');
			cos_del <= x"07FF00";	-- 2047
			sin_del <= (others => '0');	
			val_count_dest <= PI2_STEP;
			if PI2_STEP >= 201 then
			  val_count_dest <= PI2_STEP - 201;			
				cos_del <= x"000000";  
				sin_del <= x"07FF00";
			end if;
			if PI2_STEP >= 402 then
			  val_count_dest <= PI2_STEP - 402;			
				cos_del <= x"F80100";  -- -2048
				sin_del <= x"000000";
			end if;
			if PI2_STEP >= 603 then
			  val_count_dest <= PI2_STEP - 603;			
				cos_del <= x"000000";  
				sin_del <= x"F80100";
			end if;
			done_int <= '0';
    end if;
	end if;
end process;

end behave;