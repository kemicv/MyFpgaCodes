library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity eq is
    Port ( i1 : in  STD_LOGIC;
           i0 : in  STD_LOGIC;
           e : out  STD_LOGIC);
end eq;

architecture Behavioral of eq is
	signal p0, p1: STD_LOGIC;
begin
	e <= p0 or p1;
	
	p0 <= (not i0) and (not i1);
	p1 <= i0 and i1;

end Behavioral;

