LIBRARY IEEE;                                                  
USE IEEE.STD_LOGIC_1164.ALL;                     
USE IEEE.std_logic_unsigned.ALL;
entity test is
end entity;

architecture bench of test is
component  projet_vhd is
port(
	clk_50M   :STD_LOGIC;
	i_ready : STD_LOGIC;
	i_rxd	: STD_LOGIC;
	clk_quarter   :OUT STD_LOGIC;
	clk_half      :OUT STD_LOGIC;
	clk_3quarter  :OUT STD_LOGIC;
	clk_T         :OUT STD_LOGIC;
	clk_quarter_h   :OUT STD_LOGIC;
	clk_half_h      :OUT STD_LOGIC;
	clk_3quarter_h  :OUT STD_LOGIC;
	clk_T_h         :OUT STD_LOGIC
	--o_data_test :out std_logic_vector(7 downto 0);
    --o_valide_test :out std_logic;
	--state_test    :out std_logic_vector(4 downto 0)
);
end component;

signal clk_50M, i_ready, i_rxd :std_logic :='0';
signal clk_quarter, clk_half, clk_3quarter, clk_T, clk_quarter_h, clk_half_h, clk_3quarter_h, clk_T_h         : STD_LOGIC;
signal data : std_logic_vector(7 downto 0) := "00000000";
--signal data2 : std_logic_vector(7 downto 0) := "11110000";
--signal data3 : std_logic_vector(7 downto 0) := "10101010";

begin
  UUT: projet_vhd port map ( clk_50M, i_ready, i_rxd, clk_quarter, clk_half, clk_3quarter, clk_T, clk_quarter_h, clk_half_h, clk_3quarter_h, clk_T_h );

  clk_50M <= not clk_50M after 10ns; 
  data <= "00000001" after 100ns;

    stimulus:process
    begin
        i_ready <= '0';
        i_rxd <= '1';
        wait for 2000 ns;
        i_rxd <= '0'; -- start bit
        wait for 50000000/115200 * 20ns;

        for i in 0 to 8-1 loop
            i_rxd <= data(i); -- data bits
            wait for 50000000/115200 * 20ns;
        end loop;
        i_rxd <= '0'; -- parity bit
		--i_rxd <= '1'; -- parity bit force error
        wait for 50000000/115200 * 20ns;
        i_rxd <= '1'; -- stop bit
        wait for 50000000/115200 * 20ns;

        
        i_ready <= '1';

        

        wait;
    end process;

end architecture;
