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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lift is
  Port (
    clk        :    in std_logic;
    reset      :    in std_logic;
    slow_en    :    in std_logic;
    floor_req  :    in std_logic_vector(3 downto 0);
    move_up    :    out std_logic;
    move_down  :    out std_logic;
    open_door  :    out std_logic;
    floor      :    out std_logic_vector(3 downto 0)
   -- f_o        :    out std_logic_vector(3 downto 0)
   );
end lift;

architecture Behavioral of lift is

type state_t is (idle,moving_up,moving_down,door);

constant DOOR_TIMER : integer:= 5;

signal state        :   state_t;
signal next_state   :   state_t;
--signal timer        :   unsigned(4 downto 0);
--signal f_r          :   unsigned(1 downto 0);
--signal invalid      :   std_logic;
signal current_floor:   integer range 0 to 3 := 0;
signal target_floor	:	integer range 0 to 3 := 0;
signal door_cnt	:	integer range 0 to DOOR_TIMER := 0;
--signal slow_en		:	std_logic;

signal latched_req	:	std_logic_vector(3 downto 0) := (others => '0');
--constant FLOOR_0 : unsigned(1 downto 0) := "00";
--constant FLOOR_1 : unsigned(1 downto 0) := "01";
--constant FLOOR_2 : unsigned(1 downto 0) := "10";
--constant FLOOR_3 : unsigned(1 downto 0) := "11";

begin
   
    
			
			
   --Target floor register-- 
	process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				target_floor <= 0;
			elsif state = idle and latched_req /= "0000" then
				if latched_req(0) = '1' then
					target_floor <= 0;
				elsif latched_req(1) = '1' then
					target_floor <= 1;
				elsif latched_req(2) = '1' then
					target_floor <= 2;
				elsif latched_req(3) = '1' then
					target_floor <= 3;
				else
					target_floor <= current_floor;
				end if;
				
			end if;
		end if;
	end process;
				
	--State transition logic--
	
	process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				state <= idle;
			else
				state <= next_state;
			end if;
		end if;
	end process;
	
	--Door timer logic --
	
	process(clk)
	begin
    if rising_edge(clk) then
        if reset = '1' then
            door_cnt <= 0;

        elsif state = door then
            if slow_en = '1' then
                if door_cnt < DOOR_TIMER then
                    door_cnt <= door_cnt + 1;
                end if;
            end if;

        else
            door_cnt <= 0;  -- reset timer when not in door
        end if;
    end if;
end process;
	
	--Request latch process--
	
	process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				latched_req <= (others => '0');
			elsif latched_req = "0000" and floor_req /= "0000" then
				latched_req <= floor_req;
			elsif state = door then
				latched_req <= (others => '0');
			end if;
		end if;
	end process;
	
	
	--FSM combinational logic--
	
	process(state, current_floor, target_floor, latched_req, door_cnt)
	begin
		next_state <= state;
		move_up    <= '0';
		move_down  <= '0';
		open_door  <= '0';
		
		case state is
			
			when idle => 
				if latched_req /= "0000" then
					if target_floor > current_floor then
						next_state <= moving_up;
					elsif target_floor < current_floor then
						next_state <= moving_down;
					else
						next_state <= door;
					end if;
				end if;
			
			when moving_up =>
				move_up <= '1';
				if current_floor = target_floor then
					next_state <= door;
				else
				
				end if;
			
			when moving_down => 
				move_down <= '1';
				if current_floor = target_floor then
					next_state <= door;
				else
				
				end if;
				
			when door =>
				
				if door_cnt = DOOR_TIMER then
					next_state <= idle;
					open_door  <= '0';
				else
					open_door <= '1';
					next_state <= door;
				end if;
		end case;
	end process;
	

	--Floor movement logic--
	
	process(clk)
	begin
		if rising_edge(clk) then	
			if reset = '1' then
				current_floor <= 0;
			elsif slow_en = '1' then
				case state is
					when moving_up => 
						if current_floor < 3 then
							current_floor <= current_floor + 1;
						else
						
						end if;
					
					when moving_down =>
						if current_floor > 0 then
							current_floor <= current_floor - 1;
						else
						
						end if;
						
					when others =>
						null;
					
				end case;
			end if;
		end if;
	end process;
	
	
	floor <= std_logic_vector(to_unsigned(current_floor, floor'length));
	
	
	
		
    
end Behavioral;
