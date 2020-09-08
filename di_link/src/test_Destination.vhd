library ieee;
use ieee.std_logic_1164.all;

entity dst is
  port (
    clk      : in  std_logic;
    reset_n  : in  std_logic; -- '1' inactive and '0' active reset
    data     : in  std_logic_vector(7 downto 0);
    req      : in  std_logic;
	ack     : out std_logic;
    data_out : out std_logic_vector(7 downto 0)
    );
end entity dst;



architecture dst_arch of dst is
  signal reset_sync : std_logic;
  signal datareg    : std_logic_vector(data'range);
  signal ackreg     : std_logic;
begin
  rst : process(clk, reset_n)
  begin
    if reset_n = '0' then
      reset_sync <= '0';
    elsif rising_edge(clk) then
      reset_sync <= '1' ;
    end if;
  end process rst;

  reg : process(clk, reset_sync)
  begin
    if reset_sync = '0' then
      	datareg <= (others => '0');
		ackreg	<= '0';
    elsif rising_edge(clk) then
		--4-Phase Handshake
		if req='1' and ackreg='0' then  
			datareg <= data;
		    ackreg  <= '1';
		elsif req='0' and ackreg='1' then
			ackreg  <= '0';
      	end if;
    end if;
  end process reg;

  data_out <= datareg;
  ack <= ackreg;
end architecture dst_arch;





