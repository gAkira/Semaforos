library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity logica_sequencial is
	generic(
		short_delay : integer := 5; -- valor em segundos
		long_delay	: integer := 60 -- valor em segundos
	);
	port(
		pva, pvb, noturno, reset: in std_logic;
		clock: in std_logic;
		q: out std_logic_vector (2 downto 0)
	);
end logica_sequencial;

architecture arch_sequencial of logica_sequencial is

	signal troca_dia	:	std_logic := '0';
	signal Eatual	:	std_logic_vector (2 downto 0) := "000";
	signal seg_count	:	integer range 0 to 60 := 0;

begin

	Counter: process (reset, clock, noturno, Eatual, pva, pvb) is
	begin
		-- reset assincrono
		if reset = '1' then
			Eatual <= "100";
			seg_count <= 0;
			
		-- suspende contagem de tempo quando sem carro em uma via
		elsif noturno = '0' and pva = '0' and Eatual = "011" then
			seg_count <= 0;
		elsif noturno = '0' and pvb = '0' and Eatual = "000" then
			seg_count <= 0;
		
		-- quando ha subida de clock
		elsif clock'event and clock = '1' then
			seg_count <= seg_count + 1;
			
			-- transicoes noturnas
			if noturno = '1' and Eatual = "000" then
				Eatual <= "110";
				seg_count <= 0;
			elsif noturno = '1' and Eatual = "110" then 
				Eatual <= "100";
				seg_count <= 0;
			elsif noturno = '0' and Eatual = "110" then
				Eatual <= "000";
				seg_count <= 0;
			elsif Eatual = "100" then
				Eatual <= "110";
				seg_count <= 0;
			
			-- transicoes diurnas
			elsif seg_count = (short_delay - 1) and Eatual = "001" then
				Eatual <= "011";
				seg_count <= 0;
			elsif seg_count = (short_delay - 1) and Eatual = "010" then
				Eatual <= "000";
				seg_count <= 0;
			elsif seg_count = (long_delay - 1) and Eatual = "000" then
				Eatual <= "001";
				seg_count <= 0;
			elsif seg_count = (long_delay - 1) and Eatual = "011" then
				Eatual <= "010";
				seg_count <= 0;
			end if;
		end if;
	end process;

	q <= Eatual;
end arch_sequencial;