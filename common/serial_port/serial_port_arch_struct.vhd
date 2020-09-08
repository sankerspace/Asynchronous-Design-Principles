----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  21.09.2010                                                     --
-- Design Name:  DIDELU                                                         --
-- Module Name:  serial_port_struct                                             --
-- Project Name: DIDELU                                                         --
-- Description:  Serial - Architecture                                          --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.serial_port_pkg.all;
use work.ram_pkg.all;
use work.sync_pkg.all;

----------------------------------------------------------------------------------
--                               ARCHITECTURE                                   --
----------------------------------------------------------------------------------

architecture struct of serial_port is
  signal rx_sync : std_logic;
  signal tx_fifo_full, tx_fifo_empty, tx_fifo_rd : std_logic;
  signal tx_fifo_data : std_logic_vector(7 downto 0);
  signal rx_fifo_wr : std_logic;
  signal rx_fifo_data : std_logic_vector(7 downto 0);
begin

  -- receiver instance
  receiver_inst : serial_port_receiver
    generic map
    (
      CLK_DIVISOR => CLK_FREQ / BAUD_RATE
    )
    port map
    (
      clk       => clk,
      res_n     => res_n,
      data      => rx_fifo_data,
      data_new  => rx_fifo_wr,
      rx        => rx_sync
    );
  
  -- transmitter instance
  transmitter_inst : serial_port_transmitter
    generic map
    (
      CLK_DIVISOR => CLK_FREQ / BAUD_RATE
    )
    port map
    (
      clk       => clk,
      res_n     => res_n,
      data      => tx_fifo_data,
      empty     => tx_fifo_empty,
      rd        => tx_fifo_rd,
      tx        => tx
    );

  -- tx fifo
  tx_fifo_inst : fifo_1c1r1w
    generic map
    (
      MIN_DEPTH => TX_FIFO_DEPTH,
      DATA_WIDTH => 8
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      data_in2 => tx_data,
      wr2 => tx_wr,
      rd1 => tx_fifo_rd,
      data_out1 => tx_fifo_data,
      empty => tx_fifo_empty,
      full => tx_fifo_full
    );
  tx_free <= not tx_fifo_full;

  -- rx synchronizer
  sync_inst : sync
    generic map
    (
      SYNC_STAGES => SYNC_STAGES,
      RESET_VALUE => '1'
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      data_in => rx,
      data_out => rx_sync
    );

  -- rx fifo
  rx_fifo_inst : fifo_1c1r1w
    generic map
    (
      MIN_DEPTH => RX_FIFO_DEPTH,
      DATA_WIDTH => 8
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      data_in2 => rx_fifo_data,
      wr2 => rx_fifo_wr,
      rd1 => rx_rd,
      data_out1 => rx_data,
      empty => rx_data_empty,
      full => rx_data_full
    );
end architecture struct;

--- EOF ---