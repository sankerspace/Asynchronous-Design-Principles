

library ieee;
use ieee.std_logic_1164.all;

entity C2_s is 
	port (
		A : in std_logic;
		B : in std_logic;
		Q : out std_logic;
		S : in std_logic
	);
end entity;


architecture arch of C2_s is
	component C2_s_lut is 
		port (
			A : in std_logic;
			B : in std_logic;
			S : in std_logic;
			Q : out std_logic;
			Q_old : in std_logic
		);
	end component;
	
	signal feedback_wire : std_logic;
begin
	C2_inst : C2_s_lut
	port map (
		A     => A,
		B     => B,
		S     => S,
		Q     => feedback_wire,
		Q_old => feedback_wire
	);
	Q <= feedback_wire;
end architecture;


