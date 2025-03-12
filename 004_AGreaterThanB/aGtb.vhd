library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity aGtb is
    Port ( a : in  STD_LOGIC_VECTOR (1 downto 0);
           b : in  STD_LOGIC_VECTOR (1 downto 0);
           r : out  STD_LOGIC);
end aGtb;

architecture Behavioral of aGtb is
	signal e0, e1: STD_LOGIC;
begin
	r <= e0 or e1;
	
	e0 <= a(0) and (not b(0)) and (a(1) xnor b(1));
	e1 <= a(1) and (not b(1));
end Behavioral;

