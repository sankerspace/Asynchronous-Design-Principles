library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;

entity timeout is
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
end entity;

architecture arch of timeout is
	
	signal cnt : std_logic_vector(log2c((CLK_FREQ/1000)*TIMEOUT_MS)-1 downto 0);
	constant CNT_MAX : integer := (CLK_FREQ/1000)*TIMEOUT_MS-1;
	
	--signal req_sync_stages : std_logic_vector(SYNC_STAGES-1 downto 0);
	--alias req_sync : std_logic is req_sync_stages(0);
	signal req_sync : std_logic:='1';
begin
/*
	req_syncronizer : process(req, clk, res_n) 
	begin
		if (res_n = '0') then
			req_sync_stages <= (others=>'0');
		elsif (rising_edge(clk)) then
			req_sync_stages(SYNC_STAGES-1 downto 0) <= req & req_sync_stages(SYNC_STAGES-1 downto 1);
		end if;
	end process;
	*/
	
	process(clk, res_n) 
	begin
		if (res_n = '0') then
			cnt <= (others=>'0');
			ack <= '0';
			req_sync<='1';
		elsif (rising_edge(clk)) then
			if (req_sync = '1') then
				if (unsigned(cnt) = CNT_MAX) then
					ack <= '1';
					req_sync<='0';
				else
					cnt <= std_logic_vector(unsigned(cnt) + 1);
				end if;
			else
				if (unsigned(cnt) = 0) then
					ack <= '0';
					req_sync<='1';
				else
					cnt <= std_logic_vector(unsigned(cnt) - 1);
				end if;
			end if;
		end if;
	end process;

end architecture;
