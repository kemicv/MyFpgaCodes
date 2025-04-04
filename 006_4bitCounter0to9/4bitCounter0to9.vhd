library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- D Flipflop explanation in 005

entity FourBitCounter is
    port ( clk   : in std_logic;
           reset : in std_logic;
           d     : in std_logic;
           q     : inout std_logic;
           j     : out STD_LOGIC_VECTOR(3 downto 0)
    );
end FourBitCounter;

architecture Behavioral of FourBitCounter is
    signal j_reg : STD_LOGIC_VECTOR(3 downto 0) := "0000"; -- interal register
begin
    j <= j_reg;

    process(clk, reset)
    begin
        if reset = '1' then
            q <= '0';
            j_reg <= "0000";
        elsif rising_edge(clk) then
            if q = '1' then
                case j_reg is
                    when "0000" => j_reg <= "0001"; -- 0 to 1
                    when "0001" => j_reg <= "0010"; -- 1 to 2
                    when "0010" => j_reg <= "0011"; -- 2 to 3
                    when "0011" => j_reg <= "0100"; -- 3 to 4
                    when "0100" => j_reg <= "0101"; -- 4 to 5
                    when "0101" => j_reg <= "0110"; -- 5 to 6
                    when "0110" => j_reg <= "0111"; -- 6 to 7
                    when "0111" => j_reg <= "1000"; -- 7 to 8
                    when "1000" => j_reg <= "1001"; -- 8 to 9
                    when "1000" => j_reg <= "0000"; -- 9 to 0
                    when others => j_reg <= "0000"; -- 0 if not defined
                end case;
            end if;
        end if;
    end process;
end Behavioral;
