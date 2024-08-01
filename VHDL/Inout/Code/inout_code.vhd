----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2023 11:46:34
-- Design Name: 
-- Module Name: inout_code - Behavioral
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

entity inout_code is
    Port (
        inout_pin : inout std_logic;
        -- Entrée qui configure inout_pin soit en entrée soit en sortie --
        output_enable : in std_logic; 
        write : in std_logic;
        read : out std_logic
     );
end inout_code;

architecture Behavioral of inout_code is

begin

process
begin
    if output_enable = '0' then -- Lecture -- 
        read <= inout_pin;
    elsif output_enable = '1' then -- Ecriture --
        inout_pin <= write;
    end if;
end process;


end Behavioral;
