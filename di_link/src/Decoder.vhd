library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------
	---------- Decode 1of4 OneHot Code to Bundled Data-----------
   ---------- 0001=00 0010=01 0100=10 1000=11       ------------
	---------4 bits decoded to its oroginal 2bit representation--
   ------------------------------------------------------------	
	
entity Decoder is
	port (
		reset	  :  in std_logic; --reset on 1
		data_in  : in  std_logic_vector(3 downto 0);
		data_out : out  std_logic_vector(1 downto 0)
	);
end entity;


architecture Decoder_behave of Decoder is

begin

	data_out(1)<= (data_in(3)	or	data_in(2)) and not reset;	--MSB
	data_out(0)<= (data_in(3)	or	data_in(1)) and not reset; --LSB


end architecture Decoder_behave;