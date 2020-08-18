library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity logica_combinatoria is
	port (
		estado	:	in	std_logic_vector (2 downto 0);
		semaforos	:	out	std_logic_vector (5 downto 0)
	);
end logica_combinatoria;

architecture arch_combinatoria of logica_combinatoria is
begin
	with estado select semaforos <=
		"001100" when "000",
		"010100" when "001",
		"100010" when "010",
		"100001" when "011",
		"000000" when "100",
		"010010" when "110",
		"000000" when others;
end arch_combinatoria;