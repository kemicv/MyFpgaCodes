library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- board has 8 multiplexed displays (e.g. their segments A, B, C,
-- etc. are in the same pin, but the common anodes are in different
-- pins)
-- to display different values then you have to activate each common
-- anode for a short lapse time (1 to 5ms recommendable) and assign
-- the desired value to the segments.
-- this codes is meant to show a specific sign for each display.

entity DisplayDifferentValues is
    port (  clk     : in std_logic;                     -- fpga 50MHz clk
            segments: out std_logic_vector(6 downto 0); -- A,B,C,etc. segments
            annodes : out std_logic_vector(7 downto 0));-- commons annodes
end DisplayDifferentValues;

architecture Behavioral of DisplayDifferentValues is
    signal active_dp : integer range 0 to 7 := 0;   -- selected active display
    signal counter : integer range 0 to 50000 := 0; -- clk refresh rate
    type digit_array (0 to 7) of std_logic_vector(6 downto 0); -- TYPE of variable to use it as a constant
    constant digit_data : digit_array := ( -- constant array for the display numbers
        "1111110", -- 0
        "0110000", -- 1
        "1101101", -- 2
        "1111001", -- 3
        "0110011", -- 4
        "1011011", -- 5
        "1011111", -- 6
        "1110000");-- 7

begin
    process(clk)
    begin 
        if rising_edge(clk) then
            if counter = 50000 then
                counter <= 0;
                active_dp <= (active_dp + 1) mod 8; -- cycle 0 to 7
            else
                counter <= counter + 1;
            end if;

            case active_dp is
                when 0 => 
                    annodes <= "00000001";
                    segments <= not digit_data(0);
                when 1 =>
                    annodes <= "00000010";
                    segments <= not digit_data(1);
                when 2 =>
                    annodes <= "00000100";
                    segments <= not digit_data(2);
                when 3 =>
                    annodes <= "00001000";
                    segments <= not digit_data(3);
                when 4 =>
                    annodes <= "00010000";
                    segments <= not digit_data(4);
                when 5 =>
                    annodes <= "00100000";
                    segments <= not digit_data(5);
                when 6 =>
                    annodes <= "01000000";
                    segments <= not digit_data(6);
                when 7 =>
                    annodes <= "10000000";
                    segments <= not digit_data(7);
            end case;
        end if;
    end process;
end Behavioral;

