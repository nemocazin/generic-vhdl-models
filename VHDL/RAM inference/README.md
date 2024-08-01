# Generic VHDL models

# __RAM Inférence__

## Table of content

 * [Objective](#objective)
 * [Programming](#programming)
    * [Case of RAM memory](#case-of-RAM-memory)
    * [Case of ROM](#case-of-ROM)
 * [Observations](#observations)
 * [Contact](#contact)

## Objective 

The aim of this exercise was to create programs to infer RAM or ROM memory.

## Programming

In both sources, I took inspiration from two sites to design the programs.

### Case of RAM memory

For programming the RAM memory inference, I used this site: (https://stackoverflow.com/questions/57435602/vhdl-correctly-way-to-infer-a-single-port-ram-with-synchronous-read). After synthesis, we find the following values: 
- Block RAM tile(50) = 0.5
- Bounded IOB(106) = 34
- BUFGCTRL (32) = 1

### Case of ROM

For ROM inference programming, I used this site: (https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/ROM-Inference-on-an-Array-VHDL). After synthesis, we find the following values: 
- Block RAM tile(50) = 0.5
- Bounded IOB(106) = 28
- BUFGCTRL (32) = 1

## Observations

First of all, we note that in both cases, the numbers of Block RAM tiles and BUFGCTRL remain the same. However, the number of Bounded IOBs varies. In the case of ROM, there is a reduction in the use of LUTs. For example, there are 34 Bounded IOBs in RAM memory compared with 28 in ROM memory.

## Contact

Created by [@nemocazin] 