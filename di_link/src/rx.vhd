library ieee;
use ieee.std_logic_1164.all;

use work.workcraft_pkg.all;

entity rx is 
	port (
		res_n : in std_logic;  -- '1' inactive and '0' active reset
		
		-- bundled data
		bd_req : out std_logic;
		bd_ack : in std_logic;
		bd_data : out std_logic_vector(7 downto 0);
		
		-- delay insensitive 
		di_ack : out std_logic;
		di_data : in std_logic_vector(15 downto 0)
	);
end entity;


architecture arch of rx is 
signal CD_1,CD_2,CD_3,CD_4,CD_A : std_logic;
signal res_neg					:std_logic;
begin

---------DECODER--------------------

DEC_Bit15to12:entity work.Decoder
port map(
	reset=>res_neg,
	data_in => di_data(15 downto 12),
	data_out=> bd_data(7 downto 6)
);

DEC_Bit11to8:entity work.Decoder
port map(
	reset=>res_neg,
	data_in => di_data(11 downto 8),
	data_out=> bd_data(5 downto 4)
);

DEC_Bit7to4:entity work.Decoder
port map(
	reset=>res_neg,
	data_in => di_data(7 downto 4),
	data_out=> bd_data(3 downto 2)
);

DEC_Bit3to0:entity work.Decoder
port map(
	reset=>res_neg,
	data_in => di_data(3 downto 0),
	data_out=> bd_data(1 downto 0)
);

---------COMPLETION DETECTION----
CD_Bit15to12: entity work.CD
port map(
	reset=>res_neg,
	input=>di_data(15 downto 12),
	valid=>CD_1
);

CD_Bit11to8: entity work.CD
port map(
	reset=>res_neg,
	input=>di_data(11 downto 8),
	valid=>CD_2
);

CD_Bit7to4: entity work.CD
port map(
	reset=>res_neg,
	input=>di_data(7 downto 4),
	valid=>CD_3
);

CD_Bit3to0: entity work.CD
port map(
	reset=>res_neg,
	input=>di_data(3 downto 0),
	valid=>CD_4
);


---------COMBINATIONAL------------
res_neg<=not res_n;
di_ack<=bd_ack;
CD_A <= (CD_1 or CD_2 or CD_3 or CD_2) and res_n;


-------PROCESS-----------------

bd_req <= '1' when CD_A = '1' else '0';

end architecture;

