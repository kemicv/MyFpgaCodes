library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This is a counter for an encoder A and B signal. It increments/decrease depending
-- on the previous state when AB is '00'.
-- It implements a decimal decoder to show the output, But this is not the current
-- value.

entity EncoderCounter is
    port ( clk    : in std_logic;
	       aSignal: in std_logic; -- encoder signal A
		   bSignal: in std_logic; -- encoder signal B
		   segments: out std_logic_vector(6 downto 0);
           display : out std_logic_vector(7 downto 0) );
end EncoderCounter;

architecture Behavioral of EncoderCounter is
	signal syncEncoder : std_logic_vector(1 downto 0) := "00";
	signal oldValue: integer range 0 to 3 := 0;
	signal newValue: integer range 0 to 3;
	signal counter: integer range -99999 to 99999 := 0;
	signal increment: std_logic := '0';
begin
	decoder: entity work.DecimalDecoder
		port map(clk=>clk,
				increase=>increment,
				segments=>segments, display=>display);

	syncEncoder <= aSignal & bSignal;
	
	process(clk)
	begin
		if rising_edge(clk) then	
			newValue <= to_integer(unsigned(syncEncoder));
			
			if (newValue /= oldValue) then
				if (newValue = 0 and oldValue = 1) then
					counter <= counter + 1;
					increment <= '1';
				elsif (newValue = 0 and oldValue = 2) then
					counter <= counter - 1;
				end if;

				oldValue <= newValue;
			else
				increment <= '0';
			end if;
		end if;		
	end process;
end Behavioral;
