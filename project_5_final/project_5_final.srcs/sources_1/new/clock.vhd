library IEEE;
use IEEE.std_logic_1164.all;

entity Clock is 
 port(
 clk_in : in std_logic;
 clk_out : out std_logic);
end Clock;

architecture structural of clock is

signal r_Clk_Count : integer range 0 to 10415 := 0;
begin
    clk_out <= '0';
	clock_process: Process(clk_in) is
		       begin
				if(rising_edge(clk_in)) then
				    r_Clk_Count <= r_Clk_Count + 1;
				    if(r_Clk_Count = 10415) then
				        clk_out <= '1';
				        r_Clk_Count <= 0;
				     end if;
				 end if;
			end Process clock_process;
end structural;