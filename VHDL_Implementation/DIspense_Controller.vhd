LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Dispense_Controller IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        balance : IN INTEGER;
        item_price : IN INTEGER;
        new_order_request : IN STD_LOGIC; --for extra item
        dispense_signal : OUT STD_LOGIC;
        error_signal : OUT STD_LOGIC;
        change_return : OUT INTEGER
    );
END Dispense_Controller;

ARCHITECTURE Behavioral OF Dispense_Controller IS
BEGIN
    PROCESS (reset, clk)
    BEGIN
        IF reset = '1' THEN
            dispense_signal <= '0';
            change_return <= 0;
            error_signal <= '0';
        ELSIF rising_edge(clk) THEN
            IF new_order_request = '1' THEN
                dispense_signal <= '0'; 
                
                IF balance < item_price THEN
                    error_signal <= '1';
                ELSE
                    error_signal <= '0';
                END IF;
            ELSIF balance >= item_price AND item_price > 0 THEN
                dispense_signal <= '1';
                change_return <= balance - item_price;
                error_signal <= '0';
            ELSE
                dispense_signal <= '0';
                IF balance < item_price THEN
                    error_signal <= '1';
                ELSE
                    error_signal <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;