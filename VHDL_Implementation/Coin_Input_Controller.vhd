LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY Coin_Input_Controller IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        coin_input : IN STD_LOGIC_VECTOR (1 DOWNTO 0); --(1,5,10)
        balance : OUT INTEGER
    );

END Coin_Input_Controller;
ARCHITECTURE Behavioral OF Coin_Input_Controller IS
    SIGNAL internal_balance : INTEGER := 0;
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            internal_balance <= 0;
        ELSIF rising_edge(clk) THEN
            CASE Coin_Input IS
                WHEN "01" => internal_balance <= internal_balance + 1;
                WHEN "10" => internal_balance <= internal_balance + 5;
                WHEN "11" => internal_balance <= internal_balance + 10;
                WHEN OTHERS => NULL;
            END CASE;
        END IF;
        balance <= internal_balance;
    END PROCESS;

END Behavioral;