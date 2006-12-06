-- File: rlu.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-11-29
-- Last updated: 2006-11-29

-- Description:
-- Register Lock Unit (Provides flags for locking access to registers).
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.RISE_PACK.all;


entity rlu is
  
  port (
    clk                 : in std_logic;
    reset               : in std_logic;

    lock_register       : out LOCK_REGISTER_T;

    clear_reg_lock      : in std_logic;
    set_reg_lock        : in std_logic;
    reg_addr            : in REGISTER_ADDR_T);

end rlu;


architecture rlu_rtl of rlu is

begin  -- rlu_rtl

  

end rlu_rtl;
