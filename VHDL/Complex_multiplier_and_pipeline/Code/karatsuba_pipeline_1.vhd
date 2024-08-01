----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2023 17:33:51
-- Design Name: 
-- Module Name: karatsuba_pipeline_1 - Behavioral
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

entity karatsuba_pipeline_1 is
    generic (
        SIZE : integer := 4
    );
    Port (
        a_reel : in STD_LOGIC_VECTOR (SIZE - 1 downto 0);
        a_imag : in STD_LOGIC_VECTOR (SIZE - 1 downto 0);
        b_reel : in STD_LOGIC_VECTOR (SIZE - 1 downto 0);
        b_imag : in STD_LOGIC_VECTOR (SIZE - 1 downto 0);
        result_reel : out STD_LOGIC_VECTOR (2*SIZE-1 downto 0);
        result_imag : out STD_LOGIC_VECTOR (2*SIZE-1 downto 0);
        clk : in STD_LOGIC
    );
end karatsuba_pipeline_1;

architecture Behavioral of karatsuba_pipeline_1 is
-- SIGNAUX POUR PIPELINE
signal a_reel_pip : STD_LOGIC_VECTOR (SIZE - 1 downto 0);
signal a_imag_pip : STD_LOGIC_VECTOR (SIZE - 1 downto 0);
signal b_reel_pip : STD_LOGIC_VECTOR (SIZE - 1 downto 0);
signal b_imag_pip : STD_LOGIC_VECTOR (SIZE - 1 downto 0);


signal step_1 : STD_LOGIC_VECTOR (2*SIZE-1 downto 0);
signal step_2 : STD_LOGIC_VECTOR (2*SIZE-1 downto 0);
signal step_3 : STD_LOGIC_VECTOR (2*SIZE-1 downto 0);

begin

-- Calcul de l'étape 1 --
step_1 <= (a_reel_pip * b_reel_pip);

-- Calcul de l'étape 2 --
step_2 <= (a_imag_pip * b_imag_pip);

-- Calcul de l'étape 3 --
step_3 <= (a_reel_pip + a_imag_pip) * (b_reel_pip + b_imag_pip);

process(clk)
begin
    if clk'event and clk='1' then
        -- Création des bascules D au début -
        a_reel_pip <= a_reel;
        a_imag_pip <= a_imag;
        b_reel_pip <= b_reel;
        b_imag_pip <= b_imag;
        
        -- Création des bascules D à la fin -
        result_reel <= (step_1 - step_3);
        result_imag <= (step_3 - step_1 - step_2);
    end if;
end process;

end Behavioral;
