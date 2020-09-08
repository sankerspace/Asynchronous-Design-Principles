
library ieee;
use ieee.std_logic_1164.all;

use work.delay_element_pkg.all;

entity tx is 
	port (
		res_n : in std_logic; -- '1' inactive and '0' active reset
		
		-- bundled data
		bd_req : in std_logic;					------MUST BE DELAYED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		bd_ack : out std_logic;					
		bd_data : in std_logic_vector(7 downto 0);
		
		-- delay insensitive 
		di_ack : in std_logic;
		di_data : out std_logic_vector(15 downto 0)
	);
end entity;

architecture arch of tx is 
signal data : std_logic_vector(15 downto 0);
signal en,ack_out,req	: std_logic;
signal res_neg				:std_logic;
component tx_controller is
	port(
		reset	 :in std_logic;
		ack_in :in std_logic;
		req	 :in std_logic;
		ack_out:out std_logic; 
		en		 :out std_logic
	);
end component;

begin
-------ENCODER----------------
ENC_Bit7a6:entity work.Encoder
port map(
	reset	  => res_neg,
	data_in => bd_data(7 downto 6),
	data_out=> data(15 downto 12)
);

ENC_Bit5a4:entity work.Encoder
port map(
	reset	  => res_neg,
	data_in => bd_data(5 downto 4),
	data_out=> data(11 downto 8)
);

ENC_Bit3a2:entity work.Encoder
port map(
	reset	  => res_neg,
	data_in => bd_data(3 downto 2),
	data_out=> data(7 downto 4)
);

ENC_Bit1a0:entity work.Encoder
port map(
	reset	  => res_neg,
	data_in => bd_data(1 downto 0),
	data_out=> data(3 downto 0)
);

----------DI_LINES------------------
di_data_lines : for i in 15 downto 0 generate
begin
di_data(i) <= data(i) and en;
end generate di_data_lines;

----------CONTROLLER----------------
controller:tx_controller
port map(
	reset=>res_neg,
	ack_in=>di_ack, 
	req=>req, 
	ack_out=>ack_out, 
	en=>en
);
---------DELAYS-------------------

delay_req: delay_element
	generic map(
		NUM_LCELLS=>10     ----- check delay-!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	)
	port map(
		i=>bd_req,
		o=>req
	);

	
--delay_ack: delay_element
--	generic map(
--		NUM_LCELLS=>10     
--	)
--	port map(
--		i=>ack_out,
--		o=>bd_ack
--	);
	
--req<=bd_req;
bd_ack<=ack_out;	
res_neg <= not res_n;
end architecture;

	



