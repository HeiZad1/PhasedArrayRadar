LIBRARY IEEE;                                                  
USE IEEE.STD_LOGIC_1164.ALL;                     
USE IEEE.std_logic_unsigned.ALL;

entity ClockDelay is
port (
	clk_43k  :STD_LOGIC;
	clk_172k  :STD_LOGIC;
	clk_1     :OUT STD_LOGIC;
	clk_2     :OUT STD_LOGIC;
	clk_3     :OUT STD_LOGIC;
	clk_4     :OUT STD_LOGIC;
	clk_5     :OUT STD_LOGIC;
	clk_6     :OUT STD_LOGIC;
	clk_7     :OUT STD_LOGIC;
	clk_8     :OUT STD_LOGIC
	
);

end entity;

architecture dataflow of ClockDelay is
signal reg : STD_LOGIC_vector(8 downto 0):="000000000";
begin
    
    
    process(clk_172k)
    begin
        
        if rising_edge(clk_172k) then
            reg<=reg(7 downto 0)&clk_43k;
                        -- This will shift in the clk_43k on each rising edge of clk_172k
        end if;
    end process;

    -- Assign the outputs to the corresponding bits of the register
    clk_1     <= reg(1);
    clk_2     <= reg(2);
    clk_3     <= reg(3);
    clk_4     <= reg(4);
	clk_5     <= reg(5);
    clk_6     <= reg(6);
    clk_7     <= reg(7);
    clk_8     <= reg(8);
	
	
	
	
                             
END architecture;


  
                  