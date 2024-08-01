----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2023 10:27:18
-- Design Name: 
-- Module Name: mem_RAM - Behavioral
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_RAM is
    generic(
        aw             :integer := 8; -- Taille de l'adresse de la mémoire
        dw             :integer := 8  -- Taille des données de la mémoire
    );
    port(
        --arm clock
        aclk   :in    std_logic;
        aclear :in    std_logic;

        waddr  :in    std_logic_vector(aw-1 downto 0);
        wdata  :in    std_logic_vector(dw-1 downto 0);
        wen    :in    std_logic;

        raddr  :in    std_logic_vector(aw-1 downto 0);
        rdata  :out   std_logic_vector(dw-1 downto 0)        
    );
end mem_RAM;

architecture Behavorial of mem_RAM is    
    constant mem_len :integer := 2**aw;

    type mem_type is array (0 to mem_len-1) of std_logic_vector(dw-1 downto 0);

    signal block_ram : mem_type := (others => (others => '0'));

begin

process(aclk)
begin
    if (rising_edge(aclk)) then
        if (wen = '1') then
            block_ram(to_integer(unsigned(waddr))) <= wdata(dw-1 downto 0);
        end if;     

        rdata <= block_ram(to_integer(unsigned(raddr)));        

    end if;
end process;


end architecture;
