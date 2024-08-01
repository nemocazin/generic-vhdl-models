----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.11.2023 19:19:30
-- Design Name: 
-- Module Name: processor_full - Behavioral
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

entity processor_full is
Port(
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    instruction : in STD_LOGIC_VECTOR(31 downto 0);
    alu_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end processor_full;

architecture Behavioral of processor_full is

-- SIGNAUX INSTRUCTION (ADDI / ANDI / LOAD) --
signal opcode_a : STD_LOGIC_VECTOR(6 downto 0);
signal rd_a : STD_LOGIC_VECTOR(4 downto 0);
signal rs1_a : STD_LOGIC_VECTOR(4 downto 0);
signal imm_a : STD_LOGIC_VECTOR(11 downto 0);
signal funct3_a : STD_LOGIC_VECTOR(2 downto 0);

-- SIGNAUX INSTRUCTIONS (ADD / SUB / XOR) --
signal opcode_b : STD_LOGIC_VECTOR(6 downto 0);
signal rd_b : STD_LOGIC_VECTOR(4 downto 0);
signal rs1_b : STD_LOGIC_VECTOR(4 downto 0);
signal rs2_b : STD_LOGIC_VECTOR(4 downto 0);
signal funct3_b : STD_LOGIC_VECTOR(2 downto 0);
signal funct7_b : STD_LOGIC_VECTOR(6 downto 0);

-- SIGNAUX INSTRUCTIONS (STORE) --
signal opcode_c : STD_LOGIC_VECTOR(6 downto 0);
signal rs1_c : STD_LOGIC_VECTOR(4 downto 0);
signal rs2_c : STD_LOGIC_VECTOR(4 downto 0);
signal imm_c : STD_LOGIC_VECTOR(11 downto 0); 
signal funct3_c : STD_LOGIC_VECTOR(2 downto 0);

-- SIGNAUX INSTRUCTIONS (JAL) --
signal opcode_d : STD_LOGIC_VECTOR(6 downto 0);
signal rd_d : STD_LOGIC_VECTOR(4 downto 0);
signal imm_d : STD_LOGIC_VECTOR(20 downto 0); 
signal pc_incr_d : STD_LOGIC_VECTOR(31 downto 0);
signal pc_enable_d : STD_LOGIC;
signal pc_select_d : STD_LOGIC;
signal adress_retour_d : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal next_pc_d : STD_LOGIC_VECTOR(31 downto 0);
signal pc_d : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

-- SIGNAUX INSTRUCTION (BEQ) --
signal funct3_e : STD_LOGIC_VECTOR(2 downto 0);
signal rs1_e : STD_LOGIC_VECTOR(4 downto 0);
signal rs2_e : STD_LOGIC_VECTOR(4 downto 0);
signal opcode_e : STD_LOGIC_VECTOR(6 downto 0);
signal imm_e : STD_LOGIC_VECTOR(12 downto 0); 
signal pc_enable_e : STD_LOGIC;
signal pc_select_e : STD_LOGIC;
signal pc_incremented_e : STD_LOGIC_VECTOR(31 downto 0);
signal pc_out_e : STD_LOGIC_VECTOR(31 downto 0);
signal pc_e : STD_LOGIC_VECTOR(31 downto 0);

-- SIGNAUX ALU --
signal operand_a : STD_LOGIC_VECTOR(31 downto 0);
signal operand_b : STD_LOGIC_VECTOR(31 downto 0);
signal controle_alu : STD_LOGIC_VECTOR(2 downto 0);
signal result : STD_LOGIC_VECTOR(31 downto 0);

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

-- Composants --
component ALU is
    Port(
        operand_a : in STD_LOGIC_VECTOR(31 downto 0);
        operand_b : in STD_LOGIC_VECTOR(31 downto 0);
        controle_alu : in STD_LOGIC_VECTOR(2 downto 0);
        result : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component ALU;

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
alu_inst: ALU
    Port Map (
        operand_a => operand_a,
        operand_b => operand_b,
        controle_alu => controle_alu,
        result => result
    );

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
        read_registre_2 <= (others => '0');
        address <= (others => '0');
        operand_a <= (others => '0');
        operand_b <= (others => '0');
        controle_alu <= (others => '0');
        next_pc_d <= (others => '0');
        adress_retour_d <= (others => '0');
        pc_out_e <= (others => '0');
        
    elsif rising_edge(clk) then
        opcode_a <= instruction(6 downto 0);
        rd_a <= instruction(11 downto 7);
        funct3_a <= instruction(14 downto 12);
        rs1_a <= instruction(19 downto 15);
        imm_a <= instruction(31 downto 20);
        
        opcode_b <= instruction(6 downto 0);
        rd_b <= instruction(11 downto 7);
        funct3_b <= instruction(14 downto 12);
        rs1_b <= instruction(19 downto 15);
        rs2_b <= instruction(24 downto 20); 
        funct7_b <= instruction(31 downto 25);
        
        opcode_c <= instruction(6 downto 0);
        imm_c(4 downto 0) <= instruction(11 downto 7);
        funct3_c <= instruction(14 downto 12);
        rs1_c <= instruction(19 downto 15);
        rs2_c <= instruction(24 downto 20);
        imm_c(11 downto 5) <= instruction(31 downto 25);
        
        opcode_d <= instruction(6 downto 0);
        rd_d <= instruction(11 downto 7);
        imm_d <= instruction(31 downto 12) & '0'; 
        
        opcode_e <= instruction(6 downto 0);
        funct3_e <= instruction(14 downto 12); 
        rs1_e <= instruction(19 downto 15); 
        rs2_e <= instruction(24 downto 20); 
        imm_e(12 to 12) <= instruction(31 downto 31); 
        imm_e(11 to 11) <= instruction(7 downto 7); 
        imm_e(10 to 5) <= instruction(30 downto 25); 
        imm_e(4 to 1) <= instruction(11 downto 8); 
        
        -- Signaux de contrôles pour l'instruction "addi" --
        if opcode_a = "0010011" and funct3_a = "000" then
            -- Calcul --
            read_enable_reg <= '1';
            write_enable_reg <= '0';
            read_registre_1 <= rs1_a;
            operand_a <= data_out_1;
            operand_b <= (19 downto 0 => '0') & imm_a; -- On remet sur 32 bits --
            controle_alu <= "000";  -- Opération de l'ALU pour ADD est "000" --
            -- Affectation du résultat dans le registre --
            read_enable_reg <= '0';
            write_enable_reg <= '1';
            write_registre <= rd_a;
            write_data_reg <= result;
            alu_out <= result;
        else
            read_enable_reg <= '0';
            write_enable_reg <= '0';
            controle_alu <= (others => '0');
        end if;
        
        
        -- Signaux de contrôles pour l'instruction "andi" --
        if opcode_a = "0010011" and funct3_a = "111" then
            -- Calcul --
            read_enable_reg <= '1';
            write_enable_reg <= '0';
            read_registre_1 <= rs1_a;
            operand_a <= data_out_1;
            operand_b <= (19 downto 0 => '0') & imm_a;
            controle_alu <= "010";  -- Opération de l'ALU pour AND est "010" --
            -- Affectation du résultat dans le registre --
            read_enable_reg <= '0';
            write_enable_reg <= '1';
            write_registre <= rd_a;
            write_data_reg <= result;
            alu_out <= result;
        else
            read_enable_reg <= '0';
            write_enable_reg <= '0';
            controle_alu <= (others => '0');
        end if;
        
        
        -- Signaux de contrôles pour l'instruction "ADD" --
             if opcode_b = "0110011" and funct3_b = "000" and funct7_b = "0000000" then
                -- Calcul --
                read_enable_reg <= '1';
                write_enable_reg <= '0';
                read_registre_1 <= rs1_b;
                read_registre_2 <= rs2_b;
                operand_a <= data_out_1;
                operand_b <= data_out_2;
                controle_alu <= "000";  -- Opération de l'ALU pour ADD est "000" --
                -- Affectation du résultat dans le registre --
                read_enable_reg <= '0';
                write_enable_reg <= '1';
                write_registre <= rd_b;
                write_data_reg <= result;
                alu_out <= result;
            else
                read_enable_reg <= '0';
                write_enable_reg <= '0';
                controle_alu <= (others => '0');
            end if;
            
            
            -- Signaux de contrôles pour l'instruction "SUB" --
             if opcode_b = "0110011" and funct3_b = "000" and funct7_b = "0100000" then
                -- Calcul --
                read_enable_reg <= '1';
                write_enable_reg <= '0';
                read_registre_1 <= rs1_b;
                read_registre_2 <= rs2_b;
                operand_a <= data_out_1;
                operand_b <= data_out_2;
                controle_alu <= "001";  -- Opération de l'ALU pour SUB est "001" --
                -- Affectation du résultat dans le registre --
                read_enable_reg <= '0';
                write_enable_reg <= '1';
                write_registre <= rd_b;
                write_data_reg <= result;
                alu_out <= result;
            else
                read_enable_reg <= '0';
                write_enable_reg <= '0';
                controle_alu <= (others => '0');
            end if;
            
            
            -- Signaux de contrôles pour l'instruction "XOR" --
             if opcode_b = "0110011" and funct3_b = "100" and funct7_b = "0000000" then
                -- Calcul --
                read_enable_reg <= '1';
                write_enable_reg <= '0';
                read_registre_1 <= rs1_b;
                read_registre_2 <= rs2_b;
                operand_a <= data_out_1;
                operand_b <= data_out_2;
                controle_alu <= "100";  -- Opération de l'ALU pour XOR est "100" --
                -- Affectation du résultat dans le registre --
                read_enable_reg <= '0';
                write_enable_reg <= '1';
                write_registre <= rd_b;
                write_data_reg <= result;
                alu_out <= result;
            else
                read_enable_reg <= '0';
                write_enable_reg <= '0';
                controle_alu <= (others => '0');
            end if;
            
            
            -- Signaux de contrôles pour l'instruction "load" --
            if opcode_a = "0000011" and funct3_a = "010" then
                -- Récupération de la valeur dans la mémoire --
                read_enable_mem <= '1';
                write_enable_mem <= '0';
                address <= (14 downto 0 => '0') & std_logic_vector(rs1_a & imm_a);
                -- Affectation de la valeur dans le registre --
                read_enable_reg <= '0';
                write_enable_reg <= '1';
                read_enable_mem <= '1';
                write_enable_mem <= '0';
                write_registre <= rd_a;
                write_data_reg <= data_out_mem;
            else
                read_enable_reg <= '0';
                write_enable_reg <= '0';
                read_enable_mem <= '0';
                write_enable_mem <= '0';
            end if;
            
            
            -- Signaux de contrôles pour l'instruction "STORE" --
            if opcode_c = "0100011" and funct3_c = "010" then
                -- Récupération de la valeur dans le registre --
                read_enable_reg <= '1';
                write_enable_reg <= '0';
                read_registre_1 <= rs2_c;
                -- Affectation de la valeur dans la mémoire --
                read_enable_reg <= '1';
                write_enable_reg <= '0';
                read_enable_mem <= '0';
                write_enable_mem <= '1';
                address <= (14 downto 0 => '0') & std_logic_vector(rs1_c & imm_c);
                write_data_mem <= data_out_1;
            else
                read_enable_reg <= '0';
                write_enable_reg <= '0';
                read_enable_mem <= '0';
                write_enable_mem <= '0';
            end if;
            
            
            -- Signaux de contrôle pour l'instruction JAL --
            if opcode_d = "1101111" then
                pc_incr_d <= (10 downto 0 => '0') & std_logic_vector(imm_d);
                pc_enable_d <= '1';
                pc_select_d <= '1';
                next_pc_d <= pc_incr_d;
                pc_d <= next_pc_d;
                adress_retour_d <= pc_incr_d;
            else
                pc_enable_d <= '0';
                pc_incr_d <= (others => '0');
                next_pc_d <= pc_d;
                adress_retour_d <= (others => '0');
                next_pc_d <= (others => '0');
            end if;
            
            
            -- Signaux de contrôle pour l'instruction BEQ --
        if opcode_e = "1100011" and funct3_e = "000" then
            read_enable_reg <= '1';
            read_registre_1 <= rs1_e;
            read_registre_2 <= rs2_e;
            if data_out_1 = data_out_2 then
                pc_incremented_e <= (18 downto 0 => '0') & std_logic_vector(imm_e);
                pc_enable_e <= '1';
                pc_select_e <= '1';
                pc_out_e <= pc_incremented_e;
            else
                pc_enable_e <= '0';
                pc_select_e <= '0';
                pc_out_e <= pc_e;
                pc_incremented_e <= (others => '0');
            end if;
        else
            read_enable_reg <= '0';
            pc_enable_e <= '0';
            pc_select_e <= '0';
            pc_incremented_e <= (others => '0');
        end if;
        
        
    end if;
end process;

end Behavioral;
