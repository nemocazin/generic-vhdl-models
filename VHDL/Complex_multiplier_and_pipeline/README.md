# Generic VHDL models

# __Complex multiplier__

## Table of content

 * [Objective](#objective)
 * [Programming](#programming)
 * [Observations](#observations)
 * [Contact](#contact)

## Objective

The aim of this exercise was to observe the differences in the maximum operating frequency of a complex multiplier.

## Programming

First of all, we made a source in order to create a complex multiplier. We then improved the algorithm using Karatsuba's method. We then noticed that we could improve performance by implementing a pipeline.

## Observations

We can see that the more steps we implement in the pipeline, the more the maximum operating frequency increases.
You can also see that the more stages you add to the pipeline, the greater the energy consumption.
The difficulty with this exercise is signal management. You have to be careful how you implement them, and don't forget to put D flip-flops at the end and beginning of the diagram.

## Contact

Created by [@nemocazin] 