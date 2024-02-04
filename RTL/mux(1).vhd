library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux8_1 is
port (
	s1,s2,s0  : std_logic;
	clk_1     : STD_LOGIC;
	clk_2     : STD_LOGIC;
	clk_3     : STD_LOGIC;
	clk_4     : STD_LOGIC;
	clk_5     : STD_LOGIC;
	clk_6     : STD_LOGIC;
	clk_7     : STD_LOGIC;
	clk_8     : STD_LOGIC;
	signal_1_bas :out STD_LOGIC
);
end entity;

architecture dataflow of Mux8_1 is
begin
    signal_1_bas <= clk_1 when (S2='0' and S1='0' and S0='0') else
					clk_2 when (S2='0' and S1='0' and S0='1') else
					clk_3 when (S2='0' and S1='1' and S0='0') else
					clk_4 when (S2='0' and S1='1' and S0='1') else
					clk_5 when (S2='1' and S1='0' and S0='0') else
					clk_6 when (S2='1' and S1='0' and S0='1') else
					clk_7 when (S2='1' and S1='1' and S0='0') else
					clk_8 when (S2='1' and S1='1' and S0='1');
end dataflow;
