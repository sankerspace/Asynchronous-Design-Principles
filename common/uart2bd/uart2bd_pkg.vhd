library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package uart2bd_pkg is
	component uart2bd is
		generic (
			CLK_FREQ : integer := 50000000;
			BAUD_RATE : integer := 9600;
			BD_SYNC_STAGES : integer := 2;
			UART_SYNC_STAGES : integer := 2
		);
		port (
			clk : in std_logic;
			res_n : in std_logic;
			uart_rx : in std_logic;
			uart_tx : out std_logic;
			bd_tx_en : in std_logic;
			bd_tx_req : out std_logic;
			bd_tx_ack : in std_logic;
			bd_rx_req : in std_logic;
			bd_rx_ack : out std_logic;
			bd_tx_data : out std_logic_vector(7 downto 0);
			bd_rx_data : in std_logic_vector(7 downto 0)
		);
	end component;
end package;

