library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity unidade_controle is
	port(
		reset: in std_logic;	-- sinal comum aos modulos
		pva, pvb, noturno: in std_logic;	-- sinais do logica_sequencial
		clock: in std_logic;	-- sinais do circuito_temporizador
		semaforos: out std_logic_vector (5 downto 0) -- sinais dos semaforos indicados no relatorio
	);
end unidade_controle;

architecture arch_controle of unidade_controle is
	
	-- temporizador que converte a freq_in em 1 Hz
	component circuito_temporizador is
		generic(
			freq_in	: natural := 50E6	-- valor em Hertz
		);
		port(
			clock_in, reset: in std_logic;
			clock_out: out std_logic
		);
	end component circuito_temporizador;
	
	-- logica de transicao de estados
	component logica_sequencial is
		generic(
			short_delay : integer := 5; -- valor em segundos
			long_delay	: integer := 60 -- valor em segundos
		);
		port(
			pva, pvb, noturno, reset: in std_logic;
			clock: in std_logic;
			q: out std_logic_vector (2 downto 0)
		);
	end component logica_sequencial;
	
	-- circuito para acionamento dos semaforos
	component logica_combinatoria is
		port (
			estado	:	in	std_logic_vector (2 downto 0);
			semaforos	:	out	std_logic_vector (5 downto 0)
		);
	end component logica_combinatoria;

	-- sinal auxiliar para o port map
	signal clock_1hz : std_logic;
	signal q: std_logic_vector (2 downto 0);
	
begin

	-- port map do circuito temporizador
	tempo:	circuito_temporizador port map (clock, reset, clock_1hz);
	-- port map da logica sequencial
	seq:		logica_sequencial port map (pva, pvb, noturno, reset, clock_1hz, q);
	-- port map da logica combinatoria
	comb:		logica_combinatoria port map (q, semaforos);

end arch_controle;
