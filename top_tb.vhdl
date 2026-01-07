----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.12.2025 16:03:53
-- Design Name: 
-- Module Name: top_tb - Behavioral
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

entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is
signal clk          :   std_logic;
signal reset        :   std_logic;
signal slow_en	:	std_logic;
signal floor_req    :   std_logic_vector(3 downto 0);
signal move_up      :   std_logic;
signal move_down    :   std_logic;
signal open_door    :   std_logic;
signal floor        :   std_logic_vector(3 downto 0);
--signal f_o          :   std_logic_vector(3 downto 0);
signal led          :   std_logic;
begin
    top : entity work.top
        port map(
            clk             =>   clk,
            reset           =>   reset,
	--		slow_clk		=>	 slow_clk,
            floor_request   =>   floor_req,
            move_up         =>   move_up,
            move_down       =>   move_down,
            open_door       =>   open_door,
            floor           =>   floor,
	    led             =>   led
        );
        
    clk_process : process
    begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process;
    
    reset <= '1','0' after 15 ns;      
    
    stimuli : process
begin
  -- initial state
  floor_req <= "0000";

  -- wait for reset
  wait until reset = '0';
  wait for 20 ns;

  ----------------------------------------------------------------
  -- Request floor 1
  ----------------------------------------------------------------
  floor_req <= "0010";
wait until open_door'event and open_door = '1';  -- door opens at floor 1

  assert floor = "0001"
    report "Expected floor 1"
    severity note;

  -- clear request
  floor_req <= "0000";
  wait until open_door = '0';  -- door closes

  ----------------------------------------------------------------
  -- Request floor 2
  ----------------------------------------------------------------
  wait for 200 ns;
  floor_req <= "0100";
  wait until open_door'event and open_door = '1'; -- door opens at floor 2

  assert floor = "0010"
    report "Expected floor 2"
    severity note;

  floor_req <= "0000";
  wait until open_door = '0';

  ----------------------------------------------------------------
  -- Request floor 1
  ----------------------------------------------------------------
  wait for 200 ns;
  floor_req <= "0010";
  wait until open_door'event and open_door = '1';  -- door opens at floor 1

  assert floor = "0001"
    report "Expected floor 1"
    severity note;

  wait;
end process;
     
end Behavioral;
