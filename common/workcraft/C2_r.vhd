

library ieee;
use ieee.std_logic_1164.all;

entity C2_r is 
	port (
		A : in std_logic;
		B : in std_logic;
		Q : out std_logic;
		R : in std_logic
	);
end entity;


architecture arch of C2_r is
	component C2_r_lut is 
		port (
			A : in std_logic;
			B : in std_logic;
			R : in std_logic;
			Q : out std_logic;
			Q_old : in std_logic
		);
	end component;
	
	signal feedback_wire : std_logic;
begin
	C2_r_inst : C2_r_lut
	port map (
		A     => A,
		B     => B,
		R     => R,
		Q     => feedback_wire,
		Q_old => feedback_wire
	);
	Q <= feedback_wire;
end architecture;


