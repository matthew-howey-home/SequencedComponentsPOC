library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SequencedComponentsPOC is
    Port (
		  POWER : out STD_LOGIC
    );
end SequencedComponentsPOC;

architecture Behavioral of SequencedComponentsPOC is
begin
	 POWER <= '1';
end Behavioral;
