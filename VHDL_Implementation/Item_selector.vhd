library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Item_selector is 

    port(
        clk : in std_logic ;
        reset : in std_logic ;
        item_selection : in std_logic_vector (1 downto 0) ;
        item_available : in std_logic ;
        item_price : out integer
    );
end Item_selector ;


architecture Behavioral of Item_Selector is 

begin
    process(reset , clk)
    begin
        if reset = '1' then 
            item_price <= 0 ;
        elsif rising_edge(clk) then 
            if item_available = '1' then
                case item_selection is
                    when "00" => item_price <= 5 ; -- item A
                    when "01" => item_price <= 7 ; -- item B
                    when "10" => item_price <= 10 ; -- item C
                    when others => item_price <= 0 ; -- invalid selection
                end case ;
            else
                item_price <= 0 ;
            end if ;
        end if ;
    end process ;
end Behavioral ;