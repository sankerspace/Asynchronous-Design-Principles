
library ieee;
use ieee.std_logic_1164.all;

LIBRARY altera;
use altera.altera_primitives_components.all;


entity NC2_lut is 
	port (
		A : in std_logic;
		B : in std_logic;
		Q : out std_logic;
		Q_old : in std_logic
	);
end entity;


architecture arch of NC2_lut is
	signal a_in : std_logic;
	signal b_in : std_logic;
	signal q_old_in : std_logic;
	signal q_out : std_logic;
begin
	A_lut_input : lut_input
	port map (a_in=>A, a_out=>a_in);
	
	B_lut_input : lut_input
	port map (a_in=>B, a_out=>b_in);
	
	Q_old_lut_input : lut_input
	port map (a_in=>Q_old, a_out=>q_old_in);
	
	Q_lut_output : lut_output
	port map (a_in=>q_out, a_out=>Q);
	
	q_out <= (not a_in and not b_in) or (not a_in and q_old_in) or (not b_in and q_old_in);
	
end architecture;
