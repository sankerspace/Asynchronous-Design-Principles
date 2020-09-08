library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.workcraft_pkg.all;
use work.timeout_pkg.all;

entity top is
	port (
		clk : in std_logic;
		res_n : in std_logic;
		led1 : out std_logic;
		led2 : out std_logic;
		led3 : out std_logic;
		led4: out std_logic
	);
end entity;

architecture arch of top is
	signal timeout_req, timeout_ack : std_logic :='0';
	signal INV_RESET:std_logic;
	signal INV_REQ:std_logic;
	
	component LPG_A_CONTROLLER
	port(
		ack: in std_logic;
		reset: in std_logic;
		LED1: out std_logic;
		LED2: out std_logic;
		LED3: out std_logic
	);
	end component LPG_A_CONTROLLER;
begin
	timeout_inst : timeout
	generic map (
		CLK_FREQ    => 50000000,
		TIMEOUT_MS  => 1000,
		SYNC_STAGES => 2
	)
	port map (
		clk   => clk,
		res_n => res_n,
		req   => timeout_req,
		ack   => timeout_ack
	);

	lgpA_controller: LPG_A_CONTROLLER
	port map(
		ack=>timeout_ack,
		reset=>INV_RESET,
		LED1=>led1, 
		LED2=>led2, 
		LED3=>led3
	);
	
	
gen_req:process(clk,res_n)
begin
if(res_n='0')then
	timeout_req<='0';
elsif (rising_edge(clk)) then
	timeout_req<= INV_REQ;
end if;

end process gen_req;

led4 <= timeout_ack;
INV_RESET <= not res_n;
INV_REQ <= not timeout_req;
end architecture;
