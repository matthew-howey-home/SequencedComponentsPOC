library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SequencedComponentsPOC is
	Port (
		POWER : out STD_LOGIC
	);
end SequencedComponentsPOC;

architecture Behavioral of SequencedComponentsPOC is
component Internal_Oscillator is
	port (
		clkout : out std_logic;
		oscena : in  std_logic
	);
end component Internal_Oscillator;

begin
	POWER <= '1';
end Behavioral;
