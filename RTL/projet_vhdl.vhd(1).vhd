LIBRARY IEEE;                                                  
USE IEEE.STD_LOGIC_1164.ALL;                     
LIBRARY IEEE;                                                  
USE IEEE.STD_LOGIC_1164.ALL;                     
USE IEEE.std_logic_unsigned.ALL;

entity projet_vhd is
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
end entity;

architecture RTL of projet_vhd is

component uart_rx is
generic (
        CLK_FREQ    : integer := 50_000_000;   --> set system clock frequency in Hz
        BAUD_RATE   : integer := 115200;      --> baud rate value
        DATA_WIDTH  : integer := 8;	      --> 8 bits donn閑s + 1 start
        STOP_WIDTH : integer := 1;
        TYPE_PARITY  : string  := "EVEN"      --> "NONE", "EVEN", "ODD"
    );
port (
        clk, rst : in std_logic; 
        i_ready  : in std_logic;
        i_rxd    : in std_logic;
        o_data   : out std_logic_vector(DATA_WIDTH-1 downto 0);
        o_valid  : out std_logic
    );
END component;



component ClockDelay is
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
end component;
component QuadDivider is
port (
	clk  :STD_LOGIC;
	led_4:out STD_LOGIC
);

end component;
component shandeng IS                                        
     PORT
     (
          clk:in STD_LOGIC;                                   
          led:out STD_LOGIC
     );     
END component;

component Mux8_1 is
port (
	s0,s1,s2  :STD_LOGIC;
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
end component;

component Decodeur 
port (
	clk     :STD_LOGIC;
	o_data  :STD_LOGIC_vector(7 downto 0);
	o_valide:STD_LOGIC;
	bit1,bit2,bit3:out STD_LOGIC_vector(7 downto 0)
	
);
end component;

signal led_4,led,clk_1,clk_2,clk_3,clk_4,clk_5,clk_6,clk_7,clk_8,clk  ,o_valid,signalControl_bit1,signalControl_bit2,signalControl_bit3    :std_logic;
signal rst :STD_LOGIC :='0';


signal output, o_data ,bit1,bit2,bit3  :STD_LOGIC_vector(7 downto 0);
constant NB_mux : natural := 8;



begin
	U1: ClockDelay port map (
        clk_43k      => led,        -- ??????????????
        clk_172k     => led_4,      -- ??
        clk_1        => clk_1,
        clk_2        => clk_2,
        clk_3        => clk_3,
        clk_4        => clk_4,
		clk_5        => clk_5,
        clk_6        => clk_6,
        clk_7        => clk_7,
        clk_8        => clk_8
    );
    U2: QuadDivider port map (
        clk  => clk_50M,
        led_4 => led_4
    );
    U3: shandeng port map (
        clk  => clk_50M,
        led  => led
    );
	  gen_mux: for i in 0 to NB_mux-1 generate
				mux:Mux8_1 PORT map (
				bit1(i),bit2(i),bit3(i),
				clk_1        => clk_1,
				clk_2        => clk_2,
				clk_3        => clk_3,
				clk_4        => clk_4,
				clk_5        => clk_5,
				clk_6        => clk_6,
				clk_7        => clk_7,
				clk_8        => clk_8,
				signal_1_bas => output(i)
				);
				end generate;
	U5:uart_rx PORT map (clk_50M,rst,i_ready,i_rxd,o_data,o_valid);
	
	dec : Decodeur PORT map (
		clk=> clk_50M,
		o_data => o_data,
		o_valide => o_valid,
		bit1 => bit1,
		bit2 => bit2,
		bit3 => bit3
	);
				
		
	clk_quarter   <=output(0);
	clk_half      <=output(1);
	clk_3quarter  <=output(2);
	clk_T         <=output(3);
	clk_quarter_h   <=output(4);
	clk_half_h      <=output(5);
	clk_3quarter_h  <=output(6);
	clk_T_h         <=output(7);
	
	--o_data_test <= o_data;
	--o_valide_test <= o_valid; 
	
	end architecture;