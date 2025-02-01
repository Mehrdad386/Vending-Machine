LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Vending_Machine IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        coin_input : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- 1,5,10  
        item_selection : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- A, B, C  
        item_available : IN STD_LOGIC; -- assume as control elsewhere  
        new_order_request : IN STD_LOGIC; -- extra order
        balance_display : OUT STD_LOGIC_VECTOR (6 DOWNTO 0); -- two seven segments  
        change_return : OUT INTEGER; -- amount of the change  
        dispense_signal : OUT STD_LOGIC; -- signal for dispense  
        error_signal : OUT STD_LOGIC -- signal for error  
    );
    SIGNAL balance : INTEGER;
    SIGNAL item_price : INTEGER;
    SIGNAL dispense_sig : STD_LOGIC;
    SIGNAL error_sig : STD_LOGIC;
END Vending_Machine;

ARCHITECTURE Structural OF Vending_Machine IS
BEGIN
    Coin_input_Controller : ENTITY work.Coin_Input_Controller
        PORT MAP(
            clk => clk,
            reset => reset,
            coin_input => coin_input,
            balance => balance
        );

    Item_Selector : ENTITY work.Item_Selector
        PORT MAP(
            clk => clk,
            reset => reset,
            item_selection => item_selection,
            item_available => item_available,
            item_price => item_price
        );

    Dispense_Controller : ENTITY work.Dispense_Controller
        PORT MAP(
            clk => clk,
            reset => reset,
            balance => balance,
            item_price => item_price,
            new_order_request => new_order_request,
            dispense_signal => dispense_sig,
            error_signal => error_sig,
            change_return => change_return
        );

    dispense_signal <= dispense_sig;
    error_signal <= error_sig;

    PROCESS(clk, reset)
    BEGIN
        IF reset = '1' THEN
            balance_display <= (others => '0');
        ELSIF rising_edge(clk) THEN
            IF balance < 128 THEN
                balance_display <= STD_LOGIC_VECTOR(to_unsigned(balance, balance_display'length));
            ELSE
                balance_display <= (others => '0');
            END IF;
        END IF;
    END PROCESS;

END Structural;