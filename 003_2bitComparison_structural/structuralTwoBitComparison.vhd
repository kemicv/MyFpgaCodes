library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity structuralTwoBitComparison is
    Port ( a : in  STD_LOGIC_VECTOR (1 downto 0);
           b : in  STD_LOGIC_VECTOR (1 downto 0);
           abeq : out  STD_LOGIC);
end structuralTwoBitComparison;

architecture Behavioral of structuralTwoBitComparison is
	signal e0, e1: STD_LOGIC;
begin
	eq_bit0_unit: entity work.eq
		port map(i0=>a(0), i1=>b(0), e=>e0);
	eq_bit1_unit: entity work.eq
		port map(i0=>a(1), i1=>b(1), e=>e1);

	abeq <= e0 and e1;

end Behavioral;

