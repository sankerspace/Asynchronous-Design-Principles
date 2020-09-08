

library ieee;
use ieee.std_logic_1164.all;

LIBRARY altera;
use altera.altera_primitives_components.all;

entity C2 is 
	port (
		A : in std_logic;
		B : in std_logic;
		Q : out std_logic
	);
end entity;

--architecture arch of C2 is
--	
--	signal a_in : std_logic;
--	signal b_in : std_logic;
--	signal q_out : std_logic;
--begin
--	A_lut_input : lut_input
--	port map (a_in=>A, a_out=>a_in);
--	
--	B_lut_input : lut_input
--	port map (a_in=>B, a_out=>b_in);
--	
--	Q_lut_output : lut_output
--	port map (a_in=>q_out, a_out=>Q);
--	
--	process(a_in, b_in) 
--	begin
--		if((a_in and b_in)='1') then
--			q_out <= '1';
--		elsif( (a_in or b_in)='0' ) then
--			q_out <= '0'; 
--		end if;
--	end process;
--end architecture;

--architecture arch of C2 is
--begin
--	process(A, B) 
--	begin
--		if((A and B)='1') then
--			Q <= '1';
--		elsif((A or B)='0' ) then
--			Q <= '0'; 
--		end if;
--	end process;
--end architecture;


architecture arch of C2 is
	component C2_lut is 
		port (
			A : in std_logic;
			B : in std_logic;
			Q : out std_logic;
			Q_old : in std_logic
		);
	end component;
	
	signal feedback_wire : std_logic;
begin
	C2_inst : C2_lut
	port map (
		A     => A,
		B     => B,
		Q     => feedback_wire,
		Q_old => feedback_wire
	);
	Q <= feedback_wire;
end architecture;


