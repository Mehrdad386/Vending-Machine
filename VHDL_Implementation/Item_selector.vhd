LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Item_Selector IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        item_selection : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        item_available : IN STD_LOGIC;
        item_price : OUT INTEGER;
        out_of_stock_signal : OUT STD_LOGIC
    );
END Item_Selector;

ARCHITECTURE Behavioral OF Item_Selector IS
BEGIN
    PROCESS (reset, clk)
    BEGIN
        IF reset = '1' THEN
            item_price <= 0;
            out_of_stock_signal <= '0';
        ELSIF rising_edge(clk) THEN
            IF item_available = '1' THEN
                CASE item_selection IS
                    WHEN "00" =>
                        item_price <= 5; -- item A
                        out_of_stock_signal <= '0';
                    WHEN "01" =>
                        item_price <= 7; -- item B
                        out_of_stock_signal <= '0';
                    WHEN "10" =>
                        item_price <= 10; -- item C
                        out_of_stock_signal <= '0';
                    WHEN OTHERS =>
                        item_price <= 0;
                        out_of_stock_signal <= '1';
                END CASE;
            ELSE
                item_price <= 0;
                out_of_stock_signal <= '1'; -- Not available
            END IF;
        END IF;
    END PROCESS;

END Behavioral;