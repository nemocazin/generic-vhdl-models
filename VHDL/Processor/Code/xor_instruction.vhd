----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.11.2023 10:50:21
-- Design Name: 
-- Module Name: xor_instruction - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity xor_instruction is
Port(
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    instruction : in STD_LOGIC_VECTOR(31 downto 0)
    );
end xor_instruction;

architecture Behavioral of xor_instruction is

-- SIGNAUX INSTRUCTIONS --
signal opcode : STD_LOGIC_VECTOR(6 downto 0);
signal rd : STD_LOGIC_VECTOR(4 downto 0);
signal rs1 : STD_LOGIC_VECTOR(4 downto 0);
signal rs2 : STD_LOGIC_VECTOR(4 downto 0);
signal funct3 : STD_LOGIC_VECTOR(2 downto 0);
signal funct7 : STD_LOGIC_VECTOR(6 downto 0);

-- SIGNAUX ALU --

signal operand_a : STD_LOGIC_VECTOR(31 downto 0);
signal operand_b : STD_LOGIC_VECTOR(31 downto 0);
signal controle_alu : STD_LOGIC_VECTOR(2 downto 0);
signal result : STD_LOGIC_VECTOR(31 downto 0);

-- SIGNAUX REGISTRES --
signal read_enable : STD_LOGIC;
signal write_enable : STD_LOGIC;
signal read_registre_1 : STD_LOGIC_VECTOR(4 downto 0);
signal read_registre_2 : STD_LOGIC_VECTOR(4 downto 0);
signal write_registre : STD_LOGIC_VECTOR(4 downto 0);
signal write_data : STD_LOGIC_VECTOR(31 downto 0);
signal data_out_1 : STD_LOGIC_VECTOR(31 downto 0);
signal data_out_2 : STD_LOGIC_VECTOR(31 downto 0);

-- Composants --

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

component ALU is
    Port(
        operand_a : in STD_LOGIC_VECTOR(31 downto 0);
        operand_b : in STD_LOGIC_VECTOR(31 downto 0);
        controle_alu : in STD_LOGIC_VECTOR(2 downto 0);
        result : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component ALU;

begin

-- Port Maps --

Registres_pro: Registres
        Port Map (
            clk => clk,
            reset => reset,
            read_enable => read_enable,
            write_enable => write_enable,
            read_registre_1 => read_registre_1,
            read_registre_2 => read_registre_2,
            write_registre => write_registre,
            write_data => write_data,
            data_out_1 => data_out_1,
            data_out_2 => data_out_2
        );

    alu_inst: ALU
        Port Map (
            operand_a => operand_a,
            operand_b => operand_b,
            controle_alu => controle_alu,
            result => result
        );

-- Process --
process (clk, reset)
    begin
        if reset = '1' then
            -- Reset des signaux de contrôle et des registres --
            read_enable <= '0';
            write_enable <= '0';
            read_registre_1 <= (others => '0');
            read_registre_2 <= (others => '0');
            operand_a <= (others => '0');
            operand_b <= (others => '0');
            controle_alu <= (others => '0');
        elsif rising_edge(clk) then
            opcode <= instruction(6 downto 0);
            rd <= instruction(11 downto 7);
            funct3 <= instruction(14 downto 12);
            rs1 <= instruction(19 downto 15);
            rs2 <= instruction(24 downto 20); 
            funct7 <= instruction(31 downto 25);
            
            -- Signaux de contrôles pour l'instruction "XOR" --
             if opcode = "0110011" and funct3 = "100" and funct7 = "0000000" then
                -- Calcul --
                read_enable <= '1';
                write_enable <= '0';
                read_registre_1 <= rs1;
                read_registre_2 <= rs2;
                operand_a <= data_out_1;
                operand_b <= data_out_2;
                controle_alu <= "100";  -- Opération de l'ALU pour XOR est "100" --
                -- Affectation du résultat dans le registre --
                read_enable <= '0';
                write_enable <= '1';
                write_registre <= rd;
                write_data <= result;
            else
                read_enable <= '0';
                write_enable <= '0';
                controle_alu <= (others => '0');
            end if;
        end if;
    end process;

end Behavioral;
