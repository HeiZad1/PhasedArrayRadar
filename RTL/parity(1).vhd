library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity parity is
    generic (
        DATA_WIDTH  : integer := 8;
        TYPE_PARITY : string := "NONE"
    );
    port (
        i_data : std_logic_vector(DATA_WIDTH-1 downto 0);
        o_parity : out std_logic
    );
end entity parity;

architecture rtl of parity is
begin

    none_parity: if TYPE_PARITY = "NONE" generate
        o_parity <= 'Z';
    end generate none_parity;

    even_parity: if TYPE_PARITY = "EVEN" generate
    evenn : process( i_data )
        variable v_par : std_logic := '0'; 
    begin
        v_par := '0';
        for ii in i_data'range loop
            v_par := v_par xor i_data(ii);
        end loop; 
        o_parity <= v_par; 
    end process; -- evenn
    end generate even_parity;

    odd_parity: if TYPE_PARITY = "ODD" generate
    odd : process( i_data )
        variable v_par : std_logic := '1'; 
    begin
        v_par := '1';
        for ii in i_data'range loop
            v_par := v_par xor i_data(ii);
        end loop; 
        o_parity <= v_par; 
    end process; -- evenn
    end generate odd_parity;
end rtl ; -- rtl