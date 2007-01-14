-- File: if_stage.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-11-29
-- Last updated: 2006-11-29

-- Description:
-- Instruction fetch stage
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.STD_LOGIC_ARITH.all;
use IEEE.NUMERIC_STD.all;
use WORK.RISE_PACK.all;
use work.RISE_PACK_SPECIFIC.all;

entity if_stage is
  
  port (
    clk   : in std_logic;
    reset : in std_logic;

    if_id_register : out IF_ID_REGISTER_T;

    branch        : in std_logic;
    branch_target : in PC_REGISTER_T;
    clear_in      : in std_logic;
    stall_in      : in std_logic;

    pc      : in  PC_REGISTER_T;
    pc_next : out PC_REGISTER_T;

    imem_addr : out MEM_ADDR_T;
    imem_data : in  MEM_DATA_T);

end if_stage;
--
--architecture if_stage_rtl of if_stage is
--  signal if_id_register_int     : IF_ID_REGISTER_T;
--  signal if_id_register_next    : IF_ID_REGISTER_T;
--  
--begin  -- if_stage_rtl
--
----  if_id_register        <= if_id_register_int;
--  
----  process (clk, reset)
----  begin  -- process
----    if reset = '0' then                 -- asynchronous reset (active low)
----      if_id_register_int        <= (others => (others => '0'));
----      if_id_register_next       <= (others => (others => '0'));
----    elsif clk'event and clk = '1' then  -- rising clock edge
----      if_id_register_int        <= if_id_register_next;
----    end if;
----  end process;
--
--end if_stage_rtl;

-- This is a simple hardcoded IF unit for the  RISE processor. It does not
-- use the memory and contains a hardcoded programm.
architecture if_state_behavioral of if_stage is
  signal if_id_register_int  : IF_ID_REGISTER_T := ( others => ( others => '0' ) );
  signal if_id_register_next : IF_ID_REGISTER_T := ( others => ( others => '0' ) );
  
begin
  if_id_register <= if_id_register_int;

  process (clk, reset, clear_in)
  begin
    if reset = '0' or clear_in = '1' then
      if_id_register_int.pc <= PC_RESET_VECTOR;
      if_id_register_int.ir <= (others => '0');
    elsif clk'event and clk = '1' then
      if stall_in = '0' then
        if_id_register_int <= if_id_register_next;
      end if;
    end if;
  end process;

  process (reset, branch, branch_target, pc, clear_in)
  begin
    if reset = '0' or clear_in = '1' then
      if_id_register_next.pc <= PC_RESET_VECTOR;
      pc_next <= PC_RESET_VECTOR;
    else
      if_id_register_next.pc <= pc;
      
      if stall_in = '0' then
        if branch = '1' then
          pc_next <= branch_target;
        else
          pc_next <= std_logic_vector(unsigned(pc) + 2);
        end if;
      else
        pc_next <= pc;
      end if;
    end if;
  end process;

  -- 00000000 <reset>:
  -- 0:   81 03           ld R1,#0x3
  -- 2:   91 01           ldhb R1,#0x1
  -- 4:   82 30           ld R2,#0x30
  -- 6:   82 33           ld R2,#0x33
  -- 8:   10 12           add R1,R2
  -- a:   88 00           ld R8,#0x0
  -- c:   98 00           ldhb R8,#0x0
  -- e:   70 08           jmp R8
  process (pc)
  begin
    case pc is
      when x"0000" => if_id_register_next.ir <= x"8103";  -- ld R1,#0x3
      when x"0002" => if_id_register_next.ir <= x"9101";  -- ldhb R1,#0x1
      when x"0004" => if_id_register_next.ir <= x"8230";  -- ld R2,#0x30
      when x"0006" => if_id_register_next.ir <= x"8233";  -- ld R2,#0x33
      when x"0008" => if_id_register_next.ir <= x"1012";  -- add R1,R2
      when x"000A" => if_id_register_next.ir <= x"8800";  -- ld R8,#0x0
      when x"000C" => if_id_register_next.ir <= x"9800";  -- ldhb R8,#0x0
      when x"7008" => if_id_register_next.ir <= x"7008";  -- jmp R8
      when others => if_id_register_next.ir <= x"0000"; -- nop
    end case;
  end process;
  
end if_state_behavioral;


