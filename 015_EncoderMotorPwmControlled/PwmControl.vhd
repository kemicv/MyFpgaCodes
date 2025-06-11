library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Inputs: clock period (counts), % duty cycle.
-- Out: Pwm signal.

-- For clock period consider the next process:
-- t=1/Hz: where t is the desired PWM period and Hz is the equivalent frequency
-- example with 2kHz: t = 1/2000Hz = 0.5ms
-- if 1000ms -> 50M counts; then 0.5ms ->  X (25k counts)

entity PwmControl is
    port ( clk       : in std_logic;
           counts    : in integer range 0 to 16_000_000;
           dutyCycle : in integer range 0 to 100;
           pwmSignal : out std_logic );
end PwmControl;

architecture Behavioral of PwmControl is
    signal clkSignal : integer range 0 to 65_535 := 0;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            -- PWM cycle control
            if clkSignal = counts then
                clkSignal <= 0;
            else
                clkSignal <= clkSignal + 1;
            end if;

            -- PWM modulation
            if clkSignal < (dutyCycle * counts / 100) then
                pwmSignal <= '1';
            else
                pwmSignal <= '0';
            end if;
       
        end if;
    end process;
end Behavioral;

