library ieee;
use ieee.std_logic_1164.all;

entity sync is
  generic
  (
    SYNC_STAGES : integer ;--range 2 to integer'high;
    RESET_VALUE : std_logic
  );
  port
  (
    clk   : in std_logic;
    res_n : in std_logic;
    
    data_in   : in std_logic;
    data_out  : out std_logic
  );
end entity sync;

architecture beh of sync is
  signal sync : std_logic_vector(1 to SYNC_STAGES);
  attribute KEEP : string;
  attribute KEEP of sync : signal is "TRUE";
begin
  sync_proc : process(clk, res_n)
  begin
    if res_n = '0' then
      sync <= (others => RESET_VALUE);
    elsif rising_edge(clk) then
      sync(1) <= data_in;
      for i in 2 to SYNC_STAGES loop
        sync(i) <= sync(i - 1);
      end loop;      
    end if;
  end process sync_proc;
  data_out <= sync(SYNC_STAGES);
end architecture beh;
