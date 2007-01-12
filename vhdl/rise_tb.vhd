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

entity rise_tb_vhd is
end rise_tb_vhd;

architecture behavior of rise_tb_vhd is

  component rise
    port(
      clk   : in  std_logic;
      reset : in  std_logic;
      rx    : in  std_logic;
      tx    : out std_logic
      );
  end component;

  --Inputs
  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';
  signal rx    : std_logic := '0';

  --Outputs
  signal tx : std_logic;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : rise port map(
    clk   => clk,
    reset => reset,
    rx    => rx,
    tx    => tx
    );

  clk_gen : process
  begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
  end process;

  tb : process
  begin

    -- Wait 100 ns for global reset to finish
    wait for 100 ns;

    -- Place stimulus here
    reset <= '1';

    -- Let the simulation run for 200 ns;
    wait for 200 ns;

    wait;
  end process;

end;
