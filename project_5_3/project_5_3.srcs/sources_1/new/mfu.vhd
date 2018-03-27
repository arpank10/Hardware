library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mfu is
Port (
i_Clk : in std_logic;
in_serial : in std_logic;
write : in std_logic;
show_input : out std_logic_vector(7 downto 0);
out_serial : out std_logic
);
end mfu;

architecture Behavioral of mfu is

component UART_TX is
generic (
    g_CLKS_PER_BIT : integer := 10416     -- Needs to be set correctly
);
port (
    i_Clk       : in  std_logic;
    i_TX_DV     : in  std_logic;
    i_TX_Byte   : in  std_logic_vector(7 downto 0);
    o_TX_Active : out std_logic;
    o_TX_Serial : out std_logic;
    o_TX_Done   : out std_logic
);
end component;
component UART_RX is
generic (
    g_CLKS_PER_BIT : integer := 10416     -- Needs to be set correctly
);
port (
    i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    o_RX_DV     : out std_logic;
    o_RX_Byte   : out std_logic_vector(7 downto 0)
);
end component;


type ram is array (15 downto 0) of std_logic_vector(15 downto 0);	
type sort is array (7 downto 0) of std_logic_vector(15 downto 0);

signal display1 : std_logic := '0';
signal display2 : std_logic := '0';

signal input : std_logic_vector(7 downto 0);
signal output : std_logic_vector(7 downto 0);
signal clear1 : std_logic := '0';
signal flagmode : std_logic := '1';
--signal flaginput : std_logic := '0';
--signal flagdisplay : std_logic := '0';

signal clk_out : std_logic := '0';
signal out_done : std_logic := '0';
signal out_active : std_logic := '0';
signal in_done : std_logic := '0';
signal O : std_logic := '0';
begin
process(in_done, out_done)
variable sorted_array: sort;    -- to store the sorted array
variable display: std_logic_vector(15 downto 0):=(others => '0');
variable temp: std_logic_vector(15 downto 0);   --  to store the temporary value during swapping
variable mode_i: std_logic_vector(15 downto 0);     -- to store the mode
variable temp1: std_logic_vector(15 downto 0);     -- to store the current element
variable freq: integer range 0 to 10; -- to store the running frequency
variable max_freq:integer range 0 to 10;    -- to store the maximum frequency
variable sum : std_logic_vector(15 downto 0); --to calculate sum
variable median_sum : std_logic_vector(15 downto 0); --to calculate median
variable range1 : std_logic_vector(15 downto 0);
variable address : std_logic_vector(3 downto 0);
variable mode : std_logic_vector(1 downto 0);
variable flag : integer := 0;
variable memory : ram;
variable index : integer range 0 to 7;
variable mid_range_sum :    std_logic_vector(15 downto 0);
begin
        if(in_done'EVENT and in_done = '1')then
            if(flag = 0) then
                 mode := input(5 downto 4);
                address := input(3 downto 0);
                if(mode = "00") then
                    flag := 1;
                end if;
                if(mode = "11") then
                for i in 0 to 15 loop
                     memory(i) := "0000000000000000";
                end loop;
                elsif( mode = "01") then
                output <= memory(conv_integer(address))(7 downto 0);
                show_input <= memory(conv_integer(address))(15 downto 8);
                elsif( mode = "10") then
                for i in 0 to 7 loop
                     sorted_array(i) := memory(i);
                end loop;
                 loop1: for i in 0 to 6 loop
                   loop2: for j in 0 to 6-i loop
                        if(sorted_array(j) > sorted_array(j+1)) then
                            temp:= sorted_array(j);
                            sorted_array(j) := sorted_array(j+1);
                            sorted_array(j+1) := temp;
                        end if;
                   end loop loop2;
                end loop loop1;
                freq := 1;
                max_freq := 1;
                mode_i := sorted_array(0);
                temp1 := sorted_array(0);
                loop3: for i in 1 to 7 loop
                    if(sorted_array(i) = temp1) then
                        freq := freq+1;
                        if(freq > max_freq) then
                            mode_i := temp1;
                            max_freq := freq;
                        end if;
                    else
                        temp1 := sorted_array(i);
                        freq := 1;
                    end if;
                end loop loop3;
                sum := memory(7) + memory(6) + memory(5) + memory(4) + memory(3) + memory(2) + memory(1) + memory(0); --sum
                range1 :=sorted_array(7) - sorted_array(0);
                median_sum := sorted_array(3) + sorted_array(4);
                mid_range_sum := sorted_array(7) + sorted_array(0);
                memory(8) := sum; --sum
                memory(9) := "000" & sum(15 downto 3); --mean
                memory(10) := '0' & median_sum(15 downto 1); --median
                memory(11) := sorted_array(7);       --max     
                memory(12) := sorted_array(0);       --min
                memory(13) := mode_i; -- mode
                memory(14) := range1; --range
                memory(15) := '0' & mid_range_sum(15 downto 1); --mid-range
                end if;
            else
            index := conv_integer(address);
            memory(index) := "00000000" & input;                
            flag := 0;
            end if; 
         end if;
end process;
Entity_rx: UART_RX port map(i_Clk=>i_Clk,i_RX_Serial=>in_serial,o_RX_DV=>in_done,o_RX_Byte=>input);

Entity_tx: UART_TX port map(i_Clk=>i_Clk, i_TX_DV=> write,i_TX_Byte => output,o_TX_Active => out_active,o_TX_Serial => out_serial,o_TX_Done => out_done);    
 

end Behavioral;
