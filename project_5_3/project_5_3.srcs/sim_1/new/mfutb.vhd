----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.03.2018 19:27:21
-- Design Name: 
-- Module Name: mfutb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mfutb is
--  Port ( );
end mfutb;

architecture Behavioral of mfutb is
component mfu
    Port ( 
    clk : in std_logic;
    mode : in std_logic_vector(1 downto 0); -- 00 Input mode, 01 compute mode, 10 Display mode, 11 Reset mode
    write : in std_logic;
    address : in std_logic_vector(3 downto 0);
    input : in std_logic_vector(7 downto 0);
    LED_out: out std_logic_vector(6 downto 0);
    Anode_Activate: out std_logic_vector(3 downto 0)
);
end component;
 signal clk : std_logic:='0';
 signal mode: std_logic_vector(1 downto 0);
 signal write : std_logic := '0';
 signal address: std_logic_vector(3 downto 0);
 signal input: std_logic_vector(7 downto 0);
 signal LED_out: std_logic_vector(6 downto 0);
 signal Anode_Activate:  std_logic_vector(3 downto 0);
 
begin

 inst_mfu: mfu port map (
                     clk => clk,
                     mode => mode,
                     write => write,
                     address => address,
                     input  => input,
                     LED_out => LED_out,
                     Anode_Activate => Anode_Activate );

 stimulus: process
 begin
    mode<="11";
    
    wait for 40 ns;
    --input
    mode <= "00";
    address <= "0000";
    input <= "00000001";
    wait for 40 ns;
    --input
    mode <= "00";
    address <= "0001";
    input <= "00000010";
    wait for 40 ns;
    --input
    mode <= "00";
    address <= "0010";
    input <= "00000011";
    wait for 40 ns;
    --input
    mode <= "00";
    address <= "0011";
    input <= "00000100";
    wait for 40 ns;
    --input
    mode <= "00";
    address <= "0100";
    input <= "00000101";
    wait for 40 ns;
    --input
    mode <= "00";
    address <= "0101";
    input <= "00000110";
    wait for 40 ns;
    --input
    mode <= "00";
    address <= "0110";
    input <= "00000111";
     wait for 40 ns;
    --input
     mode <= "00";
     address <= "0111";
     input <= "00001000";
    wait for 40 ns;
    mode<="10";

   wait;
 end process;


end Behavioral;
