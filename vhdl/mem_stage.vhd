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


entity mem_stage is
  
  port (
    clk                 : in std_logic;
    reset               : in std_logic;

    ex_mem_register     : in EX_MEM_REGISTER_T;
    mem_wb_register     : out MEM_WB_REGISTER_T;

    dmem_addr           : out MEM_ADDR_T;
    dmem_data_in        : in MEM_DATA_T;
    dmem_data_out       : out MEM_DATA_T;

    stall_out           : out std_logic;
    clear_in            : in std_logic;
    clear_out           : out std_logic);


end mem_stage;

architecture mem_stage_rtl of mem_stage is

  signal mem_wb_register_int     : MEM_WB_REGISTER_T;
  signal mem_wb_register_next    : MEM_WB_REGISTER_T;
   
begin  -- mem_stage_rtl

--  mem_wb_register        <= mem_wb_register_int;
  
--  process (clk, reset)
--  begin  -- process
--    if reset = '0' then                 -- asynchronous reset (active low)
--      mem_wb_register_int        <= (others => (others => '0'));
--      mem_wb_register_next       <= (others => (others => '0'));
--    elsif clk'event and clk = '1' then  -- rising clock edge
--      mem_wb_register_int        <= mem_wb_register_next;
--    end if;
--  end process;
  
end mem_stage_rtl;
