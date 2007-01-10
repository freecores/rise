
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
    clk            : in std_logic;
    reset          : in std_logic;

    wr_enable		 : in std_logic;
    addr           : in MEM_ADDR_T;
    data_in        : in MEM_DATA_T;
    data_out       : out MEM_DATA_T);

end dmem;

architecture dmem_rtl of dmem is

component idmem
	port (
	addr: IN std_logic_VECTOR(11 downto 0);
	clk: IN std_logic;
	din: IN std_logic_VECTOR(15 downto 0);
	dout: OUT std_logic_VECTOR(15 downto 0);
	sinit: IN std_logic;
	we: IN std_logic);
end component;

begin  -- dmem_rtl

DATA_MEM : idmem
	port map (
	addr => addr(11 downto 0),
	clk => clk,
	din => data_in,
	dout => data_out,
	sinit => reset,
	we => wr_enable);
  

end dmem_rtl;








