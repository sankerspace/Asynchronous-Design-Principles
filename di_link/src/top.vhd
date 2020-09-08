
library ieee;
use ieee.std_logic_1164.all;

use work.uart2bd_pkg.all;
use work.di_txrx_pkg.all;
use work.debounce_pkg.all;
use work.delay_element_pkg.all;


entity top is
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
		
		--DI (dual rail) interface
		di_tx_ack : in std_logic;  -- from ribbon cable back to Tx
		di_rx_ack : out std_logic; --also over ribbon cabble
		di_tx_data : out std_logic_vector(15 downto 0); --OUT TO RIBBON CABLE
		di_rx_data : in std_logic_vector(15 downto 0);  -- INPUT FROM RIBBON CABLE
																		-- MIDDLE CONNECTOR OF RIBBON CABLE ATTACHED TO LOGIC ANALYZER 
		-- additional control 
		bd_tx_en : in std_logic
	);
end entity;

architecture arch of top is 
	signal bd_tx_req : std_logic;
	signal bd_tx_ack : std_logic;
	signal bd_tx_data : std_logic_vector(7 downto 0);
	
	signal bd_rx_req : std_logic;
	signal bd_rx_ack : std_logic;
	signal bd_rx_data : std_logic_vector(7 downto 0);
	
	signal res : std_logic;
	signal bd_tx_en_sync : std_logic;
	
	signal di_tx_data_int : std_logic_vector(15 downto 0);
	
begin
	uart2bd_inst : uart2bd
	generic map (
		CLK_FREQ         => CLK_FREQ,
		BAUD_RATE        => BAUD_RATE,
		BD_SYNC_STAGES   => BD_SYNC_STAGES,
		UART_SYNC_STAGES => UART_SYNC_STAGES
	)
	port map (
		clk        => clk,
		res_n      => res_n,
		uart_rx    => uart_rx,
		uart_tx    => uart_tx,
		bd_tx_en   => bd_tx_en_sync,
		bd_tx_req  => bd_tx_req,
		bd_tx_ack  => bd_tx_ack,
		bd_rx_req  => bd_rx_req,
		bd_rx_ack  => bd_rx_ack,
		bd_tx_data => bd_tx_data,
		bd_rx_data => bd_rx_data
	);

	tx_inst : tx
	port map (
		res_n   => res_n,
		bd_req  => bd_tx_req,
		bd_ack  => bd_tx_ack,
		bd_data => bd_tx_data,
		di_ack  => di_tx_ack,
		di_data => di_tx_data_int
	);

	rx_inst : rx
	port map (
		res_n   => res_n,
		bd_req  => bd_rx_req,
		bd_ack  => bd_rx_ack,
		bd_data => bd_rx_data,
		di_ack  => di_rx_ack,
		di_data => di_rx_data
	);
	
	--debouncer for the switch
	debounce_inst : debounce
	generic map (
		COUNTER_SIZE => 19,
		SYNC_STAGES  => 2
	)
	port map (
		clk      => clk,
		res_n    => res_n,
		data_in  => bd_tx_en,
		data_out => bd_tx_en_sync
	);
	
	-- here you can try out different settings
	-- your circuit should work with arbitrary delay values 
	vector_delay_inst : vector_delay
	generic map (
		NUM_LCELLS => (64,32,16,8,4,2,64,32,16,8,4,2,64,32,16,8) 
	)
	port map (
		i => di_tx_data_int,
		o => di_tx_data
	);
	

end architecture;





