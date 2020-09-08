
library ieee;
use ieee.std_logic_1164.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

entity delay_element is
	generic (
		NUM_LCELLS : integer := 8
	); 
	port (
		i : in std_logic;
		o : out std_logic
	);
end entity;


architecture arch of delay_element is
	signal s : std_logic_vector(NUM_LCELLS downto 0);
	attribute preserve: boolean;
	attribute preserve of s: signal is true;
begin
	s(0) <= i;
	o <= s(NUM_LCELLS);
	g_luts: for i in 0 to NUM_LCELLS-1 generate
		cmp_LUT: LCELL
		port map(
			a_in => s(i),
			a_out => s(i+1)
		);
	end generate;
	
end architecture;





