library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package delay_element_pkg is

	type integer_array is array(natural range<>) of integer;

	component delay_element is
		generic (
			NUM_LCELLS : integer := 8
		);
		port (
			i : in std_logic;
			o : out std_logic
		);
	end component;
	
	component vector_delay is
		generic
		(
			NUM_LCELLS : integer_array
		);
		port
		(
			i : in std_logic_vector(NUM_LCELLS'length-1 downto 0);
			o : out std_logic_vector(NUM_LCELLS'length-1 downto 0)
		);
	end component;
end package;

