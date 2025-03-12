library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TwoBitComparison is
    Port ( a, b : in  STD_LOGIC_VECTOR(1 downto 0);
           aeqb : out  STD_LOGIC);
end TwoBitComparison;

architecture Behavioral of TwoBitComparison is
	signal p0, p1, p2, p3: STD_LOGIC;
begin
	aeqb <= p0 or p1 or p2 or p3;
	
	p0 <= (not a(1)) and (not b(1)) and 
			(not a(0)) and (not b(0));
	p1 <= (not a(1)) and (not b(1)) and (a(0) and b(0));
	p2 <= (not a(0)) and (not b(0)) and (a(1) and b(1));
	p3 <= a(1) and b(1) and a(0) and b(0);

end Behavioral;

