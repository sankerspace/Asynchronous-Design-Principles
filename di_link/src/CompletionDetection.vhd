  
library ieee;
use ieee.std_logic_1164.all;

entity CD is
	port (
		reset		: in std_logic;
		input 	: in std_logic_vector(3 downto 0);
		valid 	: out std_logic
	);
end entity;



architecture CD_behave of CD is
-- number of 1-of-4 Codes
signal detect_11,detect_10,detect_01,detect_00: std_logic;
begin
	detect_11 <=(	   input(3) and  not 	input(2) and 	not   input(1)	and not 	input(0)) 		and not reset;
	detect_10 <=( not input(3) and  		   input(2) and	not 	input(1) and not 	input(0)) 		and not reset;
	detect_01 <=( not input(3) and  not 	input(2) and  			input(1) and not 	input(0)) 	   and not reset;
	detect_00 <=( not input(3) and  not 	input(2) and	not 	input(1) and 		input(0))	   and not reset;
	
	valid		 <= (detect_11 or detect_10 or detect_01 or detect_00) and not reset;
	
end architecture CD_behave;