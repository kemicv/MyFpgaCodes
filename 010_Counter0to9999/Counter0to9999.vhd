library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

-- enables FPGA to count from 0 to 9999 each 10ms, so the displays
-- represents 00ss00ms.

entity Counter0to9999 is
    port (  clk     : in std_logic;
            segments: out std_logic_vector(6 downto 0);
            display : out std_logic_vector(7 downto 0));
end Counter0to9999;

architecture Behavioral of Counter0to9999 is
    signal hundredth : integer range 0 to 9 := 0;
    signal tenth  : integer range 0 to 9 := 0;
    signal unit : integer range 0 to 9 := 0;
    signal ten : integer range 0 to 9 := 0;
    signal clkdiv_counter : integer range 0 to 500_000 := 0; -- counter each 0.01s (10ms)
    signal clkdiv_dpfreshrate : integer range 0 to 50_000 := 0; -- fresh rate for dislays each 1ms
    signal active_dp : integer range 0 to 3 := 0;
    type digit_array is array (0 to 9) of std_logic_vector(6 downto 0); -- TYPE of variable to use it as a constant
    constant digit_data : digit_array := ( -- constant array for the display numbers
        "1111110", -- 0
        "0110000", -- 1
        "1101101", -- 2
        "1111001", -- 3
        "0110011", -- 4
        "1011011", -- 5
        "1011111", -- 6
        "1110000", -- 7
        "1111111", -- 8
        "1110011"); -- 9

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if clkdiv_counter = 500_000-1 then
                hundredth <= hundredth + 1;
                clkdiv_counter <= 0;
                if hundredth = 9 then
                    hundredth <= 0;
                    tenth <= tenth + 1;
                    if tenth = 9 then
                        tenth <= 0;
                        unit <= unit + 1;
                        if unit = 9 then
                            unit <= 0;
                            ten <= ten + 1;
                            if ten = 9 then
                                ten <= 0;
                            end if;
                        end if;
                    end if;
                end if;
            else
                clkdiv_counter <= clkdiv_counter + 1;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if clkdiv_dpfreshrate = 50_000 then
                clkdiv_dpfreshrate <= 0;
                active_dp <= (active_dp + 1) mod 4;
            else
                clkdiv_dpfreshrate <= clkdiv_dpfreshrate + 1;
            end if;
            case active_dp is
                when 0 => 
                    display <= "11111110";
                    segments <= not digit_data(hundredth);
                when 1 =>
                    display <= "11111101";
                    segments <= not digit_data(tenth);
                when 2 =>
                    display <= "11111011";
                    segments <= not digit_data(unit);
                when 3 =>
                    display <= "11110111";
                    segments <= not digit_data(ten);
            end case;
        end if;
    end process;
end Behavioral;

