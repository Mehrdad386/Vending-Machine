LIBRARY IEEE;  
USE IEEE.std_logic_1164.ALL;  
USE IEEE.numeric_std.ALL;  

ENTITY Vending_Machine_TB IS  
END Vending_Machine_TB;  

ARCHITECTURE behavior OF Vending_Machine_TB IS   

    -- Component Declaration for the Unit Under Test (UUT)  
    COMPONENT Vending_Machine  
    PORT(  
         clk : IN  std_logic;  
         reset : IN  std_logic;  
         coin_input : IN  std_logic_vector(1 downto 0);  
         item_selection : IN  std_logic_vector(1 downto 0);  
         item_available : IN  std_logic;  
         balance_display : OUT  std_logic_vector(6 downto 0);  
         change_return : OUT  integer;  
         dispense_signal : OUT  std_logic;  
         error_signal : OUT  std_logic  
    );  
    END COMPONENT;  

    -- Inputs  
    signal clk : std_logic := '0';  
    signal reset : std_logic := '0';  
    signal coin_input : std_logic_vector(1 downto 0) := (others => '0');  
    signal item_selection : std_logic_vector(1 downto 0) := (others => '0');  
    signal item_available : std_logic := '0';  

    -- Outputs  
    signal balance_display : std_logic_vector(6 downto 0);  
    signal change_return : integer;  
    signal dispense_signal : std_logic;  
    signal error_signal : std_logic;  

    -- Clock period definition  
    constant clk_period : time := 10 ns;  

BEGIN  

    -- Instantiate the Unit Under Test (UUT)  
    uut: Vending_Machine PORT MAP (  
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

    -- Clock generation  
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
        
        -- Reset  
        reset <= '1';  
        wait for clk_period*2;  
        reset <= '0';  
        
        -- Test Scenario 1: Insert a coin of 1  
        coin_input <= "00";  -- Insert coin of value 1  
        wait for clk_period;        
        assert (balance_display = "0000001") report "Balance should be 1" severity error;  

        -- Test Scenario 2: Insert a coin of 5  
        coin_input <= "01";  -- Insert coin of value 5  
        wait for clk_period;        
        assert (balance_display = "0000010") report "Balance should be 6" severity error;   

        -- Test Scenario 3: Insert a coin of 10  
        coin_input <= "11";  -- Insert coin of value 10        
        wait for clk_period;        
        assert (balance_display = "0000010") report "Balance should be 16" severity error;   

        -- Test Scenario 4: Select Item A (price 5)  
        item_available <= '1';   
        item_selection <= "00";  -- Select item A  
        wait for clk_period;        
        assert (dispense_signal = '1') report "Dispense signal should be high" severity error;  
        wait for clk_period;        
        assert (change_return = 11) report "Change should be 11" severity error;  

        -- Test Scenario 5: Select Item B (price 7)  
        item_selection <= "01";  -- Select item B  
        wait for clk_period;        
        assert (dispense_signal = '1') report "Dispense signal should be high" severity error;  
        wait for clk_period;        
        assert (change_return = 4) report "Change should be 4" severity error;   

        -- Test Scenario 6: Select Item C (price 10)  
        item_selection <= "10";  -- Select item C  
        wait for clk_period;        
        assert (dispense_signal = '1') report "Dispense signal should be high" severity error;  
        wait for clk_period;        
        assert (change_return = -6) report "Change should be -6 (error condition)" severity warning;   
        
        -- Test Scenario 7: Attempt to select an invalid item  
        item_selection <= "11";  -- Invalid item selection  
        wait for clk_period;        
        assert (dispense_signal = '0') report "Dispense signal should be low for invalid selection" severity error;  

        -- Test Scenario 8: Insert insufficient coins to buy item A  
        item_available <= '1';   
        item_selection <= "00";  -- Select item A  
        coin_input <= "11";  -- Insert coin of value 10  
        wait for clk_period;        
        assert (dispense_signal = '0') report "Dispense signal should be low due to insufficient balance" severity error;  

        -- Finish simulation  
        wait;  
    end process;  

END behavior;