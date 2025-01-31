LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Vending_Machine_TB IS

END Vending_Machine_TB;

ARCHITECTURE behavior OF Vending_Machine_TB IS

    COMPONENT Vending_Machine
    PORT(
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        coin_input : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        item_selection : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        item_available : IN STD_LOGIC;
        balance_display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        change_return : OUT INTEGER;
        dispense_signal : OUT STD_LOGIC;
        error_signal : OUT STD_LOGIC
    );
    END COMPONENT;

    SIGNAL clk: STD_LOGIC := '0';
    SIGNAL reset: STD_LOGIC := '0';
    SIGNAL coin_input: STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL item_selection: STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL item_available: STD_LOGIC;
    SIGNAL balance_display: STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL change_return: INTEGER;
    SIGNAL dispense_signal: STD_LOGIC;
    SIGNAL error_signal: STD_LOGIC;

    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    uut: Vending_Machine
    PORT MAP (
        clk => clk,
        reset => reset,
        coin_input => coin_input,
        item_selection => item_selection,
        item_available => item_available,
        balance_display => balance_display,
        change_return => change_return,
        dispense_signal => dispense_signal,
        error_signal => error_signal
    );

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    stim_proc: PROCESS
    BEGIN

        reset <= '1';
        coin_input <= "00"; -- No coin
        item_selection <= "00"; -- No item selected
        item_available <= '1'; -- Item is available

        WAIT FOR clk_period * 2;  -- Wait for two clock cycles

        -- Release reset
        reset <= '0';
        WAIT FOR clk_period;

        -- Test inserting different coins
        coin_input <= "01"; -- Insert 1 unit
        WAIT FOR clk_period;

        coin_input <= "10"; -- Insert 5 units
        WAIT FOR clk_period;

        coin_input <= "11"; -- Insert 10 units
        WAIT FOR clk_period;

        -- Test selecting an item
        item_selection <= "00"; -- Select item A
        WAIT FOR clk_period;

        -- Assume the item is available
        item_available <= '1'; -- set item as available
        WAIT FOR clk_period;

        -- Dispense item
        item_selection <= "10"; -- Select item C
        WAIT FOR clk_period;

        -- Check balance display and signals
        WAIT FOR clk_period * 5;  -- Wait to observe the dispense and signals

        ASSERT FALSE REPORT "End of Testbench" SEVERITY note;

        WAIT;
    END PROCESS;

END behavior;