VHDL Implementation of a Three-Layer Neural Network for Digit Recognition
This repository contains the VHDL (VHSIC Hardware Description Language) implementation of a three-layer neural network designed to identify 32x32 pixel images of digits 0 to 9. The neural network achieves an impressive 98% accuracy on digit recognition. Additionally, the clock speed of the implementation is set to 20ns by default, with an option to reduce it to 15ns for improved efficiency.

Overview
The neural network is implemented in VHDL, targeting hardware acceleration for digit recognition. The three-layer architecture includes an input layer, a hidden layer, and an output layer. The implementation is tailored to process 32x32 pixel images, and through training, it achieves a high accuracy of 98% on identifying digits.
The default configuration achieves 4 MACs per cycle, with the option to boost performance to 8 MACs through dual memory access. A pipeline design and memory arrangement can be employed to push the system to 512 MACs per cycle.

full vivado file in:
https://drive.google.com/file/d/1ymYPck-WfANMvHxXjA2LwWzIdDK7oeOg/view?usp=sharing
