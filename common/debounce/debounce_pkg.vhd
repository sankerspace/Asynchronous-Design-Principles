library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package debounce_pkg is
	component debounce is
		generic (
			COUNTER_SIZE : integer := 19;
			SYNC_STAGES : integer := 2
		);
		port (
			clk : in std_logic;
			res_n : in std_logic;
			data_in : in std_logic;
			data_out : out std_logic
		);
	end component;
end package;

