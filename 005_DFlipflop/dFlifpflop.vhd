library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--D Flip Flop Explanation
--  It is a one-bit digital memory. Takes the input value 'D'
--  at the rising edge of a 'clock' signal passsing the value
--  to 'Q' until the next 'clock' rising edge.
--  Reset restores the 'Q' value to 0.

entity dFlipflop is
    port ( clk   : in std_logic;
           reset : in std_logic;
           d     : in std_logic;
           q     : out std_logic);
end dFlipflop;

architecture Behavioral of dFlipflop is
begin
-- Process block is only executed when clk or reset changes
    process(clk, reset)
    begin
        if reset = '1' then
            q <= '0';
        elsif rising_edge(clk) then
            q <= d;
        end if;
    end process;
end Behavioral;

