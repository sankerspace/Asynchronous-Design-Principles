

library ieee;
use ieee.std_logic_1164.all;

entity NC2_r is 
	port (
		A : in std_logic;
		B : in std_logic;
		QN : out std_logic;
		R : in std_logic
	);
end entity;


architecture arch of NC2_r is
	component NC2_r_lut is 
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
	NC2_r_inst : NC2_r_lut
	port map (
		A     => A,
		B     => B,
		Q     => feedback_wire,
		Q_old => feedback_wire,
		R     => R
	);
	QN <= feedback_wire;
end architecture;


