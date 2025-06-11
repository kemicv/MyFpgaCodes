library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MotorControl is
    port( clk: in std_logic;
          in1: in std_logic;
          in2: in std_logic;
          out1: out std_logic;
          out2: out std_logic;
          pwm: out std_logic );
end MotorControl;

architecture Behavioral of MotorControl is
    constant PwmCounts := 25_000;
    constant DutyCycle := 20; -- use value from 0 to 100
begin
    pwm: entity work.PwmControl
        port map(clk=>clk,
            counts=>PwmCounts, dutyCycle=>DutyCycle
            pwmSignal=>pwm);
    binaryDecoder

end Behavioral;

