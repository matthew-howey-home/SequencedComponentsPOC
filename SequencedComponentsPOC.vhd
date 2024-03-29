library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SequencedComponentsPOC is
    Port (
		  RESET				: in STD_LOGIC;
		
		  INTERNAL_LED_0 : out STD_LOGIC;
        INTERNAL_LED_1 : out STD_LOGIC;
		  INTERNAL_LED_2 : out STD_LOGIC;
		  INTERNAL_LED_3 : out STD_LOGIC;
		  INTERNAL_LED_4 : out STD_LOGIC;
		  INTERNAL_LED_5 : out STD_LOGIC;
		  INTERNAL_LED_6 : out STD_LOGIC;
		  INTERNAL_LED_7 : out STD_LOGIC;

		  POWER : out STD_LOGIC
    );
end SequencedComponentsPOC;

architecture Behavioral of SequencedComponentsPOC is

	component Internal_Oscillator is
		port (
			clkout : out std_logic;        -- clk
			oscena : in  std_logic			 -- oscena
		);
	end component Internal_Oscillator;

	signal fast_clock : std_logic;
   signal connected_to_oscena : std_logic;
	signal slow_clock				: std_logic;
	signal input_enable			: std_logic;
	
	signal register_output		: std_logic_vector(7 downto 0);
	signal register_input	   : std_logic_vector(7 downto 0);
	signal add_output				: std_logic_vector(7 downto 0);
	signal add_carry_out			: std_logic;
	
begin
	connected_to_oscena <= '1';
	
	Internal_Oscillator_Instance : Internal_Oscillator
		port map (
			clkout => fast_clock,
			oscena => connected_to_oscena
		);
	
	SlowClockGenerator: entity work.SlowClockGenerator
	port map (
		  FastClock	=> fast_clock,
		  SlowClock => slow_clock,
		  InputEnable => input_enable
   );
	
	Eight_Bit_Register: entity work.Eight_Bit_Register
	port map (
		  Data_Input	 => register_input,
        Input_Enable	 => input_enable,
		  Clock		    => slow_clock,
		  Output_Enable => '1',
        Output		    => register_output 
   );
	
	ADD_Component: entity work.ADD_Component
	port map (
		  input_1	=> register_output,
        input_2	=> "00000001",
		  carry_in	=> '0',
		  output => add_output,
        -- output		=> register_input,
		  carry_out  => add_carry_out
   );
	
	Two_To_One_Byte_Mux: entity work.Two_To_One_Byte_Mux
	port map (
		input_1	 		=> add_output,
		input_2		 	=> "00000000",
      
		selector	 		=> RESET,
		
		output			=> register_input
   );
	

	 POWER <= '1';
	 
	 -- all outputs are inverted as for some stupid reason someone thought it was a good idea to have the LED lit for 0 and off for 1.
	 INTERNAL_LED_0 <= not register_output(0);
	 INTERNAL_LED_1 <= not register_output(1);
	 INTERNAL_LED_2 <= not register_output(2);
	 INTERNAL_LED_3 <= not register_output(3);
	 INTERNAL_LED_4 <= not register_output(4);
	 INTERNAL_LED_5 <= not register_output(5);
	 INTERNAL_LED_6 <= not register_output(6);
	 INTERNAL_LED_7 <= not register_output(7);
	 -- INTERNAL_LED_7 <= not RESET; 

end Behavioral;
