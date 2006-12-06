-- File: ex_stage.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-11-29
-- Last updated: 2006-11-29

-- Description:
-- Execute stage
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.RISE_PACK.all;


entity ex_stage is
  
  port (
    clk                 : in std_logic;
    reset               : in std_logic;

    id_ex_register      : in ID_EX_REGISTER_T;
    ex_mem_register     : out EX_MEM_REGISTER_T;

    branch              : out std_logic;
    stall_in            : in std_logic;
    clear_in            : in std_logic;
    clear_out           : out std_logic);

end ex_stage;

architecture ex_stage_rtl of ex_stage is
  
  signal ex_mem_register_int     : EX_MEM_REGISTER_T;
  signal ex_mem_register_next    : EX_MEM_REGISTER_T;
  
begin  -- ex_stage_rtl

--  ex_mem_register        <= ex_mem_register_int;
  
--  process (clk, reset)
--  begin  -- process
--    if reset = '0' then                 -- asynchronous reset (active low)
--      ex_mem_register_int        <= (others => (others => '0'));
--      ex_mem_register_next       <= (others => (others => '0'));
--    elsif clk'event and clk = '1' then  -- rising clock edge
--      ex_mem_register_int        <= ex_mem_register_next;
--    end if;
--  end process;  

end ex_stage_rtl;
