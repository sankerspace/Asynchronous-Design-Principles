library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------
----------Encode Bundled Data to 1of4 OneHot Code ------------
----encoding 2 bit bundled data to 4bit 1of4 Many Rail data---
  ------------------------------------------------------------	
entity Encoder is
	port (
		reset	  :  in std_logic; --reset on 1
		data_in :  in std_logic_vector(1 downto 0);
		data_out : out std_logic_vector(3 downto 0)
	);
end entity;



architecture Encoder_behave of Encoder is
-- number of 1-of-4 Codes


begin

	data_out(3)<=		data_in(1)	and 		data_in(0)  and not reset; --MSB
	data_out(2)<=		data_in(1)	and not	data_in(0)	and not reset;
	data_out(1)<=not  data_in(1) 	and 		data_in(0)	and not reset;
	data_out(0)<=not  data_in(1) 	and not  data_in(0)	and not reset;	--LSB

end architecture Encoder_behave;