-- File: register_file.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-11-29
-- Last updated: 2006-11-29

-- Description:
-- Entity implementing register file.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.RISE_PACK.all;


entity register_file is
  
  port (
    clk            : in std_logic;
    reset          : in std_logic;

    rx_addr        : in REGISTER_ADDR_T;
    ry_addr        : in REGISTER_ADDR_T;
    rz_addr        : in REGISTER_ADDR_T;
    dreg_addr      : in REGISTER_ADDR_T;
    
    dreg_write     : in REGISTER_T;
    rx_read        : out REGISTER_T;
    ry_read        : out REGISTER_T;
    rz_read        : out REGISTER_T;

    sr_write       : in SR_REGISTER_T;
    lr_write       : in PC_REGISTER_T;
    pc_write       : in PC_REGISTER_T;
    sr_read        : out SR_REGISTER_T;
    pc_read        : out PC_REGISTER_T);

end register_file;

architecture register_file_rtl of register_file is

begin  -- register_file_rtl

  

end register_file_rtl;
