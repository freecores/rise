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
  
  function opcode_modifies_rx( opcode: in OPCODE_T ) return std_logic is
    variable modifies : std_logic;
  begin
    case opcode is
      when OPCODE_LD_IMM => modifies := '1';
      when others => modifies := '0';
    end case;
    return modifies;
  end;
  
  function register_is_ready( reg_addr: in REGISTER_ADDR_T ) return std_logic is
    variable index : integer range 0 to REGISTER_COUNT - 1;
  begin
    return '1';
  end;
  
begin  -- id_stage_rtl

  id_ex_register        <= id_ex_register_int;
  
--  process (clk, reset)
--  begin  -- process
--    if reset = '0' then                 -- asynchronous reset (active low)
--      id_ex_register_int        <= (others => (others => '0'));
--      id_ex_register_next       <= (others => (others => '0'));
--    elsif clk'event and clk = '1' then  -- rising clock edge
--      id_ex_register_int        <= id_ex_register_next;
--    end if;
--  end process;  

  process (clk, reset ) 
  begin
    if reset = '0' then
      id_ex_register_int.sr <= RESET_SR_VALUE;
      id_ex_register_int.pc <= RESET_PC_VALUE;
      id_ex_register_int.opcode <= OPCODE_NOP;
      id_ex_register_int.cond <= COND_NONE;
      id_ex_register_int.rX_addr <= ( others => '0' );
      id_ex_register_int.rX <= ( others => '0' );
      id_ex_register_int.rY <= ( others => '0' );
      id_ex_register_int.rZ <= ( others => '0' );
      id_ex_register_int.immediate <= ( others => '0' );
    elsif clk'event and clk = '1' then 
      id_ex_register_int <= id_ex_register_next;
    end if;
  end process;
  
  -- The opc_extender decodes the two different formats used for the opcodes
  -- in the instruction set into a single 5-bit opcode format.
  opc_extender: process (clk, reset )
  begin
    if reset = '0' then
      id_ex_register_next.opcode <= OPCODE_NOP;
      -- decodes: OPCODE_LD_IMM, OPCODE_LD_IMM_HB
    elsif if_id_register.ir( 15 downto 13 ) = "100" then
      id_ex_register_next.opcode <= if_id_register.ir( 15 downto 13 ) & if_id_register.ir( 12 ) & "0";
      -- decodes: OPCODE_LD_DISP, OPCODE_LD_DISP_MS, OPCODE_ST_DISP
    elsif if_id_register.ir(15) = '1' then
      id_ex_register_next.opcode <= if_id_register.ir( 15 downto 13 ) & "00";
      -- decodes: OPCODE_XXX
    else
      id_ex_register_next.opcode <= if_id_register.ir( 15 downto 11 );
    end if;
  end process;
  
  cond_decode: process (clk, reset )
  begin
    if reset = '0' then 
      id_ex_register_next.cond <= COND_NONE;
      -- decodes: OPCODE_LD_IMM, OPCODE_LD_IMM_HB
    elsif if_id_register.ir( 15 downto 13 ) = "100" then
      id_ex_register_next.cond <= COND_UNCONDITIONAL;
      -- decodes: OPCODE_LD_DISP, OPCODE_LD_DISP_MS, OPCODE_ST_DISP      
    elsif if_id_register.ir(15) = '1' then
      id_ex_register_next.cond <= if_id_register.ir( 15 downto 13 );
      -- decodes: OPCODE_XXX
    else
      id_ex_register_next.cond <= if_id_register.ir( 10 downto 8 );
    end if;
  end process;
  
  pc: process( if_id_register )
  begin
    if reset = '0' then
      id_ex_register_next.pc <= RESET_PC_VALUE;
    else
      id_ex_register_next.pc <= if_id_register.pc;
    end if;
  end process;
  
  rx_decode_and_fetch: process (reset, if_id_register, id_ex_register_next)
  begin
    -- make sure we don't synthesize a latch for rx_addr
    rx_addr <= ( others => '0' );
    
    if reset = '0' then
      id_ex_register_next.rX <= ( others => '0' );
      id_ex_register_next.rX_addr <= ( others => '0' );
    elsif id_ex_register_next.opcode = OPCODE_LD_IMM or 
      id_ex_register_next.opcode = OPCODE_LD_IMM_HB then
      rx_addr <= if_id_register.ir( 11 downto 8 );
      id_ex_register_next.rX <= rx;
      id_ex_register_next.rX_addr <= if_id_register.ir( 11 downto 8 );
    else
      rx_addr <= if_id_register.ir( 7 downto 4 );
      id_ex_register_next.rX <= rx;
      id_ex_register_next.rX_addr <= if_id_register.ir( 7 downto 4 );
    end if;
    
    if opcode_modifies_rx( id_ex_register_next.opcode ) = '1' then
      lock_reg_addr <= id_ex_register_next.rX_addr;
      set_reg_lock <= '1';
    else
      lock_reg_addr <= ( others => '0' );
      set_reg_lock <= '0';
    end if;
  end process;
  
  ry_decode_and_fetch: process (reset, if_id_register, id_ex_register_next)
  begin
    -- make sure we don't synthesize a latch for ry_addr
    ry_addr <= ( others => '0' );
    
    if reset = '0' then
      id_ex_register_next.rY <= ( others => '0' );
    else
      ry_addr <= if_id_register.ir( 3 downto 0 );
      id_ex_register_next.rZ <= rz;
    end if;
  end process;
  
  rz_decode_and_fetch: process (reset, if_id_register, id_ex_register_next)
  begin
    -- make sure we don't synthesize a latch for rz_addr
    rz_addr <= ( others => '0' );
    
    if reset = '0' then
      id_ex_register_next.rZ <= ( others => '0' );
    else
      -- only the lower 2-bits of rz are encoded in the instruction
      rz_addr <= "00" & if_id_register.ir( 9 downto 8 );
      id_ex_register_next.rZ <= rz;
    end if;
  end process;
  
  -- The immediate fetch process checks for all opcodes needing constants
  -- and decides which immediate format was present. If the instruction
  -- does not include an immediate value the result is undefined and must
  -- not be used.
  imm_fetch: process (reset, if_id_register, id_ex_register_next)
  begin
    case id_ex_register_next.opcode is
      -- The immediate values holds the upper 8 bits of a 16 bit value.
      when OPCODE_LD_IMM_HB => 
        id_ex_register_next.immediate <= if_id_register.ir( 7 downto 0 ) & x"00";
        -- The immediate values holds the lower 8 bits of a 16 bit value. 
      when OPCODE_LD_IMM => 
        id_ex_register_next.immediate <= x"00" & if_id_register.ir( 7 downto 0 );
        -- Default format holds the lower 4 bits of a 16 bit value.
      when others =>
        id_ex_register_next.immediate <= x"000" & if_id_register.ir( 3 downto 0 );
    end case;
  end process;
  
end id_stage_rtl;
