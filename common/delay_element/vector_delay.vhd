
library ieee;
use ieee.std_logic_1164.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

use work.delay_element_pkg.all;

entity vector_delay is
	generic (
		NUM_LCELLS : integer_array
	); 
	port (
		i : in std_logic_vector(NUM_LCELLS'length-1 downto 0);
		o : out std_logic_vector(NUM_LCELLS'length-1 downto 0)
	);
end entity;


architecture arch of vector_delay is
begin
	gen_delay_elements : for idx in 0 to NUM_LCELLS'length-1 generate
		
		delay_element_inst : delay_element
		generic map (
			NUM_LCELLS => NUM_LCELLS(idx)
		)
		port map (
			i => i(idx),
			o => o(idx)
		);

		
	end generate;
	
end architecture;





