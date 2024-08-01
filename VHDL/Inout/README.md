# Generic VHDL models

# __Inout__

## Table of content

 * [Objective](#objective)
 * [Programming](#programming)
 * [Observations](#observations)
 * [Contact](#contact)

## Objective 

The aim of this exercise was to create a VHDL program to control an input or output bus.

## Programming

I therefore initialised an inout bus, controlled by an input that allows the "inout" bus to be controlled either as an input or as an output.
If the bus is in input, the bus writes data, otherwise it sends data to output. 

## Observations

I observed the programme after it had been synthesised and implemented. In both cases, the diagram is exactly the same.
Then, for hardware use, in the case of synthesis, we find that 2 Slice Registers, 4 Bounded IOBs and 1 BUFCTRL are used. In the case of implementation, we also use the same hardware plus 2 Slices.
Finally, in terms of energy use, the consumption is 18.8W for synthesis and 14.1W for implementation.
We can see that the implementation consumes less energy but more hardware than the synthesis. However, the electrical diagram is not affected by these modifications. This suggests that the FPGA has been modified and optimised internally.

## Contact

Created by [@nemocazin] 