-- File: id_stage.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-11-29
-- Last updated: 2006-11-29

-- Description:
-- Instruction decode stage
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.RISE_PACK.all;


entity id_stage is
  
  port (
    clk            : in std_logic;
    reset          : in std_logic;

    if_id_register : in IF_ID_REGISTER_T;
    id_ex_register : out ID_EX_REGISTER_T;

    rx_addr        : out REGISTER_ADDR_T;
    ry_addr        : out REGISTER_ADDR_T;
    rz_addr        : out REGISTER_ADDR_T;
    
    rx             : in REGISTER_T;
    ry             : in REGISTER_T;
    rz             : in REGISTER_T; 
    sr             : in SR_REGISTER_T;

    lock_register  : in LOCK_REGISTER_T;
    set_reg_lock   : out std_logic;
    lock_reg_addr  : out REGISTER_ADDR_T;

    stall_in       : in std_logic;
    stall_out      : out std_logic;
    clear_in       : in std_logic);


end id_stage;

architecture id_stage_rtl of id_stage is

  signal id_ex_register_int     : ID_EX_REGISTER_T;
  signal id_ex_register_next    : ID_EX_REGISTER_T;
  
begin  -- id_stage_rtl

--  id_ex_register        <= id_ex_register_int;
  
--  process (clk, reset)
--  begin  -- process
--    if reset = '0' then                 -- asynchronous reset (active low)
--      id_ex_register_int        <= (others => (others => '0'));
--      id_ex_register_next       <= (others => (others => '0'));
--    elsif clk'event and clk = '1' then  -- rising clock edge
--      id_ex_register_int        <= id_ex_register_next;
--    end if;
--  end process;  

end id_stage_rtl;
