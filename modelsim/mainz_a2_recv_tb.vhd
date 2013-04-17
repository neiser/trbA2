-------------------------------------------------------------------------------
-- Title      : Testbench for design "mainz_a2_recv"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : mainz_a2_recv_tb.vhd
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

entity mainz_a2_recv_tb is

end mainz_a2_recv_tb;

-------------------------------------------------------------------------------

architecture arch1 of mainz_a2_recv_tb is

	component mainz_a2_recv
		port (
			CLK						 : in	 std_logic;
			RESET_IN			 : in	 std_logic;
			SERIAL_IN			 : in	 std_logic;
			EXT_TRG_IN		 : in	 std_logic;
			TRG_ASYNC_OUT	 : out std_logic;
			TRG_SYNC_OUT	 : out std_logic;
			TRIGGER_IN		 : in	 std_logic;
			DATA_OUT			 : out std_logic_vector(31 downto 0);
			WRITE_OUT			 : out std_logic;
			STATUSBIT_OUT	 : out std_logic_vector(31 downto 0);
			FINISHED_OUT	 : out std_logic;
			CONTROL_REG_IN : in	 std_logic_vector(31 downto 0);
			STATUS_REG_OUT : out std_logic_vector(31 downto 0) := (others => '0');
			DEBUG					 : out std_logic_vector(31 downto 0));
	end component;

	-- component ports
	signal RESET_IN				: std_logic;
	signal SERIAL_IN			: std_logic;
	signal EXT_TRG_IN			: std_logic;
	signal TRG_ASYNC_OUT	: std_logic;
	signal TRG_SYNC_OUT		: std_logic;
	signal TRIGGER_IN			: std_logic;
	signal DATA_OUT				: std_logic_vector(31 downto 0);
	signal WRITE_OUT			: std_logic;
	signal STATUSBIT_OUT	: std_logic_vector(31 downto 0);
	signal FINISHED_OUT		: std_logic;
	signal CONTROL_REG_IN : std_logic_vector(31 downto 0);
	signal STATUS_REG_OUT : std_logic_vector(31 downto 0) := (others => '0');
	signal DEBUG					: std_logic_vector(31 downto 0);

  -- clock
	signal Clk : std_logic := '1';
	signal Clk_Serial : std_logic := '1';

begin  -- arch1

	-- component instantiation
	DUT: mainz_a2_recv
		port map (
			CLK						 => CLK,
			RESET_IN			 => RESET_IN,
			SERIAL_IN			 => SERIAL_IN,
			EXT_TRG_IN		 => EXT_TRG_IN,
			TRG_ASYNC_OUT	 => TRG_ASYNC_OUT,
			TRG_SYNC_OUT	 => TRG_SYNC_OUT,
			TRIGGER_IN		 => TRIGGER_IN,
			DATA_OUT			 => DATA_OUT,
			WRITE_OUT			 => WRITE_OUT,
			STATUSBIT_OUT	 => STATUSBIT_OUT,
			FINISHED_OUT	 => FINISHED_OUT,
			CONTROL_REG_IN => CONTROL_REG_IN,
			STATUS_REG_OUT => STATUS_REG_OUT,
			DEBUG					 => DEBUG);

	-- clock generation
	Clk <= not Clk after 5 ns; -- should be 100 Mhz
	Clk_Serial <= not Clk_Serial after 40 ns; -- serial runs at 12.5 MHz?

	process
		variable data : std_logic_vector(0 to 34) := b"1" & x"00700000"
		                                             & b"11";
		variable i : integer := 0;
		variable cnt : integer := 50;
	begin
		wait until rising_edge(Clk_Serial);
		SERIAL_IN <= '0';
		if i < data'length and cnt = 0 then
			SERIAL_IN <= data(i);
			i := i+1;
		else
			cnt := cnt-1;
		end if;
	end process;
	
	process
	begin
		wait until rising_edge(CLK);
		RESET_IN <= '0';
	end process;


	process
	begin
		wait until rising_edge(CLK);
		EXT_TRG_IN <= '0';
		TRIGGER_IN <= '0';
		CONTROL_REG_IN <= x"00000000";

		-- send a trigger async
		wait for 2 ns;
		EXT_TRG_IN <= '1';
		wait for 30 ns;
		EXT_TRG_IN <= '0';

		-- trigger the read out after some time
		wait for 100 ns;
		wait until rising_edge(CLK);
		TRIGGER_IN <= '1';
		wait until rising_edge(CLK);
		TRIGGER_IN <= '0';
		wait;
	end process;

	
end arch1;

