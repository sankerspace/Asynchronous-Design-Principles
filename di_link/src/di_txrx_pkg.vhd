library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package di_txrx_pkg is
	component rx is
		port (
			res_n : in std_logic;
			bd_req : out std_logic;
			bd_ack : in std_logic;
			bd_data : out std_logic_vector(7 downto 0);
			di_ack : out std_logic;
			di_data : in std_logic_vector(15 downto 0)
		);
	end component;
	
	component tx is
		port (
			res_n : in std_logic;
			bd_req : in std_logic;
			bd_ack : out std_logic;
			bd_data : in std_logic_vector(7 downto 0);
			di_ack : in std_logic;
			di_data : out std_logic_vector(15 downto 0)
		);
	end component;
end package;

