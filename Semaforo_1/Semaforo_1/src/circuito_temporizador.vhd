library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity circuito_temporizador is
	generic(
		freq_in	: natural := 50E6	-- valor dado em Hertz
	);
	port(
		clock_in, reset: in std_logic;
		clock_out: out std_logic
	);
end circuito_temporizador;

architecture arch_temporizador of circuito_temporizador is

	signal count	:	natural range 0 to freq_in := 0;
	signal clock_aux	:	std_logic := '0';

begin

	Counter: process (reset, clock_in) is
	begin
		-- reset assincrono
		if reset = '1' then
			count <= 0;
			clock_aux <= '0';
			
		-- borda de subida de clock
		elsif clock_in'event and clock_in = '1' then
			-- determina a saida do clock
			if count = (freq_in - 1) then
				count <= 0;
				clock_aux <= '0';
			elsif count >= ((freq_in / 2) - 1) then
				clock_aux <= '1';
				count <= count + 1;
			else
			clock_aux <='0';
				count <= count + 1;
			end if;
			
		end if;
	end process;
	
	clock_out <= clock_aux;
end arch_temporizador;