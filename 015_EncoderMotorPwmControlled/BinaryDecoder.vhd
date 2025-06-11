library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

-- Decoder: receives an integer value which is shown in 16 leds.
-- Showed value is within -32768 to 32767.

entity BinaryDecoder is
    port (  clk   : in std_logic;
	        count : in integer range -32768 to 32767;
            leds  : out std_logic_vector(15 downto 0) );
end BinaryDecoder;

architecture Behavioral of BinaryDecoder is
begin
	leds <= std_logic_vector(to_signed(count, 16));
end Behavioral;

