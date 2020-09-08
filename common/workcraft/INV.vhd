

library ieee;
use ieee.std_logic_1164.all;

entity INV is 
	port (
		I : in std_logic;
		O : out std_logic
	);
end entity;


architecture arch of INV is
begin
	O <= not I;
end architecture;


