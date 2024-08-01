# Generic VHDL models

# __Multiplier__

## Table of content

 * [Objective](#objective)
 * [Programming](#programming)
 * [Asynchronous case](#asynchronous-case)
 * [Synchronous case](#synchronous-case)
 * [Observations](#observations)
 * [Contact](#contact)

## Objective

The aim of this exercise was to observe the differences between a multiplier with an asynchronous reset and a multiplier with a synchronous reset.

## Programming

In both sources, we have the same multiplier with two inputs to be multiplied, a clock and a reset. Genericity is added to both programs so that comparisons can be made with several numbers of bits.

### Asynchronous case

When programming the asynchronous multiplier, care must be taken to separate the management of the reset and the clock so that the reset is not triggered on a rising edge of the clock.

### Synchronous case

When programming the asynchronous multiplier, the opposite must be done, i.e. the reset is managed when a rising edge of the clock is present. 

## Observations

First of all, we note that in both cases, the numbers of DSPs and bounded IOBs remain the same as a function of the number of bits. However, the number of LUTs varies. In the case of synchronous, there is a reduction in the use of LUTs. For example, in the case of 16-bit asynchronous, 16 LUTs are used compared with 0 LUTs in the case of synchronous. This is because synchronous is already managed in the DSPs, so LUTS have to be used to manage the asynchronous reset. 

## Contact

Created by [@nemocazin] 