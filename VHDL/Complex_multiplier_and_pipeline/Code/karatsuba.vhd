----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2023 18:00:03
-- Design Name: 
-- Module Name: karatsuba - Behavioral
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

entity karatsuba is
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
end karatsuba;

architecture Behavioral of karatsuba is
signal step_1 : STD_LOGIC_VECTOR (2*SIZE-1 downto 0);
signal step_2 : STD_LOGIC_VECTOR (2*SIZE-1 downto 0);
signal step_3 : STD_LOGIC_VECTOR (2*SIZE-1 downto 0);

begin

-- Calcul de l'étape 1 --
step_1 <= (a_reel * b_reel);

-- Calcul de l'étape 2 --
step_2 <= (a_imag * b_imag);

-- Calcul de l'étape 3 --
step_3 <= (a_reel + a_imag) * (b_reel + b_imag);

result_reel <= step_1 - step_3;
result_imag <= (step_3 - step_1 - step_2);

end Behavioral;
