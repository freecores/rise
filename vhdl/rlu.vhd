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
    clk   : in std_logic;
    reset : in std_logic;

    lock_register : out LOCK_REGISTER_T;

    clear_reg_lock0 : in std_logic;
    set_reg_lock0   : in std_logic;
    reg_addr0       : in REGISTER_ADDR_T;

    clear_reg_lock1 : in std_logic;
    set_reg_lock1   : in std_logic;
    reg_addr1       : in REGISTER_ADDR_T);

end rlu;


architecture rlu_rtl of rlu is

  signal lock_register_int  : LOCK_REGISTER_T;
  signal lock_register_next : LOCK_REGISTER_T;
  
begin  -- rlu_rtl

  lock_register <= lock_register_int;

  sync : process (clk, reset)
  begin  -- process
    if reset = '0' then                 -- asynchronous reset (active low)
      lock_register_int <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      lock_register_int <= lock_register_next;
    end if;
  end process;

  async : process (lock_register_int,
                   clear_reg_lock0, set_reg_lock0, reg_addr0,
                   clear_reg_lock1, set_reg_lock1, reg_addr1)
  begin  -- process async
    lock_register_next <= lock_register_int;

    -- first unlock all possible registers and then lock them. because
    -- the last assignment counts this also works correct if reg_addr0
    -- and reg_addr1 are the same and one unlocks and one locks the
    -- register (correct behaviour is that the register is locked).
    if clear_reg_lock0 = '1' and set_reg_lock0 = '0' then
      lock_register_next(to_integer(unsigned(reg_addr0))) <= '0';
    end if;
    if clear_reg_lock1 = '1' and set_reg_lock1 = '0' then
      lock_register_next(to_integer(unsigned(reg_addr1))) <= '0';
    end if;
    if set_reg_lock0 = '1' and clear_reg_lock0 = '0' then
      lock_register_next(to_integer(unsigned(reg_addr0))) <= '1';
    end if;
    if set_reg_lock1 = '1' and clear_reg_lock1 = '0' then
      lock_register_next(to_integer(unsigned(reg_addr1))) <= '1';
    end if;
    
  end process async;

end rlu_rtl;
