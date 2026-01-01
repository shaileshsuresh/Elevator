----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.12.2025 19:47:41
-- Design Name: 
-- Module Name: lift - Behavioral
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_divider is
  Port (
    clk     :   in std_logic;
    reset   :   in std_logic;
    clk_out   :   out std_logic    
   );
end clock_divider;

architecture Behavioral of clock_divider is

signal count    :   unsigned(27 downto 0);
signal c_out    :   std_logic;
begin

    process(clk,reset)
    begin
        if reset = '1' then
            c_out <= '0';
            count <= (others => '0');
        elsif rising_edge(clk) then
            if count = 24999999 then
                count <= (others => '0');
                c_out <= not c_out;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    
    clk_out <= c_out;
 

end Behavioral;
