library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Generates a pwm signal to control a led at a given percentage

-- We have to calculate the complete duty cycle
-- The board has a 50MHz oscilator. Human eye can perceive flickering at 100Hz,
-- then a 250Hz frequency is enough to deceive human eye.
-- since t = 1/f (t: time, f: frequency) then =>  t = 1/250Hz = 0.004s (4ms)
-- THE DUTY CYCLE TIME IS: 4ms

-- Then we need to scale it to FPGA's ocisllator (50MHz)
-- 1000ms => 50MHz, 4ms => x
-- x = (50_000_000 * 4) / 1000
-- x = 200_000Hz (200kHz)

-- Or more easy is 50_000_000 / 250 = 200_000
-- Basically 200_000-clk-cycles are 100% of duty cycle

entity PwmLed is
    port ( clk  : in std_logic;
           s    : in std_logic;
           led : out std_logic_vector(7 downto 0) );
end PwmLed;

architecture Behavioral of PwmLed is
    signal clkCompleteDutyCycle : integer range 0 to 199_999 := 0;
    constant Period : integer := 199_999;
begin

    led(0) <= s;

    process(clk)
    begin
        if rising_edge(clk) then
            -- PWM cycle control
            if clkCompleteDutyCycle = Period then
                clkCompleteDutyCycle <= 0;
            else
                clkCompleteDutyCycle <= clkCompleteDutyCycle + 1;
            end if;

            -- PWM modulation
            -- 10%
            if clkCompleteDutyCycle < (10 * Period) / 100 then
                led(7) <= '1';
            else
                led(7) <= '0';
            end if;
            -- 20%
            if clkCompleteDutyCycle < (20 * Period) / 100 then
                led(6) <= '1';
            else
                led(6) <= '0';
            end if;
            -- 30%
            if clkCompleteDutyCycle < (30 * Period) / 100 then
                led(5) <= '1';
            else
                led(5) <= '0';
            end if;
            -- 50%
            if clkCompleteDutyCycle < (50 * Period) / 100 then
                led(4) <= '1';
            else
                led(4) <= '0';
            end if;
            -- 70%
            if clkCompleteDutyCycle < (70 * Period) / 100 then
                led(3) <= '1';
            else
                led(3) <= '0';
            end if;
            -- 75%
            if clkCompleteDutyCycle < (75 * Period) / 100 then
                led(2) <= '1';
            else
                led(2) <= '0';
            end if;
            -- 80%
            if clkCompleteDutyCycle < (80 * Period) / 100 then
                led(1) <= '1';
            else
                led(1) <= '0';
            end if;
        end if;
    end process;
end Behavioral;
