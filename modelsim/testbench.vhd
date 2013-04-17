library ieee;
use ieee.std_logic_1164.all;


entity testbench is
end testbench;

architecture arch1 of testbench is

	component mbs_vulom_recv
		port (
			CLK						 : in	 std_logic;
			RESET_IN			 : in	 std_logic;
			MBS_IN				 : in	 std_logic;
			CLK_200				 : in	 std_logic;
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
	signal MBS_IN					: std_logic;
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
  signal CLK : std_logic := '1';
	signal CLK_200				: std_logic := '1';
	signal CLK_50				: std_logic := '1';	
begin  -- arch1

	-- component instantiation
	DUT: mbs_vulom_recv
		port map (
			CLK						 => CLK,
			RESET_IN			 => RESET_IN,
			MBS_IN				 => MBS_IN,
			CLK_200				 => CLK_200,
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
	CLK <= not CLK after 5 ns;
	CLK_200 <= not CLK_200 after 2.5 ns;
	CLK_50 <= not CLK_50 after 10 ns;
  -- waveform generation
  --WaveGen_Proc: process
  --begin
  --  -- insert signal assignments here
	--  RESET_IN <= '0';
  --  wait until CLK = '1';
  --end process WaveGen_Proc;

	
	process
		variable data : std_logic_vector(0 to 36) := b"01010"
		                                                 & b"00100000"
		                                                 & b"00000000"
		                                                 & b"00000000"
		                                                 & b"11" & b"1"
		                                                 & b"10101";
		variable i : integer := 0;
		variable cnt : integer := 10;
	begin
		wait until rising_edge(CLK_50);
		MBS_IN <= '1';
		if i < data'length and cnt = 0 then
			MBS_IN <= data(i);
			i := i+1;
		else
			cnt := cnt-1;
		end if;
	end process;

	
	process
	begin
		wait until rising_edge(CLK);
		RESET_IN <= '0';
		TRIGGER_IN <= '0';
		CONTROL_REG_IN <= x"00000000";
		if TRG_SYNC_OUT = '1' then
			TRIGGER_IN <= '1';
		end if;	
			
	end process;
	
	
end arch1;
