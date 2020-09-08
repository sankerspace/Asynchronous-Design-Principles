library ieee;
use ieee.std_logic_1164.all;

package timeout_pkg is
	component timeout is
		generic (
			CLK_FREQ : integer := 50000000;
			TIMEOUT_MS : integer := 1000;
			SYNC_STAGES : integer := 2
		);
		port (
			clk : in std_logic;
			res_n : in std_logic;
			req : in std_logic;
			ack : out std_logic
		);
	end component;
end package;

