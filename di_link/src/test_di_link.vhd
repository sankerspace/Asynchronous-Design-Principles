
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.uart2bd_pkg.all;
use work.di_txrx_pkg.all;
use work.debounce_pkg.all;
use work.delay_element_pkg.all;


entity test_di_link is
	--generic (
		--CLK_FREQ : integer := 50000000;
		--BAUD_RATE : integer := 9600;
		--BD_SYNC_STAGES : integer := 2;
		--UART_SYNC_STAGES : integer := 2
	--);
	port(
		clk : in std_logic;
		res_n : in std_logic;
		
		--uart interface
		--uart_rx : in std_logic;
		--uart_tx : out std_logic;
		
		--DI (dual rail) interface
		di_tx_ack : in std_logic;  -- from ribbon cable back to Tx
		di_rx_ack : out std_logic; --also over ribbon cabble
		di_tx_data : out std_logic_vector(15 downto 0); --OUT TO RIBBON CABLE
		di_rx_data : in std_logic_vector(15 downto 0);  -- INPUT FROM RIBBON CABLE
		
		clk_out	: out std_logic;
		res_n_out: out std_logic;
		data_out : out std_logic_vector(7 downto 0);
		
		-- MIDDLE CONNECTOR OF RIBBON CABLE ATTACHED TO LOGIC ANALYZER 
		-- additional control 
		SW : in std_logic_vector(10 downto 3);
		LEDR:  out std_logic_vector(10 downto 3)
		
	);
end entity;

architecture test_di_link_beh of test_di_link is 
--switch between two testcases 
-- (1) from Switches over source to sink and finally to the LEDS and 
-- (0) counter started in source sending to sink , showing results on data_out 
	constant testcase :integer:= 0; 
	
	signal tx_req : std_logic;
	signal tx_ack : std_logic;
	signal tx_data : std_logic_vector(7 downto 0);
	
	signal rx_req : std_logic;
	signal rx_ack : std_logic;
	signal rx_data : std_logic_vector(7 downto 0);
	
	--signal res : std_logic;
	--signal bd_tx_en_sync,bd_tx_en_sync_old : std_logic;
	
	signal SW_sync :	std_logic_vector(7 downto 0);
	signal di_tx_data_int : std_logic_vector(15 downto 0);
	signal dout		:	std_logic_vector(7 downto 0);
	signal logic   :	std_logic;
begin
	-------PROCESSES------------------
	--step:process(clk,res_n)
	--begin
	--	if (res_n='0') then
	--		bd_tx_en_sync_old<=bd_tx_en_sync;
	--	elsif rising_edge(clk) then
	--		if(bd_tx_en_sync)
	--	end if;	
	--end process step;
	
	
	
	
	--------COMBINATORIAL---------------
	clk_out<=clk;
	res_n_out<=res_n;
	
	LEDR(10 downto 3)<=dout when testcase = 1;
	
	data_out <= dout  when testcase=0;
	
	logic <='1' when testcase = 1 else '0';
	-------INSTANTATIONS-------------
	source_data: entity work.src
	port map (
		clk=>clk,
		reset_n=>res_n,
		input=>SW_sync,
		logic=>logic,
		bd_data=>tx_data,
		ack=>tx_ack,
		req=>tx_req
	);
	
	sink_data: entity work.dst
	port map (
		clk=>clk,
		reset_n=>res_n,
		data=>rx_data,
		ack=>rx_ack,
		req=>rx_req,
		data_out=>dout--LEDR(10 downto 3)
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
	
	--debouncer for the switces
	
	
	debounces_switches : for i in 10 downto 3 generate
	begin
		debounces : debounce
		generic map (
			COUNTER_SIZE => 19,
			SYNC_STAGES  => 2
		)
		port map (
			clk      => clk,
			res_n    => res_n,
			data_in  => SW(i),
			data_out => SW_sync(i-3)
		);
	end generate debounces_switches;
	

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





