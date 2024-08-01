----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.11.2023 18:52:24
-- Design Name: 
-- Module Name: beq_instruction - Behavioral
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

entity beq_instruction is
Port(
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    instruction : in STD_LOGIC_VECTOR(31 downto 0);
    pc : in STD_LOGIC_VECTOR(31 downto 0);
    pc_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end beq_instruction;

architecture Behavioral of beq_instruction is

-- SIGNAUX INSTRUCTION --
signal funct3 : STD_LOGIC_VECTOR(2 downto 0);
signal rs1 : STD_LOGIC_VECTOR(4 downto 0);
signal rs2 : STD_LOGIC_VECTOR(4 downto 0);
signal opcode : STD_LOGIC_VECTOR(6 downto 0);
signal imm : STD_LOGIC_VECTOR(12 downto 0); 

-- SIGNAUX PC --
signal pc_enable : STD_LOGIC;
signal pc_select : STD_LOGIC;
signal pc_incremented : STD_LOGIC_VECTOR(31 downto 0);

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
        pc_out <= (others => '0');
    elsif rising_edge(clk) then
        opcode <= instruction(6 downto 0);
        funct3 <= instruction(14 downto 12); 
        rs1 <= instruction(19 downto 15); 
        rs2 <= instruction(24 downto 20); 
        imm(12 to 12) <= instruction(31 downto 31); 
        imm(11 to 11) <= instruction(7 downto 7); 
        imm(10 to 5) <= instruction(30 downto 25); 
        imm(4 to 1) <= instruction(11 downto 8); 
        
        -- Signaux de contrôle pour l'instruction BEQ --
        if opcode = "1100011" and funct3 = "000" then
            read_enable_reg <= '1';
            read_registre_1 <= rs1;
            read_registre_2 <= rs2;
            if data_out_1 = data_out_2 then
                pc_incremented <= (18 downto 0 => '0') & std_logic_vector(imm);
                pc_enable <= '1';
                pc_select <= '1';
                pc_out <= pc_incremented;
            else
                pc_enable <= '0';
                pc_select <= '0';
                pc_out <= pc;
                pc_incremented <= (others => '0');
            end if;
        else
            read_enable_reg <= '0';
            pc_enable <= '0';
            pc_select <= '0';
            pc_incremented <= (others => '0');
        end if;
    end if;
end process;


end Behavioral;
