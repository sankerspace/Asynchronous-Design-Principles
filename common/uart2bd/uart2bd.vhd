library ieee;
use ieee.std_logic_1164.all;

use work.serial_port_pkg.all;
use work.sync_pkg.all;

entity uart2bd is
	generic (
		CLK_FREQ : integer := 50000000;
		BAUD_RATE : integer := 9600;
		BD_SYNC_STAGES : integer := 2;
		UART_SYNC_STAGES : integer := 2
	);
	port (
		clk : in std_logic;
		res_n : in std_logic;
		
		--uart interface
		uart_rx : in std_logic;
		uart_tx : out std_logic;
		
		--bundled data interface
		bd_tx_en : in std_logic;
		bd_tx_req : out std_logic;
		bd_tx_ack : in std_logic;
		bd_rx_req : in std_logic;
		bd_rx_ack : out std_logic;
		bd_tx_data : out std_logic_vector(7 downto 0);
		bd_rx_data : in std_logic_vector(7 downto 0)
	);
end entity;


architecture arch of uart2bd is

	signal uart_data_in : std_logic_vector(7 downto 0);
	signal uart_data_out : std_logic_vector(7 downto 0);
	signal uart_wr : std_logic;
	signal uart_rd : std_logic;
	signal uart_tx_free : std_logic;
	signal uart_rx_empty : std_logic;
	signal uart_rx_full : std_logic;

begin

	serial_port_inst : serial_port
	generic map (
		CLK_FREQ      => CLK_FREQ,
		BAUD_RATE     => BAUD_RATE,
		SYNC_STAGES   => UART_SYNC_STAGES,
		TX_FIFO_DEPTH => 64,
		RX_FIFO_DEPTH => 64
	)
	port map (
		clk           => clk,
		res_n         => res_n,
		tx_data       => uart_data_in,
		tx_wr         => uart_wr,
		tx_free       => uart_tx_free,
		rx_data       => uart_data_out,
		rx_rd         => uart_rd,
		rx_data_empty => uart_rx_empty,
		rx_data_full  => uart_rx_full,
		rx            => uart_rx,
		tx            => uart_tx
	);


	uart2bd : block
		type state_t is (IDLE, WAIT_FOR_ACK_HIGH, WAIT_FOR_ACK_LOW);
		signal state : state_t;
		signal state_next : state_t;
		signal bd_tx_ack_sync : std_logic;
	begin
		bd_tx_data <= uart_data_out;
		
		process(clk, res_n)
		begin
			if(res_n = '0') then
				state <= IDLE;
			elsif (rising_edge(clk)) then
				state <= state_next;
			end if;
		end process;
	
		process(state, uart_rx_empty, bd_tx_ack_sync)
		begin
			state_next <= state;
			uart_rd <= '0';
			bd_tx_req <= '0';
			case state is 
				when IDLE =>
					if (uart_rx_empty='0' and bd_tx_en='1') then
						uart_rd <= '1';
						state_next <= WAIT_FOR_ACK_HIGH;
					end if;
				
				when WAIT_FOR_ACK_HIGH =>
					bd_tx_req <= '1';
					if(bd_tx_ack_sync = '1') then
						bd_tx_req <= '0';
						state_next <= WAIT_FOR_ACK_LOW;
					end if;
				
				when WAIT_FOR_ACK_LOW =>
					if(bd_tx_ack_sync = '0') then
						state_next <= IDLE;
					end if;
				when others => null;
			end case;
		end process;
		
		sync_inst : sync
		generic map (
			SYNC_STAGES => BD_SYNC_STAGES,
			RESET_VALUE => '0'
		)
		port map (
			clk => clk,
			res_n => res_n,
			data_in => bd_tx_ack,
			data_out => bd_tx_ack_sync
		);
	end block;
	
	bd2uart : block
		signal bd_rx_req_sync : std_logic;
		type state_t is (IDLE, WAIT_FOR_REQ_LOW);
		signal state : state_t;
		signal state_next : state_t;
	begin
		uart_data_in <= bd_rx_data;

		process(clk, res_n)
		begin
			if(res_n = '0') then
				state <= IDLE;
			elsif (rising_edge(clk)) then
				state <= state_next;
			end if;
		end process;
		
		process(state, bd_rx_req_sync)
		begin
			uart_wr <= '0';
			bd_rx_ack <= '0';
			state_next <= state;
			
			case state is 
				when IDLE =>
					if(bd_rx_req_sync = '1') then
						state_next <= WAIT_FOR_REQ_LOW;
						uart_wr <= '1';
						bd_rx_ack <= '1';
					end if;
				when WAIT_FOR_REQ_LOW =>
					bd_rx_ack <= '1';
					if(bd_rx_req_sync = '0' and uart_rx_full='0') then
						bd_rx_ack <= '0';
						state_next <= IDLE;
					end if;
			end case;
			
		end process;
		
		
		sync_inst : sync
		generic map (
			SYNC_STAGES => BD_SYNC_STAGES,
			RESET_VALUE => '0'
		)
		port map (
			clk => clk,
			res_n => res_n,
			data_in => bd_rx_req,
			data_out => bd_rx_req_sync
		);
	
	end block;
	
end architecture;


