----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.11.2023 18:18:26
-- Design Name: 
-- Module Name: jal_instruction - Behavioral
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

entity jal_instruction is
Port(
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    instruction : in STD_LOGIC_VECTOR(31 downto 0);
    rd_out : out STD_LOGIC_VECTOR(4 downto 0);
    pc_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end jal_instruction;

architecture Behavioral of jal_instruction is

-- SIGNAUX INSTRUCTIONS --
signal opcode : STD_LOGIC_VECTOR(6 downto 0);
signal rd : STD_LOGIC_VECTOR(4 downto 0);
signal imm : STD_LOGIC_VECTOR(20 downto 0); 
signal pc_incr : STD_LOGIC_VECTOR(31 downto 0);
signal pc_enable : STD_LOGIC;
signal pc_select : STD_LOGIC;
signal adress_retour : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal next_pc : STD_LOGIC_VECTOR(31 downto 0);
signal pc : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

-- SIGNAUX REGISTRES --
signal read_enable_reg : STD_LOGIC;
signal write_enable_reg : STD_LOGIC;
signal read_registre_1 : STD_LOGIC_VECTOR(4 downto 0);
signal read_registre_2 : STD_LOGIC_VECTOR(4 downto 0);
signal write_registre : STD_LOGIC_VECTOR(4 downto 0);
signal write_data_reg : STD_LOGIC_VECTOR(31 downto 0);
signal data_out_1 : STD_LOGIC_VECTOR(31 downto 0);
signal data_out_2 : STD_LOGIC_VECTOR(31 downto 0);

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

process (clk, reset)
begin
    if reset = '1' then
       -- Reset des signaux de contrôle et des registres --
        read_enable_reg <= '0';
        write_enable_reg <= '0';
        next_pc <= (others => '0');
        adress_retour <= (others => '0');
    elsif rising_edge(clk) then
        opcode <= instruction(6 downto 0);
        rd <= instruction(11 downto 7);
        imm <= instruction(31 downto 12) & '0'; 
        
        -- Signaux de contrôle pour l'instruction JAL --
        if opcode = "1101111" then
            pc_incr <= (10 downto 0 => '0') & std_logic_vector(imm);
            pc_enable <= '1';
            pc_select <= '1';
            next_pc <= pc_incr;
            pc <= next_pc;
            adress_retour <= pc_incr;
        else
            pc_enable <= '0';
            pc_incr <= (others => '0');
            next_pc <= pc;
            adress_retour <= (others => '0');
            next_pc <= (others => '0');
        end if;
    end if;
end process;

end Behavioral;
