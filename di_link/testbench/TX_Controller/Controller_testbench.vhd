
library ieee;
use ieee.std_logic_1164.all;


entity test_TX_CONTROLLER is
   -- PORT ( count : BUFFER bit_vector(8 downto 1));
end;


-------------------------------------------------------



architecture test_TX_CONTROLLER_BEH of test_TX_CONTROLLER is

COMPONENT tx_controller
	PORT(
		ack_in: in std_logic;
		reset: in std_logic;	
		req: in std_logic;
		ack_out: out std_logic;
		en: out std_logic
	);
END COMPONENT;

constant clk_period : time := 20 ns; -- 50Mhz
constant input_period : time := 100 ns; -- 10Mhz
SIGNAL clk   : std_logic := '0';
SIGNAL reset : std_logic := '0';
SIGNAL ack_in,ack_out,req,en : std_logic := '0';
TYPE State_type IS (INIT,REQUEST, ENABLE, RX_ACK, TX_ACK);  -- Define the states
SIGNAL State : State_Type := INIT ;
--SIGNAL input,output: std_logic :='0';
begin
--------- DUT ---------------
dut: tx_controller
	port map(
		ack_in => ack_in,
		reset => reset,
		req => req,
		ack_out => ack_out,
		en=>en
	);

------- CLOCKS--------------------

clock : PROCESS
   begin
   wait for clk_period/2; clk  <= not clk;
end PROCESS clock;


--clock_gen: process is
--begin
--	if(reset = '1')then
--		reset <= '0';
--	end if;
--  wait for clk_period/2; clk <= not clk;
--end process clock_gen;  

stimulus: process
begin
--if (rising_edge(clk)) then
	case State is 
		when INIT=>
			reset<='1';
			wait for 2ns;
			reset<='0';
			State<=REQUEST;
		when REQUEST=>
			req<='1'; --begin handshake 1
			wait for 2ns;
			State<=ENABLE;
		when ENABLE=>
			if en = '1' then --begin handshake 2
				wait for 2ns;
				ack_in<='1';				
				state<=RX_ACK;
			end if;
		when RX_ACK=>
			if(en='0' and ack_out='1')then
				wait for 2ns;
				ack_in<='0';--end handshake 2
				req<='0';
				state<=TX_ACK;
			end if;
		when TX_ACK=>
		if ack_out='0' then --end handshake 1
			state<=REQUEST;
			wait for 2ns;
			
		end if;
	end case;
--end if;
end process stimulus;

end architecture  test_TX_CONTROLLER_BEH;