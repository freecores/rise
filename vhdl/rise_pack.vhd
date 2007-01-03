-------------------------------------------------------------------------------
-- File: rise_pack.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-11-29
-- Last updated: 2006-11-29

-- Description:
-- Package for RISE project.
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

package RISE_PACK is

  constant ARCHITECTURE_WIDTH : integer := 16;
  constant REGISTER_COUNT : integer := 16;
  
  constant PC_WIDTH : integer := ARCHITECTURE_WIDTH;
  constant IR_WIDTH : integer := ARCHITECTURE_WIDTH;
  constant SR_WIDTH : integer := ARCHITECTURE_WIDTH;
  constant OPCODE_WIDTH : integer := 5;
  constant COND_WIDTH : integer := 3;
  constant MEM_DATA_WIDTH : integer := ARCHITECTURE_WIDTH;
  constant MEM_ADDR_WIDTH : integer := ARCHITECTURE_WIDTH;
  
  constant REGISTER_WIDTH : integer := ARCHITECTURE_WIDTH;
  constant REGISTER_ADDR_WIDTH : integer := 4;
  constant IMMEDIATE_WIDTH : integer := ARCHITECTURE_WIDTH;
  constant LOCK_WIDTH : integer := REGISTER_COUNT;

  constant ALUOP1_WIDTH : integer := 3;
  constant ALUOP2_WIDTH : integer := 3;
  
  subtype PC_REGISTER_T is std_logic_vector(PC_WIDTH-1 downto 0);
  subtype IR_REGISTER_T is std_logic_vector(IR_WIDTH-1 downto 0);
  subtype SR_REGISTER_T is std_logic_vector(SR_WIDTH-1 downto 0);
  subtype REGISTER_T is std_logic_vector(REGISTER_WIDTH-1 downto 0);
  subtype REGISTER_ADDR_T is std_logic_vector(REGISTER_ADDR_WIDTH-1 downto 0);
  subtype MEM_DATA_T is std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
  subtype MEM_ADDR_T is std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);

  subtype LOCK_REGISTER_T is std_logic_vector(LOCK_WIDTH-1 downto 0);
    
  subtype IMMEDIATE_T is std_logic_vector(IMMEDIATE_WIDTH-1 downto 0);
  subtype OPCODE_T is std_logic_vector(OPCODE_WIDTH-1 downto 0);
  subtype COND_T is std_logic_vector(COND_WIDTH-1 downto 0);

  subtype ALUOP1_T is std_logic_vector(ALUOP1_WIDTH-1 downto 0);
  subtype ALUOP2_T is std_logic_vector(ALUOP2_WIDTH-1 downto 0);

  --
  constant SR_REGISTER_ADDR : REGISTER_ADDR_T := "1111";
  constant PC_REGISTER_ADDR : REGISTER_ADDR_T := "1110";
  constant LR_REGISTER_ADDR : REGISTER_ADDR_T := "1101";
  
  constant SR_REGISTER_DI : INTEGER := 15;
  constant SR_REGISTER_IP_MASK : INTEGER := 12;
  constant SR_REGISTER_OVERFLOW : INTEGER := 3;
  constant SR_REGISTER_NEGATIVE : INTEGER := 2;
  constant SR_REGISTER_CARRY : INTEGER := 1;
  constant SR_REGISTER_ZERO : INTEGER := 0;
  constant RESET_PC_VALUE : PC_REGISTER_T := ( others => '0' );
  constant RESET_SR_VALUE : PC_REGISTER_T := ( others => '0' );
  
  constant COND_NONE : COND_T := "000";
  constant PC_ADDR : REGISTER_ADDR_T := CONV_STD_LOGIC_VECTOR(14, REGISTER_ADDR_WIDTH);

  -- RISE OPCODES --
  -- load opcodes
  constant OPCODE_LD_IMM        : OPCODE_T := "10000";
  constant OPCODE_LD_IMM_HB     : OPCODE_T := "10010";  
  constant OPCODE_LD_DISP       : OPCODE_T := "10100";
  constant OPCODE_LD_DISP_MS    : OPCODE_T := "11000";
  constant OPCODE_LD_REG        : OPCODE_T := "00001";

  -- store opcodes
  constant OPCODE_ST_DISP       : OPCODE_T := "11100";
  
  -- arithmethic opcodes
  constant OPCODE_ADD           : OPCODE_T := "00010";  
  constant OPCODE_ADD_IMM       : OPCODE_T := "00011";  
  constant OPCODE_SUB           : OPCODE_T := "00100";  
  constant OPCODE_SUB_IMM       : OPCODE_T := "00101";  
  constant OPCODE_NEG           : OPCODE_T := "00110";  
  constant OPCODE_ARS           : OPCODE_T := "00111";  
  constant OPCODE_ALS           : OPCODE_T := "01000";

  -- logical opcodes
  constant OPCODE_AND : OPCODE_T := "01001";
  constant OPCODE_NOT : OPCODE_T := "01010";
  constant OPCODE_EOR : OPCODE_T := "01011";
  constant OPCODE_LS :  OPCODE_T := "01100";
  constant OPCODE_RS :  OPCODE_T := "01101";
  
  -- program control
  constant OPCODE_JMP : OPCODE_T := "01110";

  -- other
  constant OPCODE_TST : OPCODE_T := "01111";
  constant OPCODE_NOP : OPCODE_T := "00000";
  
  -- CONDITION CODES --
  constant COND_UNCONDITIONAL   : COND_T := "000";
  constant COND_NOT_ZERO        : COND_T := "001";
  constant COND_ZERO            : COND_T := "010";
  constant COND_CARRY           : COND_T := "011";
  constant COND_NEGATIVE        : COND_T := "100";
  constant COND_OVERFLOW        : COND_T := "101";
  constant COND_ZERO_NEGATIVE   : COND_T := "110";

  -- STATUS REGISTER BITS --
  constant SR_ZERO_BIT          : integer := 0;
  constant SR_CARRY_BIT         : integer := 1;
  constant SR_NEGATIVE_BIT      : integer := 2;
  constant SR_OVERFLOW_BIT      : integer := 3;
  
  type IF_ID_REGISTER_T is record
                             pc : PC_REGISTER_T;
                             ir : IR_REGISTER_T;
                           end record;

  type ID_EX_REGISTER_T is record
                             sr         : SR_REGISTER_T;
                             pc         : PC_REGISTER_T;
                             opcode     : OPCODE_T;
                             cond       : COND_T;
                             rX_addr    : REGISTER_ADDR_T;  
                             rX         : REGISTER_T;
                             rY         : REGISTER_T;
                             rZ         : REGISTER_T;
                             immediate  : IMMEDIATE_T;
                           end record;

  -- bit positions for aluop1
  constant ALUOP1_LD_MEM_BIT : integer := 0;
  constant ALUOP1_ST_MEM_BIT : integer := 1;
  constant ALUOP1_WB_REG_BIT : integer := 2;

  -- bit positions for aluop2
  constant ALUOP2_SR_BIT : integer := 0;
  constant ALUOP2_LR_BIT : integer := 1;

  type EX_MEM_REGISTER_T is record
                              aluop1        : ALUOP1_T;
                              aluop2        : ALUOP2_T;
                              reg           : REGISTER_T;
                              alu           : REGISTER_T;
                              dreg_addr     : REGISTER_ADDR_T;
                              lr            : PC_REGISTER_T;
                              sr            : SR_REGISTER_T;
                            end record;
    
  type MEM_WB_REGISTER_T is record
                              aluop1        : ALUOP1_T;
                              aluop2        : ALUOP2_T;
                              reg           : REGISTER_T;
                              dreg_addr     : REGISTER_ADDR_T;                           
                              lr            : PC_REGISTER_T;
                            end record;
  
end RISE_PACK;

