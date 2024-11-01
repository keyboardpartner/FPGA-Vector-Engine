--------------------------------------------------------------------------------
-- J. Bresenham/midpoint alg. Lineplot from x1,y1 to x2,y2
-- Idea by Lorraine Jong, Lisa Shirachi and Sherman Wang
-- Implementation von C. Meyer, cm@make-magazin.de
-- für beliebige positive/negative Werte

-- Falls kein gemultiplexter DAC verwendet wird, können die
-- States zum Schreiben des DAC auch entfallen.
-- Wartet auf DAC_RDY = 1, bevor nächster Punkt gesetzt wird
--------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_signed.all;

entity bresenham is

GENERIC (
	constant width : integer := 12  -- Busbreite +1, max. 15
	);

port (
	CLK : in std_logic;
	LOAD_XY : in std_logic;
	X1 : in std_logic_vector(width-1 downto 0);
	Y1 : in std_logic_vector(width-1 downto 0);
	X2 : in std_logic_vector(width-1 downto 0);
	Y2 : in std_logic_vector(width-1 downto 0);
	DEFL_TIMER: in std_logic_vector(11 downto 0);
	BEAM_VALID : out std_logic; 	-- positive Logik
	DONE : out std_logic:= '1';
	STROBE: out std_logic;		-- Tick, Punkt fertig
	DAC_RDY : in std_logic;		-- DAC-Ausgabe fertig, nächster Punkt	(funktioniert noch nicht)
	X_VAL : out std_logic_vector(width-1 downto 0);
	Y_VAL : out std_logic_vector(width-1 downto 0)
	);
end bresenham;

architecture behavioral of bresenham is

	type state_t is (s_idle, s_calc, s_err, s_err2, s_wait, s_dy, s_dx, s_done, s_end);
	signal state : state_t := s_idle;

	signal done_int, advance: std_logic;

	signal x1_int, y1_int, x2_int, y2_int: Integer range -32768 to 32767;
	signal sx: Integer range -32768 to 32767;
	signal sy: Integer range -32768 to 32767;
	signal dx, dy: Integer range -32768 to 32767;
	signal err: Integer range -32768 to 32767;
	signal err2: Integer range -32768 to 32767;
	signal wait_counter: std_logic_vector(11 downto 0);
	
begin

X_VAL <= std_logic_vector(to_signed(x1_int, X_VAL'length));
Y_VAL <= std_logic_vector(to_signed(y1_int, Y_VAL'length));

process(CLK)
begin
	if rising_edge(CLK) then
		STROBE <= '0';
		if wait_counter /= 0 then
			wait_counter <= wait_counter - 1;
		end if;
		
		case state is	
			when s_idle =>
				DONE <= '1';
				BEAM_VALID <= '0'; -- letzter Punkt vollständig
								
			when s_calc =>				
				state <= s_err;
				if x1_int < x2_int then
					sx <= 1;
				else
					sx <= -1;
				end if;
				if y1_int < y2_int then
					sy <= 1;
				else
					sy <= -1;
				end if;
				dx <= abs(x2_int - x1_int);
				dy <= -abs(y2_int - y1_int);
				
			when s_err =>				
				state <= s_err2;
				err <= dx + dy;
				
			when s_err2 =>				
				state <= s_wait;
--				wait_counter <= DEFL_TIMER;
				err2 <= err + err;
				BEAM_VALID <= '1'; -- Beam einschalten
				STROBE <= '1';
				if (x1_int = x2_int) and (y1_int = y2_int) then
					state <= s_done;
				end if;
				
			when s_wait =>	 -- ist sonst zu schnell für die Darstellung!
				if (DAC_RDY = '1') and (wait_counter = 0) then
					wait_counter <= DEFL_TIMER;
					state <= s_dy;
				end if;
				
			when s_dy =>				
				state <= s_dx;
				if err2 >= dy then
					if (x1_int = x2_int) then 
						state <= s_done;
					else
						err <= err + dy;
						x1_int <= x1_int + sx;
					end if;
				end if;
			when s_dx =>				
				state <= s_err2;
				if err2 <= dx then
					if (y1_int = y2_int) then 
						state <= s_done;
					else
						err <= err + dx;
						y1_int <= y1_int + sy;
					end if;
				end if;
							
			when s_done	=>
				state <= s_end;
				wait_counter <= DEFL_TIMER;
				
			when s_end	=>
				if wait_counter = 0 then
					state <= s_idle;
				end if;
			
			when others =>
		end case;
		
    if LOAD_XY = '1' then
		  x1_int <= to_integer(signed(X1));
		  y1_int <= to_integer(signed(Y1));
		  x2_int <= to_integer(signed(X2));
		  y2_int <= to_integer(signed(Y2));
			wait_counter <= DEFL_TIMER;
			DONE <= '0';
			state <= s_calc;
		end if;
		
	end if; --end clock
end process;

end behavioral;
