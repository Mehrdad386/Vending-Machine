LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_Vending_Machine IS
END tb_Vending_Machine;

ARCHITECTURE behavior OF tb_Vending_Machine IS

    COMPONENT Vending_Machine
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            coin_input : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            item_selection : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            item_available : IN STD_LOGIC;
            new_order_request : IN STD_LOGIC;
            balance_display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            change_return : OUT INTEGER;
            dispense_signal : OUT STD_LOGIC;
            error_signal : OUT STD_LOGIC;
            out_of_stock_signal : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Inputs
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '1';
    SIGNAL coin_input : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL item_selection : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL item_available : STD_LOGIC := '0';
    SIGNAL new_order_request : STD_LOGIC := '0';

    -- Outputs
    SIGNAL balance_display : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL change_return : INTEGER;
    SIGNAL dispense_signal : STD_LOGIC;
    SIGNAL error_signal : STD_LOGIC;
    SIGNAL out_of_stock_signal : STD_LOGIC;

    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    uut : Vending_Machine PORT MAP(
        clk => clk,
        reset => reset,
        coin_input => coin_input,
        item_selection => item_selection,
        item_available => item_available,
        new_order_request => new_order_request,
        balance_display => balance_display,
        change_return => change_return,
        dispense_signal => dispense_signal,
        error_signal => error_signal,
        out_of_stock_signal => out_of_stock_signal
    );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Hold reset state for a while
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';

        -- Scenario 1: Insert coins and buy item A (price 5)
        coin_input <= "01"; -- Insert 1 unit
        WAIT FOR clk_period;
        coin_input <= "10"; -- Insert 5 units
        WAIT FOR clk_period;

        -- Request item A (available)
        item_available <= '1';
        item_selection <= "00"; -- Select item A
        WAIT FOR clk_period;

        -- Check if item A was dispensed
        WAIT FOR clk_period; -- Wait for dispensing

        -- Scenario 2: Not enough balance for item B (price 7)
        new_order_request <= '1'; -- Request new order
        WAIT FOR clk_period;
        new_order_request <= '0'; -- Reset new order request

        coin_input <= "00"; -- Insert 1 unit (balance = 1)
        WAIT FOR clk_period;
        item_selection <= "01"; -- Select item B
        WAIT FOR clk_period; -- Should trigger error signal

        -- Scenario 3: Insert enough coins and buy item B
        coin_input <= "01"; -- Insert 1 unit (balance = 2)
        WAIT FOR clk_period;
        coin_input <= "10"; -- Insert 5 units (balance = 7)
        WAIT FOR clk_period;

        item_selection <= "01"; -- Select item B
        WAIT FOR clk_period; -- Should dispense item B

        -- Scenario 4: Out of stock for item C
        new_order_request <= '1'; -- Request new order
        WAIT FOR clk_period;
        new_order_request <= '0'; -- Reset new order request

        item_available <= '0'; -- Item C is not available
        coin_input <= "01"; -- Insert 1 unit
        WAIT FOR clk_period;
        coin_input <= "10"; -- Insert 5 units
        WAIT FOR clk_period;

        item_selection <= "10"; -- Request item C (which is out of stock)
        WAIT FOR clk_period; -- Should trigger error signal
        -- Scenario 5: Buy item C after it becomes available
        item_available <= '1'; -- Now item C is available
        WAIT FOR clk_period;

        item_selection <= "10"; -- Select item C
        WAIT FOR clk_period; -- Should dispense item C

        -- Scenario 6: Repeat new order for item A and have  balance
        new_order_request <= '1'; -- Request new order
        WAIT FOR clk_period;
        new_order_request <= '0'; -- Reset new order request

        coin_input <= "10"; -- Insert 5 units
        WAIT FOR clk_period;
        coin_input <= "01"; -- Insert 1 unit
        WAIT FOR clk_period;

        item_selection <= "00"; -- Select item A again
        WAIT FOR clk_period; -- Should dispense item A

        -- Finish the simulation
        WAIT;
    END PROCESS;

END behavior;