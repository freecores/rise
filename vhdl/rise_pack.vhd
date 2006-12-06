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
  constant REGISTER_ADDR_WIDTH : integer := 5;
  constant IMMEDIATE_WIDTH : integer := ARCHITECTURE_WIDTH;
  constant LOCK_WIDTH : integer := REGISTER_COUNT;
  
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
  
  type EX_MEM_REGISTER_T is record
                              aluop1        : std_logic_vector(2 downto 0);
                              aluop2        : std_logic_vector(2 downto 0);
                              reg           : REGISTER_T;
                              alu           : REGISTER_T;
                              dreg_addr     : REGISTER_ADDR_T;
                              lr            : PC_REGISTER_T;
                            end record;
    
  type MEM_WB_REGISTER_T is record
                              aluop1        : std_logic_vector(2 downto 0);
                              aluop2        : std_logic_vector(2 downto 0);
                              reg           : REGISTER_T;
                              dreg_addr     : REGISTER_ADDR_T;                           
                              lr            : PC_REGISTER_T;
                            end record;
  
end RISE_PACK;

