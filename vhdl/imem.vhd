-- File: imem.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-11-29
-- Last updated: 2006-11-29

-- Description:
-- Entity for accessing instruction memory.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.RISE_PACK.all;


entity imem is
  
  port (
    clk            : in std_logic;
    reset          : in std_logic;

    addr           : in MEM_ADDR_T;
    data_in        : in MEM_DATA_T;
    data_out       : out MEM_DATA_T);

end imem;

architecture imem_rtl of imem is

begin  -- imem_rtl

  

end imem_rtl;
