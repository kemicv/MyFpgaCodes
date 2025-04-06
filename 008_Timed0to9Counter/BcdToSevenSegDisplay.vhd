library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- it counts on a 4bit register from 0 to 9 each 1 second
-- then it decodes the 4bit reg to a 7bit signal for a display

entity Timed0to9Counter is
	port (	clk 	: in std_logic; -- 50MHz main clock
			reset 	: in std_logic;
			bcd		: out std_logic_vector(3 downto 0);
			display	: out std_logic_vector(6 downto 0)); -- (a, b, c, d, e, f, g)
end Timed0to9Counter;

architecture Behavioral of Timed0to9Counter is
	signal bcd_reg : std_logic_vector(3 downto 0) := "0000";
	signal display_reg : std_logic_vector(6 downto 0) := "0000000";
	-- counter is a 26bit register (67,108,615) used as  counter for 50MHz divider to 1Hz
	-- others => '0' is equivalent to set all to 0 (26 zeros)
	signal counter : unsigned(25 downto 0) := (others => '0');
	signal one_sec_en : std_logic := '0'; -- Hz enable pulse
begin

	-- clock divider: generate 1Hz enable signal from 50Mhz clock
	-- (adjust counter witdth baser on you clock frequency)
	process(clk, reset)
	begin
		if reset = '1' then
			counter <= (others => '0');
			one_sec_en <= '0';
		elsif rising_edge(clk) then
			one_sec_en <= '0'; --- default: no enable
			if counter = 50_000_000 - 1 then -- 50Mhz/50M = 1Hz
				counter <= (others => '0');
				one_sec_en <= '1'; -- pulse every 1 second
			else
				counter <= counter + 1;
			end if;
		end if;
	end process;

	bcd <= bcd_reg;
	process(clk, reset)
	begin
		if reset = '1' then
			bcd_reg <= "0000";
		elsif rising_edge(clk) then
			if one_sec_en = '1' then
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

