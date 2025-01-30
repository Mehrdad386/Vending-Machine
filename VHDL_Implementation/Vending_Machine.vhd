LIBRARY library IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Vending_Machine IS
    PORT (
        clk : in std_logic ;
        reset : in std_logic ;
        coin_input : in std_logic_vector (1 downto 0) ; -- 1,5,10
        item_selectioin : in std_logic_vector(1 downto 0) ; -- A , B , C
        item_available : in std_logic ; --assume as controll elsewhere
        balence_display : out std_logic_vector(6 downto 0) ; -- two seven segments
        change_return : out std_logic_vector (6 downto 0) ; --amount of the change
        dispense_signal : out std_logic ; --signal for dispense
        error_signal : out std_logic --signal for error
    );
    signal balance          : INTEGER;
    signal item_price      : INTEGER;
    signal dispense_sig     : STD_LOGIC;
    signal error_sig       : STD_LOGIC;
END Vending_Machine;


ARCHITECTURE Structural OF Vending_Machine IS

BEGIN

END Structural;