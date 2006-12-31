-- File: rlu.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-11-29
-- Last updated: 2006-11-29

-- Description:
-- Register Lock Unit (Provides flags for locking access to registers).
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
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

  signal lock_register_int      : LOCK_REGISTER_T;
  signal lock_register_next     : LOCK_REGISTER_T;
  
begin  -- rlu_rtl

  lock_register <= lock_register_int;
  
  sync: process (clk, reset)
  begin  -- process
    if reset = '0' then                 -- asynchronous reset (active low)
      lock_register_int <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      lock_register_int <= lock_register_next;
    end if;
  end process;

  async: process (lock_register_int, clear_reg_lock, set_reg_lock, reg_addr)
  begin  -- process async
    lock_register_next <= lock_register_int;

    if clear_reg_lock = '1' and set_reg_lock = '0' then
      lock_register_next(to_integer(unsigned(reg_addr))) <= '0';     
    end if;
    if set_reg_lock = '1' and clear_reg_lock = '0' then
      lock_register_next(to_integer(unsigned(reg_addr))) <= '1';     
    end if;
      
  end process async;

end rlu_rtl;
