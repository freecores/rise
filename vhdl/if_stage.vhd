-- File: if_stage.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-11-29
-- Last updated: 2006-11-29

-- Description:
-- Instruction fetch stage
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.RISE_PACK.all;


entity if_stage is
  
  port (
    clk            : in std_logic;
    reset          : in std_logic;

    if_id_register : out IF_ID_REGISTER_T;

    branch         : in std_logic;
    branch_target  : in PC_REGISTER_T;
    clear_in       : in std_logic;
    stall_in       : in std_logic;

    pc             : in PC_REGISTER_T;
    pc_next        : out PC_REGISTER_T;

    imem_addr      : out MEM_ADDR_T;
    imem_data      : in MEM_DATA_T);


end if_stage;

architecture if_stage_rtl of if_stage is

  signal if_id_register_int     : IF_ID_REGISTER_T;
  signal if_id_register_next    : IF_ID_REGISTER_T;
  
begin  -- if_stage_rtl

--  if_id_register        <= if_id_register_int;
  
--  process (clk, reset)
--  begin  -- process
--    if reset = '0' then                 -- asynchronous reset (active low)
--      if_id_register_int        <= (others => (others => '0'));
--      if_id_register_next       <= (others => (others => '0'));
--    elsif clk'event and clk = '1' then  -- rising clock edge
--      if_id_register_int        <= if_id_register_next;
--    end if;
--  end process;

end if_stage_rtl;
