-- File: mem_stage.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-11-29
-- Last updated: 2006-11-29

-- Description:
-- Memory Access stage
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.RISE_PACK.all;
use work.RISE_PACK_SPECIFIC.all;

entity mem_stage is
  
  port (
    clk   : in std_logic;
    reset : in std_logic;

    ex_mem_register : in  EX_MEM_REGISTER_T;
    mem_wb_register : out MEM_WB_REGISTER_T;

    dmem_addr      : out MEM_ADDR_T;
    dmem_data_in   : in  MEM_DATA_T;
    dmem_data_out  : out MEM_DATA_T;
    dmem_wr_enable : out std_logic;

    stall_out : out std_logic;
    clear_in  : in  std_logic;
    clear_out : out std_logic);


end mem_stage;

architecture mem_stage_rtl of mem_stage is

  signal mem_wb_register_int  : MEM_WB_REGISTER_T;
  signal mem_wb_register_next : MEM_WB_REGISTER_T;


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

begin  -- mem_stage_rtl
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
      ADDRESS => address(1 downto 0),
      WR_DATA => wr_data,
      RD      => rd,
      WR      => wr,
      RD_DATA => rd_data,
      RDY_CNT => rdy_cnt,
      TXD     => txd,
      RXD     => rxd,
      NCTS    => '0',
      NRTS    => open
      );

  mem_wb_register.aluop1    <= mem_wb_register_int.aluop1;
  mem_wb_register.aluop2    <= mem_wb_register_int.aluop2;
  mem_wb_register.reg       <= mem_wb_register_int.reg;
  mem_wb_register.mem_reg   <= dmem_data_in;
  mem_wb_register.dreg_addr <= mem_wb_register_int.dreg_addr;
  mem_wb_register.lr        <= mem_wb_register_int.lr;
  mem_wb_register.sr        <= mem_wb_register_int.sr;

  clear_out <= '0';  -- clear_out output is unused at the moment.
  stall_out <= '0';                     -- development (temporarily)
  process (clk, reset)
  begin  -- process
    if reset = '0' then                 -- asynchronous reset (active low)
      mem_wb_register_int.aluop1    <= (others => '0');
      mem_wb_register_int.aluop2    <= (others => '0');
      mem_wb_register_int.reg       <= (others => '0');
      mem_wb_register_int.dreg_addr <= (others => '0');
      mem_wb_register_int.lr        <= (others => '0');
      mem_wb_register_int.sr        <= (others => '0');

--		uart reset
		rd 		<= '0';
		wr 		<= '0';
      wr_data        <= (others => 'X');
		rd_data        <= (others => '0');
	   address			<= (others => 'X');
		
    elsif clk'event and clk = '1' then  -- rising clock edge
      mem_wb_register_int <= mem_wb_register_next;
    end if;
  end process;

  process( reset, ex_mem_register, dmem_data_in )
  begin
    dmem_addr      <= (others => 'X');
    dmem_data_out  <= (others => 'X');
    dmem_wr_enable <= '0';

    if reset = '0' then
      mem_wb_register_next.aluop1    <= (others => '0');
      mem_wb_register_next.aluop2    <= (others => '0');
      mem_wb_register_next.reg       <= (others => '-');
      mem_wb_register_next.mem_reg   <= (others => '-');
      mem_wb_register_next.dreg_addr <= (others => '-');
      mem_wb_register_next.lr        <= (others => '-');
      mem_wb_register_next.sr        <= (others => '-');
    else
      -- check if the instruction accesses the memory. if yes then
      -- either load or store data from the memory.
      assert ex_mem_register.aluop1(ALUOP1_LD_MEM_BIT) = '0' or ex_mem_register.aluop1(ALUOP1_ST_MEM_BIT) = '0';
--load from mem
      if ex_mem_register.aluop1(ALUOP1_LD_MEM_BIT) = '1' then
        if ex_mem_register.alu = CONST_ADDRESS then
		    --load from UART
				address <= CONDT_ADDRESS;
				rd ='1';
				
				if rd_data = '0' then 
				  stall_out <= '1';
				else 
				  stall_out <= '0';
				  dmem_addr <= rd_data;
				end if;

	     else
		    dmem_addr <= ex_mem_register.alu;
		  end if;
		end if;
-- store in mem
      if ex_mem_register.aluop1(ALUOP1_ST_MEM_BIT) = '1' then
        if ex_mem_register.alu = CONST_ADDRESS then
		  --write to Uart
		    if sc_uart.rf_full = '1' then
			   --stall
				stall_out <= '1';
			 else
				stall_out <= '0';
			   address 	 <= ex_mem_register.alu;
				wr_data	 <= ex_mem_register.reg;
				wr 		 <= '1';
			 
			 end if;
		  else
		    dmem_addr      <= ex_mem_register.alu;
          dmem_data_out  <= ex_mem_register.reg;
          dmem_wr_enable <= '1';
		  end if;
		end if;

      -- other values are pass through
      mem_wb_register_next.aluop1    <= ex_mem_register.aluop1;
      mem_wb_register_next.aluop2    <= ex_mem_register.aluop2;
      mem_wb_register_next.reg       <= ex_mem_register.alu;
      mem_wb_register_next.dreg_addr <= ex_mem_register.dreg_addr;
      mem_wb_register_next.lr        <= ex_mem_register.lr;
      mem_wb_register_next.sr        <= ex_mem_register.sr;
    end if;
  end process;
  
end mem_stage_rtl;
