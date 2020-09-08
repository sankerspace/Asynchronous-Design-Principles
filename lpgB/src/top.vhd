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
	constant B : integer := 23;
	constant v : unsigned(B downto 0) := (0 => '1',others => '0');
	signal start : std_logic_vector(B downto 0) := (others => '0');
	signal reset_intern : std_logic := '0';
	signal timeout_req, timeout_ack : std_logic := '0';
	signal INV_RESET,INV_ACK,INV_RESET_INTERN: std_logic;
	
	
	component LPG_B_CONTROLLER
	port(
		ack 	: in std_logic; 
		reset : in std_logic; 
		LED1  : out std_logic; 
		LED2  : out std_logic; 
		LED3  : out std_logic
	);
	end component LPG_B_CONTROLLER;
begin
	timeout_inst : timeout
	generic map (
		CLK_FREQ    => 50000000,
		TIMEOUT_MS  => 1000,
		SYNC_STAGES => 2
	)
	port map (
		clk   => clk,
		res_n => res_n and INV_RESET_INTERN,
		req   => timeout_req,
		ack   => timeout_ack
	);
	
	led_controller:LPG_B_CONTROLLER
	port map(
		ack=>timeout_ack,
		reset=>INV_RESET or reset_intern,
		LED1=>led1,
		LED2=>led2, 
		LED3=>led3
	);
	
	
	gen_req: process(clk,res_n)
	begin
		if(res_n='0')then
			timeout_req<='0';
			reset_intern<='1';
		elsif(rising_edge(clk)) then
			if start < (start'range => '1') then
				reset_intern<='1';
				timeout_req<='0';
				start<= std_logic_vector(unsigned(start) + v);
			elsif start = (start'range => '1') then
			   reset_intern<='0';
				timeout_req<=INV_ACK;
			end if;
			
		end if;	
	end process gen_req;

	led4 <= timeout_ack;
	INV_ACK <= not timeout_ack;
	INV_RESET <= not res_n;
	INV_RESET_INTERN <= not reset_intern;
end architecture;
