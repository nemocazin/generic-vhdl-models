----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.11.2023 11:20:11
-- Design Name: 
-- Module Name: load_instruction - Behavioral
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

entity load_instruction is
Port(
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    instruction : in STD_LOGIC_VECTOR(31 downto 0)
    );
end load_instruction;

architecture Behavioral of load_instruction is

-- SIGNAUX INSTRUCTIONS --
signal opcode : STD_LOGIC_VECTOR(6 downto 0);
signal rd : STD_LOGIC_VECTOR(4 downto 0);
signal rs1 : STD_LOGIC_VECTOR(4 downto 0);
signal imm : STD_LOGIC_VECTOR(11 downto 0);
signal funct3 : STD_LOGIC_VECTOR(2 downto 0);

-- SIGNAUX REGISTRES --
signal read_enable_reg : STD_LOGIC;
signal write_enable_reg : STD_LOGIC;
signal read_registre_1 : STD_LOGIC_VECTOR(4 downto 0);
signal read_registre_2 : STD_LOGIC_VECTOR(4 downto 0);
signal write_registre : STD_LOGIC_VECTOR(4 downto 0);
signal write_data_reg : STD_LOGIC_VECTOR(31 downto 0);
signal data_out_1 : STD_LOGIC_VECTOR(31 downto 0);
signal data_out_2 : STD_LOGIC_VECTOR(31 downto 0);

-- SIGNAUX MEMOIRE --
signal address : STD_LOGIC_VECTOR(31 downto 0);
signal data_out_mem : STD_LOGIC_VECTOR(31 downto 0);
signal read_enable_mem : STD_LOGIC;
signal write_enable_mem: STD_LOGIC;
signal write_data_mem : STD_LOGIC_VECTOR(31 downto 0);

component Registres is
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
end component Registres;

component Memoire is
    Port(
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        read_enable : in STD_LOGIC;
        write_enable : in STD_LOGIC;
        address : in STD_LOGIC_VECTOR(31 downto 0);
        write_data : in STD_LOGIC_VECTOR(31 downto 0);
        data_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component Memoire;

begin

-- Port Maps --

Registres_pro: Registres
    Port Map (
        clk => clk,
        reset => reset,
        read_enable => read_enable_reg,
        write_enable => write_enable_reg,
        read_registre_1 => read_registre_1,
        read_registre_2 => read_registre_2,
        write_registre => write_registre,
        write_data => write_data_reg,
        data_out_1 => data_out_1,
        data_out_2 => data_out_2
    );

mem: Memoire
    Port Map (
        clk => clk,
        reset => reset,
        read_enable => read_enable_mem,
        write_enable => write_enable_mem,
        address => address,
        write_data => write_data_mem,
        data_out => data_out_mem
    );
    
-- Process --
process (clk, reset)
    begin
        if reset = '1' then
            -- Reset des signaux de contrôle et des registres --
            read_enable_reg <= '0';
            write_enable_reg <= '0';
            read_enable_mem <= '0';
            write_enable_mem <= '0';
            read_registre_1 <= (others => '0');
            address <= (others => '0');
        elsif rising_edge(clk) then
            opcode <= instruction(6 downto 0);
            rd <= instruction(11 downto 7);
            funct3 <= instruction(14 downto 12);
            rs1 <= instruction(19 downto 15);
            imm <= instruction(31 downto 20);
            
            -- Signaux de contrôles pour l'instruction "load" --
            if opcode = "0000011" and funct3 = "010" then
                -- Récupération de la valeur dans la mémoire --
                read_enable_mem <= '1';
                write_enable_mem <= '0';
                address <= (14 downto 0 => '0') & std_logic_vector(rs1 & imm);
                -- Affectation de la valeur dans le registre --
                read_enable_reg <= '0';
                write_enable_reg <= '1';
                read_enable_mem <= '1';
                write_enable_mem <= '0';
                write_registre <= rd;
                write_data_reg <= data_out_mem;
            else
                read_enable_reg <= '0';
                write_enable_reg <= '0';
                read_enable_mem <= '0';
                write_enable_mem <= '0';
            end if;
        end if;
    end process;
 
end Behavioral;
