library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- this script counts in a 4bit register from 0 to 9 depending on clk signal
-- then it decodes the 4bit signal to a 7bit signal for a 7segmentdisplay

entity BcdToSevenSegDisplay is
	port (	clk 	: in std_logic;
			reset 	: in std_logic;
			bcd		: out std_logic_vector(3 downto 0);
			display	: out std_logic_vector(6 downto 0)); -- (a, b, c, d, e, f, g)
end BcdToSevenSegDisplay;

architecture Behavioral of BcdToSevenSegDisplay is
	signal bcd_reg : std_logic_vector(3 downto 0) := "0000";
	signal display_reg : std_logic_vector(6 downto 0) := "0000000";
begin
	
	bcd <= bcd_reg;	
	process(clk, reset)
	begin
		if reset = '1' then
			bcd_reg <= "0000";
		elsif rising_edge(clk) then
			case bcd_reg is
				when "0000" => bcd_reg <= "0001"; -- 0 to 1
                when "0001" => bcd_reg <= "0010"; -- 1 to 2
                when "0010" => bcd_reg <= "0011"; -- 2 to 3
                when "0011" => bcd_reg <= "0100"; -- 3 to 4
                when "0100" => bcd_reg <= "0101"; -- 4 to 5
                when "0101" => bcd_reg <= "0110"; -- 5 to 6
                when "0110" => bcd_reg <= "0111"; -- 6 to 7
                when "0111" => bcd_reg <= "1000"; -- 7 to 8
                when "1000" => bcd_reg <= "1001"; -- 8 to 9
                when "1001" => bcd_reg <= "0000"; -- 9 to 0
                when others => bcd_reg <= "0000"; -- 0 if not defined
			end case;
		end if;
	end process;
	
	display <= not display_reg;
	process(bcd_reg)
	begin
		case bcd_reg is
			when "0000" => display_reg <= "1111110"; -- 0
			when "0001" => display_reg <= "0110000"; -- 1
            when "0010" => display_reg <= "1101101"; -- 2
            when "0011" => display_reg <= "1111001"; -- 3
            when "0100" => display_reg <= "0110011"; -- 4
            when "0101" => display_reg <= "1011011"; -- 5
            when "0110" => display_reg <= "1011111"; -- 6
            when "0111" => display_reg <= "1110000"; -- 7
            when "1000" => display_reg <= "1111111"; -- 8
            when "1001" => display_reg <= "1110011"; -- 9
            when others => display_reg <= "0000000"; -- nothing
		end case;
	end process;

end Behavioral;

