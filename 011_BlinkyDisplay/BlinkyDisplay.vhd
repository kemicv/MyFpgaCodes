library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- this code enables the four displays but one of then is blink
-- each 0.25seconds.

entity BlinkyDisplay is
    port ( clk      : in std_logic;
           segments : out std_logic_vector(6 downto 0);
           display  : out std_logic_vector(7 downto 0));
end BlinkyDisplay;

architecture Behavioral of BlinkyDisplay is
    signal clkdiv_dpfreshrate : integer range 0 to 50_000 := 0;
    signal clkdiv_blink : integer range 0 to 12_500_000 := 0; -- 0.25 secs
    signal active_dp : integer range 0 to 3 := 0;
    type digit_array is array (0 to 3) of std_logic_vector(6 downto 0);
    constant digit_data : digit_array := (
        "1111110", -- 0
        "0110000", -- 1
        "1101101", -- 2
        "1111001"); -- 3
    type dp_array is array (0 to 3) of std_logic_vector(7 downto 0);
    constant dp_data : dp_array := (
        "11111110", -- 0
        "11111101", -- 1
        "11111011", -- 2
        "11110111"); -- 3
    signal blink : std_logic := '0';
begin
    -- process used to display different values
    process(clk)
    begin
        if rising_edge(clk) then
            if clkdiv_dpfreshrate = 50_000 then
                clkdiv_dpfreshrate <= 0;
                active_dp <= (active_dp + 1) mod 4;
            else
                clkdiv_dpfreshrate <= clkdiv_dpfreshrate + 1;
            end if;
            
            display <= dp_data(active_dp);
            if active_dp = 0 and blink = '1' then
                segments <= "1111111";
            else
                segments <= not digit_data(active_dp);
            end if;
        end if;
    end process;

    -- process used to blink the display
    process(clk)
    begin
        if rising_edge(clk) then
            if clkdiv_blink = 12_500_000 then
                clkdiv_blink <= 0;
                blink <= not blink;
            else 
                clkdiv_blink <= clkdiv_blink + 1;
            end if;
        end if;
    end process;                
end Behavioral;

