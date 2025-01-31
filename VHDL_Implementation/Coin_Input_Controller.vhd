LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Coin_Input_Controller IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        coin_input : IN STD_LOGIC_VECTOR (1 DOWNTO 0); --(1, 5, 10)  
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
            CASE coin_input IS
                WHEN "00" =>
                    IF (internal_balance + 1) < 128 THEN
                        internal_balance <= internal_balance + 1;
                    END IF;
                WHEN "01" =>
                    IF (internal_balance + 5) < 128 THEN
                        internal_balance <= internal_balance + 5;
                    END IF;
                WHEN "11" =>
                    IF (internal_balance + 10) < 128 THEN
                        internal_balance <= internal_balance + 10;
                    END IF;
                WHEN OTHERS => NULL;
            END CASE;
        END IF;
    END PROCESS;

    -- Assign internal_balance to balance output
    balance <= internal_balance;

END Behavioral;