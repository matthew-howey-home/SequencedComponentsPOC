library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SequencedComponentsPOC is
	Port (
		DATA_INPUT		: in std_logic;

		POWER				: out std_logic;
		INTERNAL_LED_0	: out std_logic;
		INTERNAL_LED_1	: out std_logic;
		INTERNAL_LED_2	: out std_logic;
		INTERNAL_LED_3 : out std_logic;
		INTERNAL_LED_4 : out std_logic;
		INTERNAL_LED_5 : out std_logic;
		INTERNAL_LED_6 : out std_logic;
		INTERNAL_LED_7 : out std_logic
	);
end SequencedComponentsPOC;

architecture Behavioral of SequencedComponentsPOC is

signal connected_to_oscena	: std_logic;
signal fast_clock				: std_logic;
signal slow_clock				: std_logic;
signal input_enable			: std_logic;
signal register_output		: std_logic_vector(7 downto 0);
signal register_input		: std_logic_vector(7 downto 0);
signal add_carry_out			: std_logic;

component Internal_Oscillator is
	port (
		clkout : out std_logic;
		oscena : in  std_logic
	);
end component Internal_Oscillator;

component SlowClockGenerator is
	port (
		FastClock   : in std_logic;
		SlowClock   : out std_logic;
		InputEnable : out std_logic
	);
end component SlowClockGenerator;

component Eight_Bit_Register is
	port (
		Data_Input		: in std_logic_vector(7 downto 0);
		Input_Enable	: in std_logic;
		Clock				: in std_logic;
		Output_Enable	: in std_logic;

      Output			: out std_logic_vector(7 downto 0)
	);
end component Eight_Bit_Register;

component ADD_Component is
	port (
		input_1		: in std_logic_vector(7 downto 0);
		input_2		: in std_logic_vector(7 downto 0);
		carry_in		: in std_logic;
		output		: out std_logic_vector(7 downto 0);
      carry_out	: out std_logic
	);
end component ADD_Component;


begin
	POWER <= '1';
	
	-- we always want to be connected to oscena (the internal oscillator)
	connected_to_oscena <= '1';
	
	Internal_Oscillator_Instance : Internal_Oscillator
		port map (
			clkout => fast_clock,
			oscena => connected_to_oscena
		);

	SlowClockGeneratorInstance : SlowClockGenerator
		port map (
			FastClock	=>	fast_clock,
			InputEnable	=>	input_enable,
			SlowClock	=>	slow_clock
		);

	Eight_Bit_Register_Instance : Eight_Bit_Register
		port map (
			Data_Input		=> register_input,
			Input_Enable	=> input_enable,
			Clock				=> slow_clock,
			Output_Enable	=> '1',

			Output			=> register_output
		);
		
	ADD_Component_Instance : ADD_Component
		port map (
			input_1		=> register_output,
			input_2		=> "00000001",
			carry_in		=> '0',
			
			output		=> register_input,
			carry_out	=> add_carry_out
		);
			

	-- all outputs inverted as 0 is lit and 1 is unlit
	INTERNAL_LED_0 <= not register_output(0);
	INTERNAL_LED_1 <= not register_output(1);
	INTERNAL_LED_2 <= not register_output(2);
	INTERNAL_LED_3 <= not register_output(3);
	INTERNAL_LED_4 <= not register_output(4);
	INTERNAL_LED_5 <= not register_output(5);
	INTERNAL_LED_6 <= not register_output(6);
	INTERNAL_LED_7 <= not register_output(7);
	
end Behavioral;
