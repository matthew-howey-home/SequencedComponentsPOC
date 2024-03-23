library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SlowClockGenerator is
    port (
        FastClock   : in std_logic;
        SlowClock   : out std_logic;
		  InputEnable : out std_logic
    );
end entity SlowClockGenerator;

architecture Behavioral of SlowClockGenerator is
    signal counter : natural := 0;
    signal slowClockInternal : std_logic := '0';
	 signal inputEnableInternal : std_logic := '0';
    constant switchInputEnableHigh : natural := 75000000;
	 constant switchClockHigh : natural := 100000000;
	 constant switchInputEnableLow : natural := 125000000;
	 constant switchClockLow : natural := 200000000;

begin
    process(FastClock)
    begin
        if rising_edge(FastClock) then
            counter <= counter + 1;
            if counter = switchInputEnableHigh then      
                inputEnableInternal <= '1';
				elsif counter = switchClockHigh then      
                slowClockInternal <= '1';
				elsif counter = switchInputEnableLow then
					 inputEnableInternal <= '0';
				elsif counter = switchClockLow then
				    slowClockInternal <= '0';
					 counter <= 0;
            end if;
        end if;
    end process;

    SlowClock <= slowClockInternal;
	 InputEnable <= inputEnableInternal;
	 

end architecture Behavioral;