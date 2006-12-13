-- File: ex_stage.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-11-29
-- Last updated: 2006-11-29

-- Description:
-- Execute stage
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.rise_pack.all;

entity tb_id_stage_unit_vhd is
end tb_id_stage_unit_vhd;

architecture behavior of tb_id_stage_unit_vhd is

  -- component Declaration for the Unit Under Test (UUT)
  component id_stage
    port(
      clk   : in std_logic;
      reset : in std_logic;

      if_id_register : in  IF_ID_REGISTER_T;
      id_ex_register : out ID_EX_REGISTER_T;

      rx_addr : out REGISTER_ADDR_T;
      ry_addr : out REGISTER_ADDR_T;
      rz_addr : out REGISTER_ADDR_T;

      rx : in REGISTER_T;
      ry : in REGISTER_T;
      rz : in REGISTER_T;
      sr : in SR_REGISTER_T;

      lock_register : in  LOCK_REGISTER_T;
      set_reg_lock  : out std_logic;
      lock_reg_addr : out REGISTER_ADDR_T;

      stall_in  : in  std_logic;
      stall_out : out std_logic;
      clear_in  : in  std_logic
      );
  end component;

  --inputs
  signal clk            : std_logic := '0';
  signal reset          : std_logic := '0';
  signal if_id_register : IF_ID_REGISTER_T;

  signal stall_in       : std_logic     := '0';
  signal clear_in       : std_logic     := '0';
  signal rx             : REGISTER_T    := (others => '0');
  signal ry             : REGISTER_T    := (others => '0');
  signal rz             : REGISTER_T    := (others => '0');
  signal sr             : SR_REGISTER_T := (others => '0');
  signal lock_register  : LOCK_REGISTER_T;
  --Outputs
  signal id_ex_register : ID_EX_REGISTER_T;
  signal rx_addr        : std_logic_vector(REGISTER_ADDR_WIDTH - 1 downto 0);
  signal ry_addr        : std_logic_vector(REGISTER_ADDR_WIDTH - 1 downto 0);
  signal rz_addr        : std_logic_vector(REGISTER_ADDR_WIDTH - 1 downto 0);
  signal set_reg_lock   : std_logic;
  signal lock_reg_addr  : std_logic_vector(REGISTER_ADDR_WIDTH - 1 downto 0);
  signal stall_out      : std_logic;

begin

  -- instantiate the Unit Under Test (UUT)
  uut : id_stage port map(
    clk            => clk,
    reset          => reset,
    if_id_register => if_id_register,
    id_ex_register => id_ex_register,
    rx_addr        => rx_addr,
    ry_addr        => ry_addr,
    rz_addr        => rz_addr,
    rx             => rx,
    ry             => ry,
    rz             => rz,
    sr             => sr,
    lock_register  => lock_register,
    set_reg_lock   => set_reg_lock,
    lock_reg_addr  => lock_reg_addr,
    stall_in       => stall_in,
    stall_out      => stall_out,
    clear_in       => clear_in
    );

  cg : process
  begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
  end process;

  tb : process
  begin
    reset <= '0';
    wait for 100 ns;
    reset <= '1';

    -- stimulus 
    if_id_register.pc <= x"1234";
    if_id_register.ir <= "100"& "0" & "0001" & x"55";

    wait;                               -- will wait forever
  end process;

end;
