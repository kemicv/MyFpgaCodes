library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This is a counter for an encoder A and B signal. Each change sums to the counter.
-- This implements the binary decoder to show the output.

entity EncoderCounter is
    port ( clk    : in std_logic;
	       aSignal: in std_logic; -- encoder signal A
		   bSignal: in std_logic; -- encoder signal B
		   debug  : out std_logic_vector(15 downto 0) );
end EncoderCounter;

architecture Behavioral of EncoderCounter is
	signal syncEncoder : std_logic_vector(1 downto 0) := "00";
	signal oldValue: integer range 0 to 3 := 0;
	signal newValue: integer range 0 to 3;
	signal counter: integer range -99999 to 99999 := 0;
begin
	decoder: entity work.BinaryDecoder
		port map(clk=>clk, count=>counter,
		         leds=>debug);

	syncEncoder <= aSignal & bSignal;
	
	process(clk)
	begin
		if rising_edge(clk) then	
			newValue <= to_integer(unsigned(syncEncoder));
			
			if (newValue /= oldValue) then
				if (newValue = 2 and oldValue = 0) then
					counter <= counter + 1;
				elsif (newValue = 3 and oldValue = 2) then
					counter <= counter + 1;
				elsif (newValue = 1 and oldValue = 3) then
					counter <= counter + 1;
				elsif (newValue = 0 and oldValue = 1) then
					counter <= counter + 1;
				else 
					counter <= counter - 1;
				end if;

				oldValue <= newValue;
			end if;
		end if;		
	end process;
end Behavioral;
