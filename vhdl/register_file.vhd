

-- File: register_file.vhd
-- Author: Jakob Lechner, Urban Stadler, Harald Trinkl, Christian Walter
-- Created: 2006-11-29
-- Last updated: 2006-11-29

-- Description:
-- Entity implementing register file.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.RISE_PACK.all;


entity register_file is
  
  port (
    clk            : in std_logic;
    reset          : in std_logic;

    rx_addr        : in REGISTER_ADDR_T;
    ry_addr        : in REGISTER_ADDR_T;
    rz_addr        : in REGISTER_ADDR_T;
    dreg_addr      : in REGISTER_ADDR_T;
    
    dreg_write     : in REGISTER_T;
    rx_read        : out REGISTER_T;
    ry_read        : out REGISTER_T;
    rz_read        : out REGISTER_T;

    sr_write       : in SR_REGISTER_T;
    lr_write       : in PC_REGISTER_T;
    pc_write       : in PC_REGISTER_T;
    sr_read        : out SR_REGISTER_T;
    pc_read        : out PC_REGISTER_T);

end register_file;

architecture register_file_rtl of register_file is


	signal rx_read_next	: REGISTER_T;
	signal ry_read_next	: REGISTER_T;
	signal rz_read_next	: REGISTER_T;
	
	signal sr_read_next	: SR_REGISTER_T;
	signal pc_read_next	: PC_REGISTER_T;
	
	signal dreg_addr_tmp		:	REGISTER_ADDR_T;
	signal dreg_write_tmp	:	REGISTER_T;
	
	signal sr_write_tmp	:	SR_REGISTER_T;
	signal lr_write_tmp	:	PC_REGISTER_T;
	signal pc_write_tmp	:	PC_REGISTER_T;
	
	
	
	signal regx_0, regx_1, regx_2, regx_3, regx_4						:	REGISTER_T; 
	signal regx_5, regx_6, regx_7, regx_8, regx_9 						:	REGISTER_T;
	signal regx_10, regx_11, regx_12, regx_13, regx_14, regx_15		:	REGISTER_T;
	
	signal regy_0, regy_1, regy_2, regy_3, regy_4						:	REGISTER_T; 
	signal regy_5, regy_6, regy_7, regy_8, regy_9 						:	REGISTER_T;
	signal regy_10, regy_11, regy_12, regy_13, regy_14, regy_15		:	REGISTER_T;
	
	signal regz_0, regz_1, regz_2, regz_3, regz_4						:	REGISTER_T; 
	signal regz_5, regz_6, regz_7, regz_8, regz_9 						:	REGISTER_T;
	signal regz_10, regz_11, regz_12, regz_13, regz_14, regz_15		:	REGISTER_T;

begin  -- register_file_rtl

	SYNC: process(clk, reset)
	begin
		
		if reset = '0' then
		
			rx_read	<= (others => '0');
			ry_read	<= (others => '0');
			rz_read	<= (others => '0');
			
			sr_read	<=	(others => '0');
			pc_read	<=( others => '0');
			
			sr_write_tmp 	<=	(others => '0');
			lr_write_tmp	<=	(others => '0');
			pc_write_tmp	<= (others => '0');
			
			dreg_addr_tmp	<=	(others => '0');
			dreg_write_tmp	<= (others => '0');

		elsif clk'event and clk = '1' then
			
			rx_read 	<=	rx_read_next;
			ry_read 	<=	ry_read_next;
			rz_read 	<=	rz_read_next;
			
			sr_read <=	sr_read_next;
			pc_read <=	pc_read_next;
			
			sr_write_tmp 	<=	sr_write;
			lr_write_tmp	<=	lr_write;
			pc_write_tmp	<= pc_write;
			
			dreg_addr_tmp	<=	dreg_addr;
			dreg_write_tmp	<= dreg_write;

		end if;
		
	end process SYNC;
	
	WRITE: process(clk, reset)
	begin
		
		if reset = '0' then
			
			sr_read_next	<= (others => '0');
			pc_read_next	<= (others => '0');
			
			regx_0	<= (others => '0');
			regx_1	<= (others => '0');
			regx_2	<= (others => '0');
			regx_3	<= (others => '0');
			regx_4	<= (others => '0');
			regx_5	<= (others => '0');
			regx_6	<= (others => '0');
			regx_7	<= (others => '0');
			regx_8	<= (others => '0');
			regx_9	<= (others => '0');
			regx_10	<= (others => '0');
			regx_11	<= (others => '0');
			regx_12	<= (others => '0');
			regx_13	<= (others => '0');
			regx_14	<= (others => '0');
			regx_15	<= (others => '0');
			
			regy_0	<= (others => '0');
			regy_1	<= (others => '0');
			regy_2	<= (others => '0');
			regy_3	<= (others => '0');
			regy_4	<= (others => '0');
			regy_5	<= (others => '0');
			regy_6	<= (others => '0');
			regy_7	<= (others => '0');
			regy_8	<= (others => '0');
			regy_9	<= (others => '0');
			regy_10	<= (others => '0');
			regy_11	<= (others => '0');
			regy_12	<= (others => '0');
			regy_13	<= (others => '0');
			regy_14	<= (others => '0');
			regy_15	<= (others => '0');
			
			regz_0	<= (others => '0');
			regz_1	<= (others => '0');
			regz_2	<= (others => '0');
			regz_3	<= (others => '0');
			regz_4	<= (others => '0');
			regz_5	<= (others => '0');
			regz_6	<= (others => '0');
			regz_7	<= (others => '0');
			regz_8	<= (others => '0');
			regz_9	<= (others => '0');
			regz_10	<= (others => '0');
			regz_11	<= (others => '0');
			regz_12	<= (others => '0');
			regz_13	<= (others => '0');
			regz_14	<= (others => '0');
			regz_15	<= (others => '0');

		elsif clk'event and clk = '0' then
			
			sr_read_next	<= sr_write_tmp;
			--lr_write_next	<= lr_write_tmp;
			pc_read_next	<= pc_write_tmp;
			
			
			if dreg_addr_tmp = "0000" then
				
				regx_0 <= dreg_write_tmp;
				regy_0 <= dreg_write_tmp;
				regz_0 <= dreg_write_tmp;
				
			elsif	dreg_addr_tmp = "0001" then
			
				regx_1	<= dreg_write_tmp;
				regy_1	<= dreg_write_tmp;
				regz_1	<= dreg_write_tmp;
							
			elsif	dreg_addr_tmp = "0010" then
			
				regx_2	<= dreg_write_tmp;
				regy_2 	<= dreg_write_tmp;
				regz_2 	<= dreg_write_tmp;
								
			elsif	dreg_addr_tmp = "0011" then
			
				regx_3	<= dreg_write_tmp;
				regy_3 	<= dreg_write_tmp;
				regz_3 	<= dreg_write_tmp;
								
			elsif	dreg_addr_tmp = "0100" then
			
				regx_4	<= dreg_write_tmp;
				regy_4 	<= dreg_write_tmp;
				regz_4 	<= dreg_write_tmp;
								
			elsif	dreg_addr_tmp = "0101" then
			
				regx_5	<= dreg_write_tmp;
				regy_5 	<= dreg_write_tmp;
				regz_5 	<= dreg_write_tmp;
								
			elsif	dreg_addr_tmp = "0110" then
			
				regx_6	<= dreg_write_tmp;
				regy_6 	<= dreg_write_tmp;
				regz_6 	<= dreg_write_tmp;
				
			elsif	dreg_addr_tmp = "0111" then
			
				regx_7	<= dreg_write_tmp;
				regy_7 	<= dreg_write_tmp;
				regz_7 	<= dreg_write_tmp;
				
			elsif	dreg_addr_tmp = "1000" then
			
				regx_8	<= dreg_write_tmp;
				regy_8 	<= dreg_write_tmp;
				regz_8 	<= dreg_write_tmp;				
			elsif	dreg_addr_tmp = "1001" then
			
				regx_9	<= dreg_write_tmp;
				regy_9 	<= dreg_write_tmp;
				regz_9 	<= dreg_write_tmp;
				
			elsif	dreg_addr_tmp = "1010" then
			
				regx_10	<= dreg_write_tmp;
				regy_10 	<= dreg_write_tmp;
				regz_10 	<= dreg_write_tmp;
				
			elsif	dreg_addr_tmp = "1011" then
			
				regx_11	<= dreg_write_tmp;
				regy_11 	<= dreg_write_tmp;
				regz_11 	<= dreg_write_tmp;
				
			elsif	dreg_addr_tmp = "1100" then
			
				regx_12	<= dreg_write_tmp;
				regy_12 	<= dreg_write_tmp;
				regz_12 	<= dreg_write_tmp;
				
			elsif	dreg_addr_tmp = "1101" then
			
				regx_13	<= dreg_write_tmp;
				regy_13 	<= dreg_write_tmp;
				regz_13 	<= dreg_write_tmp;
				
			elsif	dreg_addr_tmp = "1110" then
			
				regx_14	<= dreg_write_tmp;
				regy_14 	<= dreg_write_tmp;
				regz_14 	<= dreg_write_tmp;
				
			elsif	dreg_addr_tmp = "1111" then
			
				regx_15	<= dreg_write_tmp;
				regy_15 	<= dreg_write_tmp;
				regz_15 	<= dreg_write_tmp;	
			
			end if;

		end if;
		
	end process WRITE;


	RX_READ_PROC: process(reset, rx_addr, 
						regx_0,  regx_1, regx_2, regx_3, regx_4, regx_5, regx_6, regx_7, 
						regx_8, regx_9, regx_10, regx_11, regx_12, regx_13, regx_14, regx_15)
	begin
	
	if reset = '0' then
	
		rx_read_next <= (others => '0');
	else
	
		CASE rx_addr IS
			WHEN "0000" => rx_read_next <= regx_0;
			WHEN "0001" => rx_read_next <= regx_1;
			WHEN "0010" => rx_read_next <= regx_2;
			WHEN "0011" => rx_read_next <= regx_3;
			WHEN "0100" => rx_read_next <= regx_4;
			WHEN "0101" => rx_read_next <= regx_5;
			WHEN "0110" => rx_read_next <= regx_6;
			WHEN "0111" => rx_read_next <= regx_7;
			WHEN "1000" => rx_read_next <= regx_8;
			WHEN "1001" => rx_read_next <= regx_9;
			WHEN "1010" => rx_read_next <= regx_10;
			WHEN "1011" => rx_read_next <= regx_11;
			WHEN "1100" => rx_read_next <= regx_12;
			WHEN "1101" => rx_read_next <= regx_13;
			WHEN "1110" => rx_read_next <= regx_14;
			WHEN "1111" => rx_read_next <= regx_15;
			WHEN OTHERS => rx_read_next <= "XXXXXXXXXXXXXXXX";
		END CASE;
	
	end if;

	end process RX_READ_PROC;
	
	
	
	RY_READ_PROC: process(reset, ry_addr, 
						regy_0,  regy_1, regy_2, regy_3, regy_4, regy_5, regy_6, regy_7, 
						regy_8, regy_9, regy_10, regy_11, regy_12, regy_13, regy_14, regy_15)
	begin
	
	if reset = '0' then
	
		ry_read_next <= (others => '0');
	else
	
		CASE ry_addr IS
			WHEN "0000" => ry_read_next <= regy_0;
			WHEN "0001" => ry_read_next <= regy_1;
			WHEN "0010" => ry_read_next <= regy_2;
			WHEN "0011" => ry_read_next <= regy_3;
			WHEN "0100" => ry_read_next <= regy_4;
			WHEN "0101" => ry_read_next <= regy_5;
			WHEN "0110" => ry_read_next <= regy_6;
			WHEN "0111" => ry_read_next <= regy_7;
			WHEN "1000" => ry_read_next <= regy_8;
			WHEN "1001" => ry_read_next <= regy_9;
			WHEN "1010" => ry_read_next <= regy_10;
			WHEN "1011" => ry_read_next <= regy_11;
			WHEN "1100" => ry_read_next <= regy_12;
			WHEN "1101" => ry_read_next <= regy_13;
			WHEN "1110" => ry_read_next <= regy_14;
			WHEN "1111" => ry_read_next <= regy_15;
			WHEN OTHERS => ry_read_next <= "XXXXXXXXXXXXXXXX";
		END CASE;
	
	end if;

	end process RY_READ_PROC;
	
	
	
	RZ_READ_PROC: process(reset, rz_addr, 
						regz_0,  regz_1, regz_2, regz_3, regz_4, regz_5, regz_6, regz_7, 
						regz_8, regz_9, regz_10, regz_11, regz_12, regz_13, regz_14, regz_15)
	begin
	
	if reset = '0' then
	
		rz_read_next <= (others => '0');
	else
	
		CASE rz_addr IS
			WHEN "0000" => rz_read_next <= regz_0;
			WHEN "0001" => rz_read_next <= regz_1;
			WHEN "0010" => rz_read_next <= regz_2;
			WHEN "0011" => rz_read_next <= regz_3;
			WHEN "0100" => rz_read_next <= regz_4;
			WHEN "0101" => rz_read_next <= regz_5;
			WHEN "0110" => rz_read_next <= regz_6;
			WHEN "0111" => rz_read_next <= regz_7;
			WHEN "1000" => rz_read_next <= regz_8;
			WHEN "1001" => rz_read_next <= regz_9;
			WHEN "1010" => rz_read_next <= regz_10;
			WHEN "1011" => rz_read_next <= regz_11;
			WHEN "1100" => rz_read_next <= regz_12;
			WHEN "1101" => rz_read_next <= regz_13;
			WHEN "1110" => rz_read_next <= regz_14;
			WHEN "1111" => rz_read_next <= regz_15;
			WHEN OTHERS => rz_read_next <= "XXXXXXXXXXXXXXXX";
		END CASE;
	
	end if;

	end process RZ_READ_PROC;

  

end register_file_rtl;

