library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity logica_sequencial is
	generic(
		short_delay : integer := 3; -- valor em segundos
		long_delay	: integer := 12 -- valor em segundos
	);
	port(
		pva, pvb, noturno, reset, p: in std_logic;
		clock: in std_logic;
		q: out std_logic_vector (2 downto 0)
	);
end logica_sequencial;

architecture arch_sequencial of logica_sequencial is

	signal troca_dia	:	std_logic := '0';
	signal Eatual	:	std_logic_vector (2 downto 0) := "000";
	signal seg_count	:	integer range 0 to long_delay := 0;
	signal pedestre : std_logic := '0'; -- guarda informação de pedestre
	
begin

	Counter: process (reset, clock, noturno, Eatual, pva, pvb, p) is
	begin
	
		if reset = '1' then		-- reset assincrono
			Eatual <= "100";
			seg_count <= 0;
			pedestre <= '0'; 
		
		elsif  p = '1' and pedestre = '0' then -- logica para gravar presença de pedestre
			pedestre <= '1';
			
		-- suspende contagem de tempo quando sem carro em uma via
		elsif noturno = '0' and pva = '0' and Eatual = "011" and pedestre = '0' then
			seg_count <= 0;
		elsif noturno = '0' and pvb = '0' and Eatual ="000" and pedestre = '0' then
			seg_count <= 0;
		
		-- quando ha subida de clock
		elsif clock'event and clock = '1' then
			seg_count <= seg_count + 1;

			
		
			
			if pedestre = '1' and Eatual = "000" then -- transicoes pedestres
				Eatual <= "001";
				seg_count <= 0;
			elsif pedestre = '1' and Eatual = "011" then
				Eatual <= "010";
				seg_count <= 0;
			elsif pedestre = '1' and seg_count = (short_delay - 1) and Eatual = "001" then
				Eatual <= "111";
				seg_count <= 0;
			elsif pedestre = '1' and seg_count = (short_delay - 1) and Eatual = "010" then
				Eatual <= "111";
				seg_count <= 0;
			elsif pedestre = '1' and Eatual = "110" then -- amarelo piscante (sempre caira aqui, mesmo no estado "100")
				Eatual <= "111";
				seg_count <= 0;
			elsif pedestre = '1' and seg_count = (short_delay - 2) and Eatual = "111" then --TUDO VERMELHO POR 2 SEGUNDOS 
				Eatual <= "101"; 
				seg_count <= 0;
			elsif pedestre = '1' and seg_count = (long_delay - 1) and Eatual = "101" then --Carros parados, pedestres atravessando
					Eatual <= "000";
					pedestre <= '0';
					
			
			-- transicoes noturnas		
			elsif noturno = '1' and Eatual = "000" then
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