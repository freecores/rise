-------------------------------------------------------------------------------
-- File: ex_stage.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-12-31
-- Last updated: 2006-12-31

-- Description:
-- Testbench for RLU unit
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.all;
use work.rise_pack.all;

entity tb_rlu_unit_vhd is
end tb_rlu_unit_vhd;

architecture behavior of tb_rlu_unit_vhd is

  -- component Declaration for the Unit Under Test (UUT)
  component rlu is
  
  port (
    clk                 : in std_logic;
    reset               : in std_logic;

    lock_register       : out LOCK_REGISTER_T;

    clear_reg_lock      : in std_logic;
    set_reg_lock        : in std_logic;
    reg_addr            : in REGISTER_ADDR_T);

  end component;
    
  constant clk_period : time := 10 ns;

  --inputs
  signal clk            : std_logic := '0';
  signal reset          : std_logic := '0';
  signal clear_reg_lock : std_logic := '0';
  signal set_reg_lock   : std_logic := '0';
  signal reg_addr       : REGISTER_ADDR_T;
  
  --Outputs
  signal lock_register : LOCK_REGISTER_T;
  
begin

  -- instantiate the Unit Under Test (UUT)
  uut : rlu port map(
    clk             => clk,
    reset           => reset,
    lock_register   => lock_register, 

    clear_reg_lock  => clear_reg_lock,
    set_reg_lock    => set_reg_lock,
    reg_addr        => reg_addr);


  
  cg : process
  begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process;

  tb : process
  begin
    reset <= '0';
    wait for 10 * clk_period;
    reset <= '1';


    reg_addr <= CONV_STD_LOGIC_VECTOR(8, REGISTER_ADDR_WIDTH);
    set_reg_lock <= '1';
    wait for clk_period;
    reg_addr <= CONV_STD_LOGIC_VECTOR(5, REGISTER_ADDR_WIDTH);
    set_reg_lock <= '1';
    wait for clk_period;
    set_reg_lock <= '0';
    reg_addr <= CONV_STD_LOGIC_VECTOR(8, REGISTER_ADDR_WIDTH);
    clear_reg_lock <= '1';
    wait for clk_period;
    clear_reg_lock <= '0';
    
    wait;                               -- will wait forever
  end process;

end;
