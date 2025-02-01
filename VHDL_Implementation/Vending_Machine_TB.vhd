LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_Vending_Machine IS
END tb_Vending_Machine;

ARCHITECTURE behavior OF tb_Vending_Machine IS 

    COMPONENT Vending_Machine
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         coin_input : IN  std_logic_vector(1 downto 0);
         item_selection : IN  std_logic_vector(1 downto 0);
         item_available : IN  std_logic;
         new_order_request : IN  std_logic;
         balance_display : OUT  std_logic_vector(6 downto 0);
         change_return : OUT  INTEGER;
         dispense_signal : OUT  std_logic;
         error_signal : OUT  std_logic
        );
    END COMPONENT;

    -- Inputs
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal coin_input : std_logic_vector(1 downto 0) := (others => '0');
    signal item_selection : std_logic_vector(1 downto 0) := (others => '0');
    signal item_available : std_logic := '0';
    signal new_order_request : std_logic := '0';

    -- Outputs
    signal balance_display : std_logic_vector(6 downto 0);
    signal change_return : INTEGER;
    signal dispense_signal : std_logic;
    signal error_signal : std_logic;

    constant clk_period : time := 10 ns;

BEGIN

    uut: Vending_Machine PORT MAP (
          clk => clk,
          reset => reset,
          coin_input => coin_input,
          item_selection => item_selection,
          item_available => item_available,
          new_order_request => new_order_request,
          balance_display => balance_display,
          change_return => change_return,
          dispense_signal => dispense_signal,
          error_signal => error_signal
        );

    -- Clock process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Hold reset state for a while
        reset <= '1';
        wait for 20 ns;  
        reset <= '0';
        
        -- Scenario 1: Insert coins and buy item A (price 5)
        coin_input <= "01";  -- Insert 1 unit
        wait for clk_period;
        coin_input <= "10";  -- Insert 5 units
        wait for clk_period;

        -- Request item A (available)
        item_available <= '1';  
        item_selection <= "00";  -- Select item A
        wait for clk_period;

        -- Check if item A was dispensed
        wait for clk_period;  -- Wait for dispensing

        -- Scenario 2: Not enough balance for item B (price 7)
        new_order_request <= '1';  -- Request new order
        wait for clk_period;
        new_order_request <= '0';   -- Reset new order request
        
        coin_input <= "00";  -- Insert 1 unit (balance = 1)
        wait for clk_period;
        item_selection <= "01";  -- Select item B
        wait for clk_period;  -- Should trigger error signal

        -- Scenario 3: Insert enough coins and buy item B
        coin_input <= "01";  -- Insert 1 unit (balance = 2)
        wait for clk_period;
        coin_input <= "10";  -- Insert 5 units (balance = 7)
        wait for clk_period;

        item_selection <= "01";  -- Select item B
        wait for clk_period;  -- Should dispense item B

        -- Scenario 4: Out of stock for item C
        new_order_request <= '1';  -- Request new order
        wait for clk_period;
        new_order_request <= '0';   -- Reset new order request

        item_available <= '0';  -- Item C is not available
        coin_input <= "01";  -- Insert 1 unit
        wait for clk_period;
        coin_input <= "10";  -- Insert 5 units
        wait for clk_period;

        item_selection <= "10";  -- Request item C (which is out of stock)
        wait for clk_period;  -- Should trigger error signal

        -- Scenario 5: Buy item C after it becomes available
        item_available <= '1';  -- Now item C is available
        wait for clk_period;

        item_selection <= "10";  -- Select item C
        wait for clk_period;  -- Should dispense item C

        -- Scenario 6: Repeat new order for item A and have sufficient balance
        new_order_request <= '1';  -- Request new order
        wait for clk_period;
        new_order_request <= '0';   -- Reset new order request

        coin_input <= "10";  -- Insert 5 units
        wait for clk_period;  
        coin_input <= "01";  -- Insert 1 unit
        wait for clk_period;  

        item_selection <= "00";  -- Select item A again
        wait for clk_period;  -- Should dispense item A

        -- Finish the simulation
        wait;
    end process;

END behavior;