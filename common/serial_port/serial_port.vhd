----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  21.09.2010                                                     --
-- Design Name:  DIDELU                                                         --
-- Module Name:  serial_port                                                    --
-- Project Name: DIDELU                                                         --
-- Description:  Serial - Entity                                                --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------------------
--                                 ENTITY                                       --
----------------------------------------------------------------------------------

-- structural description of serial port - connects transmitter and receiver
entity serial_port is
  generic
  (
    -- clock frequency [Hz]
    CLK_FREQ : integer;
    -- transmission baud rate
    BAUD_RATE : integer;
    -- number of stages in the input synchronizer
    SYNC_STAGES : integer;
    -- depth of the tx fifo
    TX_FIFO_DEPTH : integer;
    -- depth of the rx fifo
    RX_FIFO_DEPTH : integer
  );
  port
  (
    clk, res_n         : in  std_logic;

    tx_data            : in  std_logic_vector(7 downto 0);
    tx_wr              : in  std_logic;
    tx_free            : out std_logic;
        
    rx_data            : out std_logic_vector(7 downto 0);
    rx_rd              : in  std_logic;
    rx_data_empty      : out std_logic;
    rx_data_full       : out std_logic;

    rx                 : in  std_logic;
    tx                 : out std_logic
  );
end entity serial_port;

--- EOF ---

