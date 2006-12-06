-- File: wb_stage.vhd
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


entity wb_stage is
  
  port (
    clk                 : in std_logic;
    reset               : in std_logic;

    mem_wb_register     : in MEM_WB_REGISTER_T;
    
    dreg_addr           : out REGISTER_ADDR_T;
    dreg                : out REGISTER_T;
        
    lr                  : out PC_REGISTER_T; 
    sr                  : out SR_REGISTER_T;
    
    clear_out           : out std_logic;
    
    clear_reg_lock      : out std_logic);


end wb_stage;

architecture wb_stage_rtl of wb_stage is

begin  -- wb_stage_rtl

  

end wb_stage_rtl;
