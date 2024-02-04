library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
    generic (
        CLK_FREQ    : integer := 50_000_000;   --> set system clock frequency in Hz
        BAUD_RATE   : integer := 115200;      --> baud rate value
        DATA_WIDTH  : integer := 8;	      --> 8 bits données + 1 start
        STOP_WIDTH : integer := 1;
        TYPE_PARITY  : string  := "EVEN"      --> "NONE", "EVEN", "ODD"
    );
    port (
        clk, rst : in std_logic; 
        i_ready  : in std_logic;
        i_rxd    : in std_logic;
        o_data   : out std_logic_vector(DATA_WIDTH-1 downto 0);
        o_valid  : out std_logic;
		state_out    :out std_logic_vector(4 downto 0)
    );
end entity uart_rx;

architecture rtl of uart_rx is
    type state_type is (state_idle, state_start, state_data, state_parity, state_stop);
    signal state : state_type := state_idle;
    signal s_valid : std_logic := '0';
    signal s_data_buff : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    constant TIMER_TICK : integer := CLK_FREQ/BAUD_RATE; 
    signal s_cnt   : integer range 0 to TIMER_TICK := 0;
    signal s_tick  : std_logic := '0';
    signal s_bit_cnt   : integer range 0 to DATA_WIDTH - 1 := 0;
    signal s_party_bit : std_logic := 'Z';
	signal state_test  : std_logic_vector(4 downto 0):="00000";
begin

    ticker: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_tick <= '0';
                s_cnt <= 0;
            else
                if s_cnt = TIMER_TICK-1 then 
                    s_tick <= '1';
                    s_cnt <= 0;
                elsif (s_cnt = TIMER_TICK/2 -1) and (i_rxd='0') and (state = state_start) then 
                    s_tick <= '1';
                    s_cnt <= 0;
		elsif (state = state_idle) then 
		    s_cnt <= 0;
                else
                    s_tick <= '0';
                    s_cnt <= s_cnt+1;
                end if;
            end if;
        end if;
    end process ticker;
    
    rx: process(clk)
        variable v_parity : std_logic;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= state_idle;
                s_valid <= '0';
                s_data_buff <= (others => '0');
                s_bit_cnt <= 0; 
            else
                case state is
                    when state_idle =>
						s_valid <= '0';
						state_test <="00001";
                        s_data_buff <= (others => '0');
			
                        if i_rxd = '0'  then 
                            state <= state_start; 
                        else
                            state <= state_idle; 
                        end if;
                        if TYPE_PARITY = "EVEN" then 
                                v_parity := '0';
                        elsif TYPE_PARITY = "ODD" then 
                                v_parity := '1';
                        else 
                            v_parity := 'Z';
                        end if;
		    when state_start =>
			state_test <= "00010";
			if s_tick = '1' then 
				state <= state_data;
			end if;
                    when state_data =>
						state_test <="00100";
                        if s_tick = '1' then 
                            s_data_buff <= i_rxd & s_data_buff(DATA_WIDTH-1 downto 1);
                            if s_bit_cnt = DATA_WIDTH-1 then 
				v_parity := v_parity xor i_rxd;
                                s_bit_cnt <= 0;
                                if TYPE_PARITY= "NONE" then 
                                    state <= state_stop;
                                else
				     
                                    state <= state_parity;
                                end if; 
                            else 
                                v_parity := v_parity xor i_rxd;
                                s_bit_cnt <= s_bit_cnt +1;
                                state <= state_data;
                            end if;
                        end if; 
                    when state_parity =>
						state_test <="01000";
                        if s_tick = '1' then 
                            state <= state_stop; 
                            if v_parity = i_rxd then
                                s_valid <= '1';
								o_valid <= s_valid;
                            else 
                                s_valid <= '0';
                            end if;
                        end if;
                    when state_stop =>
						state_test <="10000";
                        if s_tick = '1' then 
                            if s_bit_cnt = STOP_WIDTH-1 then 
                                s_bit_cnt <= 0;
                                state <= state_idle;
								o_valid <= '0';
                            else 
                                s_bit_cnt <= s_bit_cnt+1;                                    
								 
                                state <= state_stop; 
                            end if;
                            o_data <= s_data_buff;
                            o_valid <= s_valid;
                        end if;
                    when others =>
                        state <= state_idle;
                        s_valid <= '0';
                        s_data_buff <= (others => '0');
                        s_bit_cnt <= 0; 
                end case;
            end if;
        end if;
		state_out<= state_test;
    end process rx;
		
    
end architecture rtl;