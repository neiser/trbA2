-------------------------------------------------------------------------------
-- Title      : Testbench for design "EventIDSerialReceiver"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : EventIDSerialReceiver_tb.vhd
-- Author     : Andreas Neiser  <neiser@normandy>
-- Company    : 
-- Created    : 2013-04-17
-- Last update: 2013-04-17
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-04-17  1.0      neiser	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity EventIDSerialReceiver_tb is

end EventIDSerialReceiver_tb;

-------------------------------------------------------------------------------

architecture arch1 of EventIDSerialReceiver_tb is

	component EventIDSerialReceiver
		port (
			clock							 : in	 std_logic;
			SerialIn					 : in	 std_logic;
			OutputUserEventID	 : out std_logic_vector(31 downto 0);
			ResetSenderCounter : in	 std_logic;
			DebugOut					 : out std_logic_vector(5 downto 0));
	end component;

	-- component ports
	signal SerialIn						: std_logic;
	signal OutputUserEventID	: std_logic_vector(31 downto 0);
	signal ResetSenderCounter : std_logic;
	signal DebugOut						: std_logic_vector(5 downto 0);

  -- clock
  signal Clk : std_logic := '1';
	signal Clk_Serial : std_logic := '1';
begin  -- arch1

	-- component instantiation
	DUT: EventIDSerialReceiver
		port map (
			clock							 => clk,
			SerialIn					 => SerialIn,
			OutputUserEventID	 => OutputUserEventID,
			ResetSenderCounter => ResetSenderCounter,
			DebugOut					 => DebugOut);

  -- clock generation
	Clk <= not Clk after 5 ns; -- should be 100 Mhz
	Clk_Serial <= not Clk_Serial after 40 ns; -- serial runs at 12.5 MHz?
	

	process
		variable data : std_logic_vector(0 to 34) := b"1" & x"00909090"
		                                             & b"01";
		variable i : integer := 0;
		variable cnt : integer := 10;
	begin
		wait until rising_edge(Clk_Serial);
		SerialIn <= '0';
		if i < data'length and cnt = 0 then
			SerialIn <= data(i);
			i := i+1;
		else
			cnt := cnt-1;
		end if;
	end process;
	
	process
	begin
		wait until rising_edge(CLK);
		ResetSenderCounter <= '0';
	end process;
	
	

end arch1;

