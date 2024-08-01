# Generic VHDL models

# __Processor__

 * [Objective](#objective)
 * [Programming](#programming)
    * [Preparations before instructions](#preparations-before-instructions)
    * [Programs for each instruction separately](#programs-for-each-instruction-separately)
    * [Gathering instructions into a programme ](#gathering-instructions-into-a-program)
 * [Observations](#observations)
 * [Documentation used](#documentation-used)
 * [Contact](#contact)

## Objective 

The aim of this exercise was to build a microprocessor using the RISC-V ISA with a VHDL program.

## Programming

The microprocessor was programmed in 3 stages:

### Preparations before instructions 

I began by programming three programs, each representing a part of the microprocessor: the ALU, the registers and the memory.
The ALU allows three bits (funct3) to be analysed in order to carry out the necessary mathematical operation. For the register program, there are 16 32-bit registers, which can be configured for writing or reading. For the memory program, it's almost the same thing, but with 1024 addresses, each with 32 bits of memory.

### Programs for each instruction separately

Each instruction is coded on 32 bits and its structure is different for each one. By looking at the ISA RISC-V datasheet, you can find the structure for each instruction. When we receive bits corresponding to the structure of the instruction, we can then carry out the desired instruction. Each instruction has different commands and acts on the memory and registers. The most complicated instructions were "beq" and "jal" because they are very complicated to execute, but in general, if you spend time understanding the datasheet, execution is fairly logical.

### Gathering instructions into a program

Gathering the instructions was quite complicated and painstaking. Each instruction analysis may be different, so the instruction must be processed for each case.
We then reused the code we had previously produced and nested them together. The most complicated part was managing all the signals with the port maps.

## Observations 

One of the points I didn't really understand about this programme was the way the outputs were managed. In fact, I didn't know how the microprocessor outputs were configured since we're acting on the memory. Nevertheless, I left the result of the ALU at the output. 
I therefore obtained a consumption of 14 LUTs, 46 Slice Registers and 56 Bounded IOBs. From this observation, I have the impression that the hardware used is only for the ALU and not for the registers and memories. In addition, the power consumption is 70mW. So the power consumption is lower than it should be by a few Watts. Nevertheless, this shows that the ALU is taken into account.
In the end, the complexity of this exercise was very high but when I was able to review some of the concepts I had seen in S6. I was able to reinforce these and learn some new ones. 

## Documentation used 

* https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf
* https://fr.wikipedia.org/wiki/RISC-V
* https://itnext.io/risc-v-instruction-set-cheatsheet-70961b4bbe8

## Contact

Created by [@nemocazin] 