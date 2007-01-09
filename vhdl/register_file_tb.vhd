
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:36:49 01/07/2007
-- Design Name:   register_file
-- Module Name:   register_file_tb.vhd
-- Project Name:  rise
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: register_file
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY register_file_tb_vhd IS
END register_file_tb_vhd;

ARCHITECTURE behavior OF register_file_tb_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT register_file
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		rx_addr : IN std_logic_vector(3 downto 0);
		ry_addr : IN std_logic_vector(3 downto 0);
		rz_addr : IN std_logic_vector(3 downto 0);
		dreg_addr : IN std_logic_vector(3 downto 0);
		dreg_write : IN std_logic_vector(15 downto 0);
		dreg_enable	 : in std_logic;
		sr_write : IN std_logic_vector(15 downto 0);
		sr_enable	 : in std_logic;
		lr_write : IN std_logic_vector(15 downto 0);
		lr_enable	 : in std_logic;
		pc_write : IN std_logic_vector(15 downto 0);          
		rx_read : OUT std_logic_vector(15 downto 0);
		ry_read : OUT std_logic_vector(15 downto 0);
		rz_read : OUT std_logic_vector(15 downto 0);
		sr_read : OUT std_logic_vector(15 downto 0);
		pc_read : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL reset :  std_logic := '0';
	SIGNAL rx_addr :  std_logic_vector(3 downto 0) := (others=>'0');
	SIGNAL ry_addr :  std_logic_vector(3 downto 0) := (others=>'0');
	SIGNAL rz_addr :  std_logic_vector(3 downto 0) := (others=>'0');
	SIGNAL dreg_addr :  std_logic_vector(3 downto 0) := (others=>'0');
	SIGNAL dreg_write :  std_logic_vector(15 downto 0) := (others=>'0');
	signal dreg_enable : std_logic;
	SIGNAL sr_write :  std_logic_vector(15 downto 0) := (others=>'0');
	signal sr_enable : std_logic;
	SIGNAL lr_write :  std_logic_vector(15 downto 0) := (others=>'0');
	signal lr_enable : std_logic;
	SIGNAL pc_write :  std_logic_vector(15 downto 0) := (others=>'0');

	--Outputs
	SIGNAL rx_read :  std_logic_vector(15 downto 0);
	SIGNAL ry_read :  std_logic_vector(15 downto 0);
	SIGNAL rz_read :  std_logic_vector(15 downto 0);
	SIGNAL sr_read :  std_logic_vector(15 downto 0);
	SIGNAL pc_read :  std_logic_vector(15 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: register_file PORT MAP(
		clk => clk,
		reset => reset,
		rx_addr => rx_addr,
		ry_addr => ry_addr,
		rz_addr => rz_addr,
		dreg_addr => dreg_addr,
		dreg_write => dreg_write,
		dreg_enable => dreg_enable,
		rx_read => rx_read,
		ry_read => ry_read,
		rz_read => rz_read,
		sr_write => sr_write,
		sr_enable => sr_enable,
		lr_write => lr_write,
		lr_enable => lr_enable,
		pc_write => pc_write,
		sr_read => sr_read,
		pc_read => pc_read
	);

	PROCESS -- clock process for CLK,
		BEGIN
			CLOCK_LOOP : LOOP
			clk <= transport '0';
			WAIT FOR 10 ns;
			clk <= transport '1';
			WAIT FOR 10 ns;

			END LOOP CLOCK_LOOP;
	END PROCESS;


	process
	begin

		reset <= '0';
		dreg_enable <= '0';
		sr_enable <= '0';
		lr_enable <= '0';
		WAIT FOR 50 ns;
		dreg_enable <= '1';
		reset <= '1';
		wait for 10 ns;
		
		dreg_addr	<= "0101";
		dreg_write	<= "1111111111111111";
		
		rx_addr	<= "0101";
		
		wait for 40 ns;
		dreg_addr	<= "0001";
		dreg_write	<= "1111111100000000";
		
		rx_addr	<= "0101";
			
		wait for 40 ns;
		dreg_enable <= '0';
		wait for 5 ns;
		dreg_addr	<= "0000";
		dreg_write	<= "0000000011111111";
		
		wait for 40 ns;
		dreg_enable <= '1';
		wait for 5 ns;
		dreg_addr	<= "0010";
		dreg_write	<= "1010101010101010";
		
		
		wait for 30 ns;
		
		rx_addr	<= "0010";
		ry_addr	<= "0001";
		rz_addr	<= "0000";
		
		dreg_addr <= "0010";
		dreg_write <= "1111111111111111";

		wait for 20 ns;
		
		dreg_addr <= "1110";
		dreg_write <= "1111111100000000";
		pc_write <= "1010101010101010";
		
		wait for 20 ns;
		
		dreg_addr <= "1111";
		dreg_write <= "1111111100000000";
		
		sr_enable <= '1';
		sr_write <= "1010101010101010";
		
		--wait for

		wait;

	end process;


END;
