----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.10.2023 17:20:52
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port(
        operand_a : in STD_LOGIC_VECTOR(31 downto 0);
        operand_b : in STD_LOGIC_VECTOR(31 downto 0);
        controle_alu : in STD_LOGIC_VECTOR(2 downto 0);
        result : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity ALU;

architecture Behavioral of ALU is
begin
    process (operand_a, operand_b, controle_alu)
    begin
        -- CONTROLE DE TOUTES LES OPERATIONS --
        case controle_alu is
            when "000" =>  -- ADD
                result <= operand_a + operand_b;
            when "001" =>  -- SUB
                result <= operand_a - operand_b;
            when "010" =>  -- AND
                result <= operand_a and operand_b;
            when "011" =>  -- OR
                result <= operand_a or operand_b;
            when "100" =>  -- XOR
                result <= operand_a xor operand_b;
            when others => -- OPERATION INCONNUE
                result <= (others => '0');
        end case;
    end process;
end architecture Behavioral;
