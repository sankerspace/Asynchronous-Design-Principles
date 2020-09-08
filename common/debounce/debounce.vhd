
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sync_pkg.all;

entity debounce is
	generic (
		COUNTER_SIZE : integer := 19;
		SYNC_STAGES  : integer := 2
	);
	port (
		clk      : in  std_logic;
		res_n    : in  std_logic;
		data_in  : in  std_logic;
		data_out : out std_logic
	); 
end entity;

architecture arch of debounce is
	signal counter : std_logic_vector(COUNTER_SIZE downto 0); 
	signal counter_reset : std_logic;
	signal input_sync : std_logic;
	signal input_sync_last : std_logic;
begin

	sync_inst : sync
	generic map (
		SYNC_STAGES => SYNC_STAGES,
		RESET_VALUE => '0'
	)
	port map (
		clk => clk,
		res_n => res_n,
		data_in => data_in,
		data_out => input_sync
	);

	counter_reset <= input_sync xor input_sync_last;

	process(res_n, clk)
	begin
		if (res_n = '0') then
			input_sync_last <= '0';
			data_out <= '0';
			counter <= (others=>'0');
		elsif (rising_edge(clk)) then
			input_sync_last <= input_sync;
			if (counter_reset = '1') then
				counter <= (others=>'0');
			elsif counter(counter_size) = '0' then
				counter <= std_logic_vector(unsigned(counter) + 1);
			else
				data_out <= input_sync;
			end if;
		end if;
	end process;

end architecture;
