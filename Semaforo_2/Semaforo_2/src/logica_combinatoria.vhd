library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity logica_combinatoria is
	port (
		estado	:	in	std_logic_vector (2 downto 0);
		semaforos	:	out	std_logic_vector (9 downto 0)
	);
end logica_combinatoria;

architecture arch_combinatoria of logica_combinatoria is
begin
	with estado select semaforos <=
		"0100110010" when "000",
		"0101010010" when "001",
		"1010001010" when "010",
		"1010000110" when "011",
		"0000000010" when "100",
		"0010010001" when "101",
		"0001001010" when "110",
		"0010010010" when "111";
end arch_combinatoria;