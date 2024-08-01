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

entity large_adder_pipeline is
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
end large_adder_pipeline;

architecture Behavioral of large_adder_pipeline is
-- Signaux pour la création des bascules D --
signal a_bot_sig : STD_LOGIC_VECTOR (SIZE/2 - 1 downto 0);
signal a_top_sig : STD_LOGIC_VECTOR (SIZE/2 - 1 downto 0);
signal b_bot_sig : STD_LOGIC_VECTOR (SIZE/2 - 1 downto 0);
signal b_top_sig : STD_LOGIC_VECTOR (SIZE/2 - 1 downto 0);
signal result_bot_sig : STD_LOGIC_VECTOR (SIZE/2 - 1 downto 0);
signal result_top_sig : STD_LOGIC_VECTOR (SIZE/2 - 1 downto 0);
signal carry : STD_LOGIC;

begin

process(clk, reset)
begin
    -- Reset --
    if reset = '1' then
        result_out <= (others=>'0');
    elsif clk'event and clk = '1' then
        a_bot_sig <= a_in(SIZE/2 - 1 downto 0);
        a_top_sig <= a_in(SIZE - 1 downto SIZE/2);
        b_bot_sig <= b_in(SIZE/2 - 1 downto 0);
        b_top_sig <= b_in(SIZE - 1 downto SIZE/2);
        
        -- Calcul poids faible --
        result_bot_sig <= a_bot_sig + b_bot_sig;
        
        -- Calcul poids fort --
        if a_bot_sig(SIZE/2 - 1) = '1' and b_bot_sig(SIZE/2 - 1) = '1' then
            -- Detection d'une carry --
            result_top_sig <= a_top_sig + b_top_sig + carry;
        else
            -- Pas de carry --
            result_top_sig <= a_top_sig + b_top_sig;
        end if;
        
        -- Reconstitution résultat --
        result_out(SIZE/2 - 1 downto 0) <= result_bot_sig;
        result_out(SIZE - 1 downto SIZE/2) <= result_top_sig;
    end if;
end process;


end Behavioral;
