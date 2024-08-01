----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2023 16:28:59
-- Design Name: 
-- Module Name: large_adder - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity large_adder is
    generic (
        SIZE : integer := 256
    );
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC; 
        a_in : in STD_LOGIC_VECTOR (SIZE - 1 downto 0);
        b_in : in STD_LOGIC_VECTOR (SIZE - 1 downto 0);
        result_out : out STD_LOGIC_VECTOR (SIZE - 1 downto 0)
    );
end large_adder;

architecture Behavioral of large_adder is
-- Signaux pour la création des bascules D --
signal a_sig : STD_LOGIC_VECTOR (SIZE - 1 downto 0);
signal b_sig : STD_LOGIC_VECTOR (SIZE - 1 downto 0);

begin

process(clk, reset)
begin
    if reset = '1' then
        result_out <= (others=>'0');
    elsif clk'event and clk = '1' then
        a_sig <= a_in;
        b_sig <= b_in;
        result_out <= a_sig + b_sig; -- Calcul --
    end if;
end process;


end Behavioral;
