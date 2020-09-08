library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package workcraft_pkg is

	component C2 is
		port (
			A : in std_logic;
			B : in std_logic;
			Q : out std_logic
		);
	end component;
	
	component C2_s is
		port (
			A : in std_logic;
			B : in std_logic;
			Q : out std_logic;
			S : in std_logic
		);
	end component;
	
	component C2_r is
		port (
			A : in std_logic;
			B : in std_logic;
			Q : out std_logic;
			R : in std_logic
		);
	end component;
	
	component NC2 is
		port (
			A : in std_logic;
			B : in std_logic;
			QN : out std_logic
		);
	end component;
	
	component NC2_r is
		port (
			A : in std_logic;
			B : in std_logic;
			QN : out std_logic;
			R : in std_logic
		);
	end component;

	component INV is
		port (
			I : in std_logic;
			O : out std_logic
		);
	end component;
	
end package;

