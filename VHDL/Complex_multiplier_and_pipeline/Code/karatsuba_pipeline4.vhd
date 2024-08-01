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

entity karatsuba_pipeline_4 is
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
end karatsuba_pipeline_4;

architecture Behavioral of karatsuba_pipeline_4 is
-- SIGNAUX POUR PIPELINE
signal a_reel_pip : STD_LOGIC_VECTOR (SIZE - 1 downto 0);
signal a_imag_pip : STD_LOGIC_VECTOR (SIZE - 1 downto 0);
signal b_reel_pip : STD_LOGIC_VECTOR (SIZE - 1 downto 0);
signal b_imag_pip : STD_LOGIC_VECTOR (SIZE - 1 downto 0);

signal A1 : STD_LOGIC_VECTOR (SIZE - 1 downto 0);
signal A2 : STD_LOGIC_VECTOR (SIZE - 1 downto 0);
signal A3 : STD_LOGIC_VECTOR (SIZE - 1 downto 0);
signal A4 : STD_LOGIC_VECTOR (SIZE - 1 downto 0);
signal A5 : STD_LOGIC_VECTOR (2*SIZE-1 downto 0);
signal A6 : STD_LOGIC_VECTOR (2*SIZE-1 downto 0);

signal step_1 : STD_LOGIC_VECTOR (2*SIZE-1 downto 0);
signal step_2 : STD_LOGIC_VECTOR (2*SIZE-1 downto 0);
signal step_3 : STD_LOGIC_VECTOR (SIZE - 1 downto 0);

signal B1 : STD_LOGIC_VECTOR (SIZE - 1 downto 0);
signal B2 : STD_LOGIC_VECTOR (SIZE - 1 downto 0);
signal B3 : STD_LOGIC_VECTOR (SIZE - 1 downto 0);

signal C1 : STD_LOGIC_VECTOR (2*SIZE-1 downto 0);
signal C2 : STD_LOGIC_VECTOR (2*SIZE-1 downto 0);
signal C3 : STD_LOGIC_VECTOR (2*SIZE-1 downto 0);

begin

process(clk)
begin
    if clk'event and clk='1' then
        -- Création des bascules D au début -
        a_reel_pip <= a_reel;
        a_imag_pip <= a_imag;
        b_reel_pip <= b_reel;
        b_imag_pip <= b_imag;
        
        -- Pipeline 1 --
        A1 <= a_imag_pip;
        A2 <= b_imag_pip;
        A3 <= a_reel_pip;
        A4 <= b_reel_pip;
        
        A5 <= A3 *A4;
        A6 <= A1* A2;
        
        -- Calcul de l'étape 1 --
        step_1 <= A5;
        
        -- Calcul de l'étape 2 --
        step_2 <= A6;
        
        -- Pipeline 2 --
        B1 <= A3 + A1;
        B2 <= A4 + A2;
        B3 <= B1 + B2;
        
        -- Calcul de l'étape 3 --
        step_3 <= B3;
        
        -- Pipeline 3 --
        C1 <= step_1 - step_3;
        C2 <= step_3 - step_1;
        C3 <= C2 - step_2;
        
        -- Création des bascules D à la fin -
        result_reel <= C1;
        result_imag <= C3;
    end if;
end process;

end Behavioral;
