-- File: dmem.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-11-29
-- Last updated: 2006-11-29

-- Description:
-- Entity for accessing data memory.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.RISE_PACK.all;


entity dmem is
  
  port (
    clk   : in std_logic;
    reset : in std_logic;

    wr_enable : in  std_logic;
    addr      : in  MEM_ADDR_T;
    data_in   : in  MEM_DATA_T;
    data_out  : out MEM_DATA_T;
	 uart_txd : out std_logic;
	 uart_rxd : in std_logic);

end dmem;

architecture dmem_rtl of dmem is

  component idmem
    port (
      addr  : in  std_logic_vector(11 downto 0);
      clk   : in  std_logic;
      din   : in  std_logic_vector(15 downto 0);
      dout  : out std_logic_vector(15 downto 0);
      sinit : in  std_logic;
      we    : in  std_logic);
  end component;
   component sc_uart is
      generic (ADDR_BITS : integer;
               CLK_FREQ  : integer;
               BAUD_RATE : integer;
               TXF_DEPTH : integer;
               TXF_THRES : integer;
               RXF_DEPTH : integer;
               RXF_THRES : integer);
      port (CLK     : in  std_logic;
            RESET   : in  std_logic;
            ADDRESS : in  std_logic_vector(addr_bits-1 downto 0);
            WR_DATA : in  std_logic_vector(15 downto 0);
            RD, WR  : in  std_logic;
            RD_DATA : out std_logic_vector(15 downto 0);
            RDY_CNT : out IEEE.NUMERIC_STD.unsigned(1 downto 0);
            TXD     : out std_logic;
            RXD     : in  std_logic;
            NCTS    : in  std_logic;
            NRTS    : out std_logic);
    end component;


     signal uart_address(1 downto 0): std_logic_vector(1 downto 0);
      signal uart_wr_data :std_logic_vector(15 downto 0);
      signal uart_rd : std_logic;
      signal uart_wr : std_logic;
      signal uart_rd_data: std_logic_vector(15 downto 0);

      signal uart_txd_sig : std_logic;
      signal uart_rxd_sig : std_logic;
		
		signal mem_addr : std_logic_vector (11 downto 0);
		signal mem_data_in :MEM_DATA_T;
      signal mem_data_out :MEM_DATA_T;
      signal mem_wr_enable:  std_logic;
begin  -- dmem_rtl

  -- Uart modul einbinden
  UART : sc_uart generic map (
    ADDR_BITS => 2,
    CLK_FREQ  => CLK_FREQ,
    BAUD_RATE => 115200,
    TXF_DEPTH => 2,
    TXF_THRES => 1,
    RXF_DEPTH => 2,
    RXF_THRES => 1
    )
	 port map(
      CLK     => clk,
      RESET   => reset,
      ADDRESS => uart_address(1 downto 0),
      WR_DATA => uart_wr_data,
      RD      => uart_rd,
      WR      => uart_wr,
      RD_DATA => uart_rd_data,
      RDY_CNT => open,
      TXD     => uart_txd_sig,
      RXD     => uart_rxd_sig,
      NCTS    => '0',
      NRTS    => open
      );

  DATA_MEM : idmem
    port map (
      addr  => mem_addr,
      clk   => clk,
      din   => mem_data_in,
      dout  => mem_data_out,
      sinit => reset,
      we    => mem_wr_enable);


uart_txd <= uart_txd_sig;
uart_rxd <= uart_rxd_sig;

process (wr_enable, addr, data_in, uart_rd_data, mem_data_out)
begin



-- accessing extension modules
if addr = CONST_UART_STATUS_ADDRESS 
	or addr = CONST_UART_DATA_ADDRESS then
	uart_address <= addr (1 downto 0);
	if wr_enable = '1' then
		uart_wr <= '1';
		uart_wr_data <= data_in;
	else
		uart_rd <= '1';
		data_out <= uart_rd_data;		
	end if;	
else
	-- accessing data memory
	mem_addr <= addr(11 downto 0);
	data_out <= mem_data_out;
	mem_data_in <= data_in;
	mem_wr_enable <= wr_enable;
end if;

end process

end dmem_rtl;








