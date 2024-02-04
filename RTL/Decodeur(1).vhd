library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decodeur is
port (
	clk     :std_logic;
	o_data  :STD_LOGIC_vector(7 downto 0);
	o_valide:STD_LOGIC;
	bit1,bit2,bit3:out STD_LOGIC_vector(7 downto 0)
	
);
end entity;

architecture RTL of Decodeur is

signal data_count : integer := 0;
signal valide_last : std_logic;
signal data_group1, data_group2, data_group3 : std_logic_vector(7 downto 0);



begin
    process(clk)
	variable valide,ov : std_logic:='0';
	begin
		 
		if rising_edge(clk) then
		valide := o_valide;
		ov := valide_last;
			if  valide = '1' and ov = '0'  then
				
				case data_count is
                    when 0 =>
                        data_group1 <= o_data;
                        data_count <= data_count + 1;
                    when 1 =>
                        data_group2 <= o_data;
                        data_count <= data_count + 1;
                    when 2 =>
                        data_group3 <= o_data;
                        data_count <= 0; 
						            bit1 <= data_group1;
						            bit2 <= data_group2;
						            bit3 <= o_data;
                    when others => 
                        
                        
                end case;
            end if;
        end if;
	valide_last <= valide;
    end process;
	
	
end RTL;
