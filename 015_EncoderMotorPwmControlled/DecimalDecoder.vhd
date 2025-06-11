library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

-- enables FPGA to count from 0 to 9999 each 10ms, so the displays
-- represents 00ss00ms.

entity DecimalDecoder is
    port (  clk     : in std_logic;
            increase: in std_logic;
            segments: out std_logic_vector(6 downto 0);
            display : out std_logic_vector(7 downto 0));
end DecimalDecoder;

architecture Behavioral of DecimalDecoder is
    signal pos0 : integer range 0 to 9 := 0; -- units
    signal pos1 : integer range 0 to 9 := 0; -- tens
    signal pos2 : integer range 0 to 9 := 0; -- hundreds
    signal pos3 : integer range 0 to 9 := 0; -- thousands
    signal pos4 : integer range 0 to 9 := 0; -- ten-thousands
    signal pos5 : integer range 0 to 9 := 0; -- hundred-thousands
    signal pos6 : integer range 0 to 9 := 0; -- millions
    signal sig : integer range 0 to 9 := 0; -- - sign
    signal clkdiv_dpfreshrate : integer range 0 to 50_000 := 0; -- fresh rate for dislays each 1ms
    signal active_dp : integer range 0 to 7 := 0;
    type digit_array is array (0 to 10) of std_logic_vector(6 downto 0); -- TYPE of variable to use it as a constant
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
        "1110011", -- 9
        "0000001"); -- minus sign -

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if increase = '1' then
                pos0 <= pos0 + 1;
                if pos0 = 9 then
                    pos0 <= 0;
                    pos1 <= pos1 + 1;
                    if pos1 = 9 then
                        pos1 <= 0;
                        pos2 <= pos2 + 1;
                        if pos2 = 9 then
                            pos2 <= 0;
                            pos3 <= pos3 + 1;
                            if pos3 = 9 then
                                pos3 <= 0;
                                pos4 <= pos4 + 1;
                                if pos4 = 9 then
                                    pos4 <= 0;
                                    pos5 <= pos5 + 1;
                                    if pos5 = 9 then
                                        pos5 <= 0;
                                        pos6 <= pos6 + 1;
                                        if pos6 = 9 then
                                            pos6 <= 0;
                                        end if;
                                    end if;
                                end if;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
		end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if clkdiv_dpfreshrate = 50_000 then
                clkdiv_dpfreshrate <= 0;
                active_dp <= (active_dp + 1) mod 8;
            else
                clkdiv_dpfreshrate <= clkdiv_dpfreshrate + 1;
            end if;
            case active_dp is
                when 0 => 
                    display <= "11111110";
                    segments <= not digit_data(pos0);
                when 1 =>
                    display <= "11111101";
                    segments <= not digit_data(pos1);
                when 2 =>
                    display <= "11111011";
                    segments <= not digit_data(pos2);
                when 3 =>
                    display <= "11110111";
                    segments <= not digit_data(pos3);
				when 4 =>
                    display <= "11101111";
                    segments <= not digit_data(pos4);
				when 5 =>
                    display <= "11011111";
                    segments <= not digit_data(pos5);
				when 6 =>
                    display <= "10111111";
                    segments <= not digit_data(pos6);
				when 7 =>
                    display <= "01111111";
                    segments <= not digit_data(sig);
            end case;
        end if;
    end process;
end Behavioral;

