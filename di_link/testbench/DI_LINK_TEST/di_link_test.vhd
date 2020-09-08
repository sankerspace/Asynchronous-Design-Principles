
library ieee;
use ieee.std_logic_1164.all;

--use work.uart2bd_pkg.all;
use work.di_txrx_pkg.all;
--use work.debounce_pkg.all;
use work.delay_element_pkg.all;


entity test_di_link is
	--generic (
		--CLK_FREQ : integer := 50000000;
		--BAUD_RATE : integer := 9600;
		--BD_SYNC_STAGES : integer := 2;
		--UART_SYNC_STAGES : integer := 2
	--);
	--port (
		--clk : in std_logic;
		--res_n : in std_logic;
		
		--uart interface
		--uart_rx : in std_logic;
		--uart_tx : out std_logic;
		
		--DI (dual rail) interface
		--di_tx_ack : in std_logic;  -- from ribbon cable back to Tx
		--di_rx_ack : out std_logic; --also over ribbon cabble
		--di_tx_data : out std_logic_vector(15 downto 0); --OUT TO RIBBON CABLE
		--di_rx_data : in std_logic_vector(15 downto 0);  -- INPUT FROM RIBBON CABLE
		
		--clk_out	: out std_logic;
		--res_n_out: out std_logic;
		--data_out : out std_logic_vector(7 downto 0)
		
		-- MIDDLE CONNECTOR OF RIBBON CABLE ATTACHED TO LOGIC ANALYZER 
		-- additional control 
		--bd_tx_en : in std_logic
		
	--);
end entity;

architecture test_di_link_beh of test_di_link is 




	constant clk_period : time := 20 ns; -- 50Mhz

	SIGNAL clk   : std_logic := '0';
	SIGNAL res_n : std_logic := '0';

	signal tx_req : std_logic;
	signal tx_ack : std_logic;
	signal tx_data : std_logic_vector(7 downto 0);
	
	signal rx_req : std_logic;
	signal rx_ack : std_logic;
	signal rx_data : std_logic_vector(7 downto 0);
	
	--signal res : std_logic;
	--signal bd_tx_en_sync : std_logic;
	
	signal di_tx_data_int : std_logic_vector(15 downto 0);
	
	COMPONENT src
	 port (
    	clk     : in  std_logic;
    	reset_n : in  std_logic;
    	data    : out std_logic_vector(7 downto 0);
	 	ack     : in std_logic;
    	req     : out std_logic
    );
	END COMPONENT;

	COMPONENT dst
  	port (
    	clk      : in  std_logic;
    	reset_n  : in  std_logic;
    	data     : in  std_logic_vector(7 downto 0);
    	req      : in  std_logic;
	 	ack     : out std_logic;
    	data_out : out std_logic_vector(7 downto 0)
    );
	END COMPONENT;

	TYPE State_type IS (INIT,ENABLE);  -- Define the states
	SIGNAL State : State_Type := INIT ;
	SIGNAL di_tx_ack :  std_logic;  -- input from ribbon cable back to Tx
	SIGNAL di_rx_ack :  std_logic; --also OUT over ribbon cabble
	SIGNAL di_tx_data : std_logic_vector(15 downto 0); --OUT TO RIBBON CABLE
	SIGNAL di_rx_data : std_logic_vector(15 downto 0);  -- INPUT FROM RIBBON CABLE
	SIGNAL data_out :   std_logic_vector(7 downto 0);

begin
	
	di_tx_ack<=di_rx_ack;
	di_rx_data<=di_tx_data;
------- CLOCKS--------------------

clock : PROCESS
   begin
   wait for clk_period/2; clk  <= not clk;
end PROCESS clock;


stimulus: process
begin
	case State is 
		when INIT=>
			wait for 2ns;
			res_n<='0';
			State<=ENABLE;
		
		when ENABLE=>
			wait for 2ns;
			res_n<='1';
			
	end case;	
end process stimulus;



	
	--clk_out<=clk;
	--res_n_out<=res_n;
	
	source_data: src
	port map (
		clk=>clk,
		reset_n=>res_n,
		data=>tx_data,
		ack=>tx_ack,
		req=>tx_req
	);
	
	sink_data: dst
	port map (
		clk=>clk,
		reset_n=>res_n,
		data=>rx_data,
		ack=>rx_ack,
		req=>rx_req,
		data_out=>data_out
	);
	

	tx_inst : tx
	port map (
		res_n   => res_n,
		bd_req  => tx_req,
		bd_ack  => tx_ack,
		bd_data => tx_data,
		di_ack  => di_tx_ack,
		di_data => di_tx_data_int
	);

	rx_inst : rx
	port map (
		res_n   => res_n,
		bd_req  => rx_req,
		bd_ack  => rx_ack,
		bd_data => rx_data,
		di_ack  => di_rx_ack,
		di_data => di_rx_data
	);
	
	--debouncer for the switch
	--debounce_inst : debounce
	--generic map (
	--	COUNTER_SIZE => 19,
	--	SYNC_STAGES  => 2
	--)
	--port map (
	--	clk      => clk,
	--	res_n    => res_n,
	--	data_in  => bd_tx_en,
	--	data_out => bd_tx_en_sync
	--);
	
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
	

end architecture test_di_link_beh;





