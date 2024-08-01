----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2023 17:32:12
-- Design Name: 
-- Module Name: complex_multiplier - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity complex_multiplier is
    generic (
        SIZE : integer := 4
    );
    Port (
        a_reel : in STD_LOGIC_VECTOR (SIZE - 1 downto 0);
        a_imag : in STD_LOGIC_VECTOR (SIZE - 1 downto 0);
        b_reel : in STD_LOGIC_VECTOR (SIZE - 1 downto 0);
        b_imag : in STD_LOGIC_VECTOR (SIZE - 1 downto 0);
        result_reel : out STD_LOGIC_VECTOR (2*SIZE-1 downto 0);
        result_imag : out STD_LOGIC_VECTOR (2*SIZE-1 downto 0)
    );
end complex_multiplier;

architecture Behavioral of complex_multiplier is
begin
    process (a_reel, a_imag, b_reel, b_imag)
    begin
        -- Calcul de la partie réelle --
        result_reel <= (a_reel * b_reel) - (a_imag * b_imag);

        -- Calcul de la partie imaginaire --
        result_imag <= (a_reel * b_imag) + (a_imag * b_reel);
    end process;
end Behavioral;
