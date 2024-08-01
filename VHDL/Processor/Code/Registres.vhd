----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.10.2023 17:25:22
-- Design Name: 
-- Module Name: Registres - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Registres is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        read_enable : in STD_LOGIC;
        write_enable : in STD_LOGIC;
        read_registre_1 : in STD_LOGIC_VECTOR(4 downto 0);
        read_registre_2 : in STD_LOGIC_VECTOR(4 downto 0);
        write_registre : in STD_LOGIC_VECTOR(4 downto 0);
        write_data : in STD_LOGIC_VECTOR(31 downto 0);
        data_out_1 : out STD_LOGIC_VECTOR(31 downto 0);
        data_out_2 : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity Registres;

architecture Behavioral of Registres is
    -- Création des 16 registres --
    type RegistreArray is array (0 to 15) of STD_LOGIC_VECTOR(31 downto 0);
    signal registres : RegistreArray;
    
begin

    process (clk, reset)
    begin
        if reset = '1' then
            -- Reset de tout les registres
            for i in 0 to 15 loop
                registres(i) <= (others => '0');
            end loop;
        elsif rising_edge(clk) then
            -- LECTURE --
            if read_enable = '1' then
                data_out_1 <= registres(to_integer(unsigned(read_registre_1)));
                data_out_2 <= registres(to_integer(unsigned(read_registre_2)));
            end if;
            
            -- ECRITURE --
            if write_enable = '1' then
                registres(to_integer(unsigned(write_registre))) <= write_data;
            end if; 
        end if;
    end process;
    
end architecture Behavioral;

