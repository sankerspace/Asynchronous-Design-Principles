library ieee;
use ieee.std_logic_1164.all;
use work.serial_port_pkg.all;
use work.testbench_util_pkg.all;

entity serial_port_tb is
end serial_port_tb;

architecture sim of serial_port_tb is
  constant CLK_PERIODE : time := 10 ns;
  constant CLK_FREQ : integer := 100000000;
  constant BAUD_RATE : integer := 115200;
  
  signal clk, nres : std_logic;
  signal data_in : std_logic_vector(7 downto 0);
  signal wr, free, finished : std_logic;
  signal data_out : std_logic_vector(7 downto 0);
  signal new_data : std_logic;
  signal rx, tx : std_logic;
begin
  serial_port0 : serial_port
    generic map(CLK_FREQ / BAUD_RATE)
    port map(clk, nres, data_in, wr, free, finished, data_out, new_data, rx, tx);
  
  rx <= tx;
  
  process
  begin
    clk <= '0';
    wait for CLK_PERIODE / 2;
    clk <= '1';
    wait for CLK_PERIODE / 2;
  end process;
  
  process
  begin
    nres <= '0';
    wait_cycle(clk, 10);
    nres <= '1';   
    data_in <= x"55";
    wr <= '1';
    wait_cycle(clk, 1);
    wr <= '0';
    wait until free = '1';
    data_in <= x"AA";
    wr <= '1';
    wait_cycle(clk, 1);
    wr <= '0';
    wait until free = '1';
    data_in <= x"00";
    wr <= '1';
    wait_cycle(clk, 1);
    wr <= '0';
    wait until finished = '1';
    data_in <= x"FF";
    wr <= '1';
    wait_cycle(clk, 1);
    wr <= '0';
    wait until finished = '1';
    simulation_finished;
  end process;
  
end sim;
