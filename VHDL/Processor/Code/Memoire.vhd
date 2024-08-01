library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Memoire is
    Port(
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        read_enable : in STD_LOGIC;
        write_enable : in STD_LOGIC;
        address : in STD_LOGIC_VECTOR(31 downto 0);
        write_data : in STD_LOGIC_VECTOR(31 downto 0);
        data_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity Memoire;

architecture Behavioral of Memoire is

-- Mémoire de 1024 mots de 32 bits --
type memoiretype is array(0 to 1023) of STD_LOGIC_VECTOR(31 downto 0);
signal memoire : memoiretype := (others => (others => '0'));

begin
    process (clk, reset)
    begin
        if reset = '1' then
            -- Reset de la mémoire --
            memoire <= (others => (others => '0'));
        elsif rising_edge(clk) then
            -- LECTURE --
            if read_enable = '1' then
                data_out <= memoire(to_integer(unsigned(address)));
            -- ECRITURE --
            elsif write_enable = '1' then
                memoire(to_integer(unsigned(address))) <= write_data;
            end if;
        end if;
    end process;

end architecture Behavioral;