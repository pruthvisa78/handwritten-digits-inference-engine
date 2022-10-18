--------------Files Description-------------------------------
Digit.txt             : Text file that contains output digits corresponding to test sample of 493 digits(For accuracy check).
lfsr.v                : Verilog module for LFSR logic.
max.v                 : Verilog module to find maximum value of 10 output accumulators and map them to standard output format.
MUL_16.v              : Verilog module for 16x16 signed multiplication that gives 32-bit output.
ROM_W21.v             : Verilog module that acts as ROM for W21 weights.
test_bench.v          :	Test bench for simulation 10 test inputs(same test sample taken in demo.m).
test_bench_accuracy.v : Test bench for simulation of  all 493 test samples (Gives count as output, accuracy = count/493).
top_module.v          : Verilog module which performs ELM inference (Submodules: lfsr.v, max.v, MUL_16.v, ROM_W21.v). 
test_patt.txt         : Text file that contains 493 test patterns as 493x16 array (Each input is chuncked into 16 16-bit vectors).

--------------Instructions for Simulation--------------------- 
To simulate for accuracy check: 
Testbench file:test_bench_accuracy.v (Include: test_patt.txt, Digit.txt).
Verilog Module: top_module.v (Include: lfsr.v, max.v, ROM_W21.v, MUL_16.v).

To simulate same 10 digits taken as in demo.m:
Testbench file:test_bench.v
Verilog Module: top_module.v (Include: lfsr.v, max.v, ROM_W21.v, MUL_16.v).