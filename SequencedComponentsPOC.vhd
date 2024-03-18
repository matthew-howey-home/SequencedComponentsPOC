library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SequencedComponentsPOC is
	Port (
		POWER : out STD_LOGIC
	);
end SequencedComponentsPOC;

architecture Behavioral of SequencedComponentsPOC is

signal connected_to_oscena	: std_logic;
signal fast_clock				: std_logic;

component Internal_Oscillator is
	port (
		clkout : out std_logic;
		oscena : in  std_logic
	);
end component Internal_Oscillator;

begin
	POWER <= '1';
	
	-- we always want to be connected to oscena (the internal oscillator)
	connected_to_oscena <= '1';
	
	Internal_Oscillator_Instance : Internal_Oscillator
		port map (
			clkout => fast_clock,
			oscena => connected_to_oscena
      );

end Behavioral;
