

library ieee;
use ieee.std_logic_1164.all;

entity NC2 is 
	port (
		A : in std_logic;
		B : in std_logic;
		QN : out std_logic
	);
end entity;


architecture arch of NC2 is
	component NC2_lut is 
		port (
			A : in std_logic;
			B : in std_logic;
			Q : out std_logic;
			Q_old : in std_logic
		);
	end component;
	
	signal feedback_wire : std_logic;
begin
	NC2_inst : NC2_lut
	port map (
		A     => A,
		B     => B,
		Q     => feedback_wire,
		Q_old => feedback_wire
	);
	QN <= feedback_wire;
end architecture;


