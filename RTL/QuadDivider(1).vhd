LIBRARY IEEE;                                                  
USE IEEE.STD_LOGIC_1164.ALL;                     
USE IEEE.std_logic_unsigned.ALL;

entity QuadDivider is
port (
	clk  :STD_LOGIC;
	led_4:out STD_LOGIC
);

end entity;

architecture rtl of QuadDivider is

BEGIN                                                                  
P1:PROCESS (clk)                                              
VARIABLE count:INTEGER RANGE 0 TO 250;
BEGIN                                                                
    IF clk'EVENT AND clk='1' THEN
      IF count<= 125 THEN     		
			led_4<='1';
			count:=count+1;                          
		ELSIF count>125 AND count<250 THEN
			led_4<='0';
			count:=count+1;
		ELSE
			count:=0;
		END IF;                                                      
     END IF;                                          
END PROCESS;   
                             
END architecture;