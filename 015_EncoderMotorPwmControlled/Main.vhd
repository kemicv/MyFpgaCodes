library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MotorControl is
    port( clk: in std_logic;
          in1: in std_logic; -- Switch for motor FWD
          in2: in std_logic; -- Switch for motor REV
		  pwmChange: in std_logic; -- switch from 100% to 50% dutycycle
          encoderA: in std_logic; -- Motor encoder A
          encoderB: in std_logic; -- Motor encoder B
          out1: out std_logic; -- Motor FWD
          out2: out std_logic; -- Motor REV
          pwm: out std_logic;
          segments: out std_logic_vector(6 downto 0);
          display : out std_logic_vector(7 downto 0) );
end MotorControl;

architecture Behavioral of MotorControl is
    constant PwmCounts: integer := 250_000; --25k
    signal DutyCycle: integer := 0; -- use value from 0 to 100
begin
    pwmIp: entity work.PwmControl
        port map(clk=>clk,
            counts=>PwmCounts, dutyCycle=>DutyCycle,
            pwmSignal=>pwm);
    
    encoderIp: entity work.EncoderCounter
        port map( clk => clk,
            aSignal => encoderA, bSignal => encoderB,
            segments => segments, display => display);
			
	out1 <= in1 and (not in2);
	out2 <= in2 and (not in1);
	
	process(pwmChange)
	begin
		if pwmChange = '1' then
			DutyCycle <= 80;
		else
			DutyCycle <= 10;
		end if;
	end process;	
end Behavioral;

