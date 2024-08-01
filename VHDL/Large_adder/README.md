# Generic VHDL models

# __Large adder__

## Table of content

 * [Objective](#objective)
 * [Programming](#programming)
 * [Observations](#observations)
 * [Contact](#contact)

## Objective

The aim of this exercise was to observe the differences in the maximum operating frequency of an adder.

## Programming

First of all, we made a source in order to create an adder with a constant allowing us to modulate the number of bits that we want easily. By analysing the WNS (Worst Negative Stack), we can see that the critical path is located at the carry level.
We then implemented a pipeline by splitting the inputs into two parts: one of low weight and one of high weight. We then put a general hold and created signals to add D flip-flops.

## Observations

We can see that the number of LUTs used is linear with the number of signal bits and that the WNS also increases. The maximum operating frequency then depends on the number of bits used.
We can also see that after implementing the pipeline, the WNS increases by 0.009ns.

## Contact

Created by [@nemocazin] 