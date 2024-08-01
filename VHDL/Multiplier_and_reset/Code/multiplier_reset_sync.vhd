----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.10.2023 17:55:17
-- Design Name: 
-- Module Name: multiplier_reset_async - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplier_reset_sync is
    generic(
        size :integer := 16
    );
    Port (
        clk_in : in std_logic;
        a_in : in std_logic_vector(size-1 downto 0);
        b_in : in std_logic_vector(size-1 downto 0);       
        reset_sync : in std_logic;
        result : out std_logic_vector((2*size)-1 downto 0)
    );
end multiplier_reset_sync;

architecture Behavioral of multiplier_reset_sync is

begin

process(a_in, b_in, reset_sync, clk_in)
begin
    -- Multiplication --
    if clk_in'event and clk_in = '1' then
        if reset_sync = '1' then
            result <= (others => '0');
        else
            result <= std_logic_vector(signed(a_in) * signed(b_in));
        end if;
    end if;
end process;


end Behavioral;
