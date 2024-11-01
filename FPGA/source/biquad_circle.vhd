--------------------------------------------------------------------------------
-- Biquad-Oszillator 12 Bit, Signed
-- Idee und Implementierung (c) C. Meyer 8/2022
-- Erzeugt einen Kreisabschnitt von PI_START bis PI_END mit RADIUS
-- Startpunkt oben + PI_START, im Urzeigersinn
-- Bei 7 K_FREQU Shifts ist Add-Teiler = 128, d.h. Multiplikator 0,0078125
-- Benötigte Punkte für Vollkreis: Teiler * 2pi
-- BEAM_VALID wird nur innerhalb des angegebenen Kreissegments aktiv
-- Wartet auf DAC_RDY = 1, bevor nächster Punkt gesetzt wird
--------------------------------------------------------------------------------


library IEEE;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_signed.all;


library UNISIM;
use UNISIM.VComponents.all;

entity biquad_circle is

	GENERIC (		
	constant width : integer := 12;  -- Busbreite +1, max. 15
	constant dac_settle : integer := 200  -- Anzahl Takte bei erstem Wert
	);
	PORT (
		CLK	: in std_logic;
		K_FREQU: in std_logic_vector (2 downto 0); -- Shifts 1..7, bestimmt Oszillatorfrequenz, 1 = höchste, 7 = niedrigste 
		PI_START	: in std_logic_vector (width-1 downto 0);	-- Anzahl gewünschter Werte, bei 7 SHIFTS Vollkreis bei 805 dez. = $325
		PI_END	: in std_logic_vector (width-1 downto 0);	-- Anzahl gewünschter Werte, bei 7 SHIFTS Vollkreis bei 805 dez. = $325
		LOAD_SCV	: in std_logic;		  										-- Tick Load Start Condition
		DEFL_TIMER: in std_logic_vector(11 downto 0);			-- Verlangsamer für Vektor-Display
		OFS_X	: in std_logic_vector (width-1 downto 0);		-- Offset X-Richtung
		OFS_Y	: in std_logic_vector (width-1 downto 0);		-- Offset Y-Richtung
		RADIUS	: in std_logic_vector (width-1 downto 0);	-- Startbedingung Position X-Richtung
    BEAM_VALID: out std_logic;		
		STROBE: out std_logic;  	-- Tick, Punkt fertig
		DAC_RDY: in std_logic;  	-- Level, 1 = DAC geschrieben
		X_VAL : out std_logic_vector(width-1 downto 0);
		Y_VAL : out std_logic_vector(width-1 downto 0);
		DONE: out std_logic	 -- kann auch mit LOAD_SCV verbunden sein für selbsttätigen Refresh
	);

end entity biquad_circle;

architecture behave of biquad_circle is
	type state_t is (s_idle, s_calc, s_wait, s_done, s_end);
	signal state : state_t := s_idle;

	signal sin_in, sin_added: std_logic_vector (width*2-1 downto 0);
	signal cos_in, cos_added: std_logic_vector (width*2-1 downto 0);
	signal sin_del: std_logic_vector (width*2-1 downto 0):= (others => '0');
	signal cos_del: std_logic_vector (width*2-1 downto 0):= (others => '0');
	signal frequ_int: Integer Range 0 to 15:= 7;
	
--	signal mpx_temp: std_logic_vector (width-1 downto 0);
	
	signal val_count_int, val_count_start, val_count_end: std_logic_vector (width-1 downto 0):= (others => '0');
	
	signal wait_counter: std_logic_vector (11 downto 0):= (others => '0');
	signal start_cond, stop_cond, beam_valid_int: std_logic;

	signal x_int, y_int: std_logic_vector (width-1 downto 0);	-- Ergebnis
	
begin


-- statt SHIFTS wäre auch "richtiger" Multiplizierer denkbar
cos_in <= to_stdlogicvector(to_bitvector(sin_added) sra frequ_int); -- kf-Multiplier 2, 1/256 = 32 Hz
cos_added <= cos_del - cos_in;

sin_in <= to_stdlogicvector(to_bitvector(cos_del) sra frequ_int);   -- kf-Multiplier 2, 1/256 = 32 Hz
sin_added <= sin_in + sin_del;

X_VAL <= OFS_X + sin_del(width+7 downto 8);
Y_VAL <= OFS_Y + cos_del(width+7 downto 8);  -- Cosinus-Wert zwischenspeichern

start_cond <= '1' when (val_count_int >= val_count_start) else '0';
stop_cond <= '1' when (val_count_int > val_count_end) else '0';
BEAM_VALID <= beam_valid_int;

biquad: process (CLK)
begin
	if rising_edge(CLK) then
		
		STROBE <= '0';
		if wait_counter /= 0 then
			wait_counter <= wait_counter - 1;
		end if;
		
		case state is	
			when s_idle =>
				DONE <= '1';
				beam_valid_int <= '0'; -- letzter Punkt vollständig

			when s_calc	=>
				cos_del <= cos_added;
				sin_del <= sin_added;
				val_count_int <= val_count_int + 1;
				if start_cond = '1' then
					if beam_valid_int = '0' then 
						STROBE <= '1';
						wait_counter <= std_logic_vector(to_signed(dac_settle, wait_counter'length)); -- DAC Settle erster Punkt
					end if;
				  state <= s_wait;
				end if;
				
			when s_wait =>	 -- ist sonst zu schnell für die Darstellung!
				if (DAC_RDY = '1') and (wait_counter = 0) then
					STROBE <= '1';
					beam_valid_int <= '1';
					wait_counter <= DEFL_TIMER(9 downto 0) & "11";
					if stop_cond = '1' then
						state <= s_end;
					else
						state <= s_calc;
					end if;
				end if;

			when s_end	=>
				if wait_counter = 0 then
					state <= s_idle;
				end if;
			
			when others =>
		end case;


	  if LOAD_SCV = '1' then  -- Startwerte laden
			cos_del <= RADIUS(11) & RADIUS(11) & RADIUS(11) & RADIUS(11) & RADIUS & x"00"; -- Kreis oben
			sin_del <= (others => '0');			
	    val_count_int <= (others => '0');
	    val_count_start <= PI_START;
			val_count_end <= PI_END;
			frequ_int <= to_integer(unsigned(K_FREQU));
			DONE <= '0';
			beam_valid_int <= '0';
			state <= s_calc;
    end if;
	end if;
end process;

end behave;