# General Purpose Pipelined RISC-V Processor (8-bit)

## Table of Contents
1. [Authors](#authors)
2. [Introduction and Motivation](#introduction-and-motivation)
3. [Design Space Exploration and Design Strategies](#design-space-exploration-and-design-strategies)
4. [Testbench Case Implementation](#testbench-case-implementation)
5. [Implementation Challenges](#implementation-challenges)
6. [Results](#results)
7. [Conclusion](#conclusion)
8. [References](#references)
9. 
## Authors
1. [UJJWAL CHAUDHARY](https://www.linkedin.com/in/ujjwal-chaudhary-4436701aa/)
2. [ANANYA PAL](https://www.linkedin.com/in/ananya-pal-snuece2023/)

## Introduction and Motivation

In the fast-evolving landscape of embedded systems and IoT devices, the demand for high-performance, energy-efficient processors is ever-increasing. To meet this demand, we propose the design and implementation of an 8-bit RISC-V processor with advanced features such as a 5-stage pipeline and bypassing. This project aims to create a processor that not only meets the performance requirements of modern embedded systems but also addresses the challenges of power consumption and area utilization. By leveraging the simplicity and flexibility of the RISC-V instruction set architecture, we seek to deliver a processor that is both efficient and versatile, capable of powering a wide range of embedded applications.

### Figure 1: Implemented RISC V processor Block Diagram [1].
<img src=".\Assets\riscv.png" alt="Alt Text" width="700">

## Design Space Exploration and Design Strategies

The project embraced a top-down approach to Verilog coding, where the overall system architecture was first defined at the highest level i.e., adopting a hierarchical approach, starting from the top-level testbench down to individual functional units namely Instruction Fetch, Instruction Decode, Execute, Memory Access, Writeback (IF, ID, EX, MEM, WB) and finally to preliminary units like Data Memory, ALU, Registers, MUXs etc as shown in figure 1. This hierarchical organization facilitated efficient design refinement and optimization at each level, managing complexity effectively. Given below are the design strategies which were used in the design development process:

1. **Modular Design Approach:** Each functional block was designed as an exclusive module, promoting modularity and facilitating debugging and customization.
2. **Pipelined Architecture:** Initially, a single-cycle RISC-V implementation was done to understand the working with ease and then transitioned to a pipelined architecture in five stages - (IF, ID, EX, MEM, WB).
3. **Instruction Set Expansion:** The instruction set was expanded to include additional functionalities such as XOR, NOT, unconditional jump (JAL), and branch if equal (BEQ). This expansion enhanced the versatility and capability of the RISC-V architecture.
4. **Data Hazard Mitigation:** Data forwarding mechanisms were incorporated to mitigate data hazards and improve pipeline efficiency. Strategic insertion of NOP instructions helped to stall the pipeline when necessary, enhancing hazard handling.
5. **Testing and Verification:** Rigorous testing and verification were done with possible critical cases and including a combination of instructions in an implementation.

### Table 1: RISC-V instruction types format.

| Instruction | 31:25 | 24:20 | 19:15 | 14:12 | 11:7 | 6:0 |
|-------------|-------|-------|-------|-------|------|-----|
| R-type      | funct7| rs2   | rs1   | funct3| rd   | opcode |
| I-type      | immediate[11:0] | rs1 | funct3 | rd | opcode |
| S-type      | immediate[11:5] | rs2 | rs1 | funct3 | immediate[4:0] | opcode |
| SB-type     | immediate[11:5] | rs2 | rs1 | funct3 | immediate[4:0] | opcode |
| UJ-type     | immediate[11:0] | x   | x   | x     | x | x | x | x | x | x | x | x | opcode |

### Table 2: RISC-V instruction types control signals.

| Instruction | ALUSrc | Mem-to-Reg | Reg-Write | Mem-Read | Mem-Write | Branch | ALUOp1 | ALUOp0 |
|-------------|--------|------------|-----------|----------|-----------|--------|--------|--------|
| R-type      | 0      | 0          | 1         | 0        | 0         | 0      | 1      | 0      |
| I-type      | 1      | 1          | 1         | 1        | 0         | 0      | 0      | 0      |
| S-type      | 1      | X          | 0         | 0        | 1         | 0      | 0      | 0      |
| SB-type     | 0      | X          | 0         | 0        | 0         | 1      | 0      | 1      |
| UJ-type     | 1      | 0          | 1         | 0        | 0         | 1      | 1      | 1      |

### Table 3: RISC-V instruction included in design with opcodes.

| S No. | Instruction | opcode | funct7 | funct3 |
|-------|-------------|--------|--------|--------|
| 1     | ld          | 0000011| x      | x      |
| 2     | sd          | 0100011| x      | x      |
| 3     | beq         | 1100011| x      | x      |
| 4     | add         | 0011011| 0000000| 000    |
| 5     | sub         | 0011011| 0100000| 000    |
| 6     | and         | 0011011| 0000000| 111    |
| 7     | or          | 0011011| 0000000| 110    |
| 8     | xor         | 0011011| 0000000| 100    |
| 9     | not         | 0011011| 0000000| 100    |
| 10    | jal         | 1101111| x      | x      |
| 11    | nop         | 0000000| 0000000| 000    |


## Testbench Case Implementation

To test the functionality of the RISC-V architecture, a sequence of code is executed to manipulate arbitrary numbers stored in memory locations. In this sequence, we are iterating through each number and performing a conditional operation (beq) based on its parity. Specifically, if a number is odd, one is added to it, otherwise, one is subtracted. After performing the operation, the updated number is stored back into the same memory location. This process effectively toggles the parity of each number, ensuring that even numbers become odd and odd numbers become even. By executing this sequence, we can verify the correct functioning of our RISC-V architecture, including the proper execution of arithmetic operations and memory access instructions. Additionally, this test helps validate the correctness of the instruction decoding and execution mechanisms within the processor design.

### Figure 2: Flow chart for the testbench instruction set.
<img src=".\Assets\flow-chart.png" alt="Alt Text" width="700">

### Table 4: Testbench assembly code equivalent.

| SR No. | Mnemonics | Operation | Instruction Bits [32:0] |
|--------|-----------|-----------|-------------------------|
| 1      | ld r1, 0, r5 | r1 = MEM[0+r5] | 000000000000_00101_000_00001_0000011 |
| 2      | ld r2, 0, r6 | r2 = MEM[0+r6] | 000000000000_00110_000_00010_0000011 |
| 3      | ld r3, 0, r1 | r3 = MEM[0+r1] | 000000000000_00001_000_00011_0000011 |
| 4      | nop         | -               | 000000000000_00000_000_00000_0000000 |
| 5      | nop         | -               | 000000000000_00000_000_00000_0000000 |
| 6      | nop         | -               | 000000000000_00000_000_00000_0000000 |
| 7      | and r4, r2, r3 | r4 = r2 & r3 | 0000000_00011_00010_111_00100_0110011 |
| 8      | beq r4, r2, 8 | if (r4 == r2) PC = PC + 10 | 0000000_00010_00100_000_01010_1100011 |
| 9      | nop         | -               | 000000000000_00000_000_00000_0000000 |
| 10     | nop         | -               | 000000000000_00000_000_00000_0000000 |
| 11     | nop         | -               | 000000000000_00000_000_00000_0000000 |
| 12     | sub r3, r2, r3 | r3 = r2 - r3 | 0100000_00010_00011_000_00011_0110011 |
| 13     | sd r3, 0, r1 | MEM[0+r1] = r3 | 0000000_00011_00001_000_00000_0100011 |
| 14     | jal 6       | PC = PC + 6    | 0000000_00110_00000_000_00000_1101111 |
| 15     | nop         | -               | 000000000000_00000_000_00000_0000000 |
| 16     | nop         | -               | 000000000000_00000_000_00000_0000000 |


## Implementation Challenges

While developing the RISC-V processor on FPGA, several implementation challenges emerged. One significant hurdle encountered was the intricate task of wiring each module within the hierarchical floorplan. Writing down and testing with relevant test cases. Moreover, the utilization of Block RAM (BRAM) to implement memory blocks presented its own set of challenges. Optimizing BRAM usage while adhering to performance and resource constraints necessitated careful consideration of memory access patterns and efficient data storage techniques. Also, coming up with writing relevant test cases to validate the functionality and performance of each module also one of the major challenges after developing the design.

## Results

From figure 3, we observe a close resemblance of our design to the reference block diagram from which we started off in the beginning in figure 1.

- **RTL Synthesis:** The design closely resembles the reference block diagram, demonstrating successful [RTL synthesis](/Assets/schematics.pdf).
- **Timing Analysis:** The design meets timing requirements, with a maximum operating frequency of approximately 45 MHz.<img src=".\Assets\time.png" alt="Alt Text" width="700">
- **Resource Utilization:** The design utilizes hardware resources efficiently, with detailed breakdowns provided for logic elements, registers, memory blocks, and I/O resources.<img src=".\Assets\resource.png" alt="Alt Text" width="700">

## Conclusion

In conclusion, the development of our General Purpose Pipe-lined RISC-V Processor (8-bit) represents a significant step towards meeting the demands of modern embedded systems and IoT devices. By leveraging the simplicity and flexibility of the RISC-V instruction set architecture, we have designed a processor with advanced features such as a 5-stage pipeline and bypassing. Our design strategies, including modular design, pipe-lined architecture, instruction set expansion, data hazard mitigation, and rigorous testing, have contributed to the efficiency and versatility of our processor. Our results demonstrate successful RTL synthesis, timing analysis, and resource utilization, affirming the viability of our processor for real-world applications.

Moving forward, we aim to further refine our design, explore optimization opportunities, and contribute to the growing ecosystem of RISC-V-based embedded systems like incorporating a dedicated data hazard unit to mitigate hazards caused by dependencies between instructions, integrating a branch prediction unit to predict conditional branch outcomes and pre-fetch instructions accordingly, and optimizing the design for higher operating frequencies to achieve greater throughput. Additionally, enhancements such as memory access efficiency improvements, support for multi-core processing, energy-efficient design techniques, and the addition of custom instruction set extensions tailored to specific application domains can further enhance the processor’s capabilities.

## References

[1] Computer Organization and Design: The Hardware/Software Interface by David A. Patterson, John L. Hennessy by MERL DSU

[2] Udemy Course: Building a Processor with Verilog HDL from Scratch by Kumar Khandagle

[3] NPTEL: IIT Kgp. Hardware Modeling Using Verilog by Prof. Indranil Sen Gupta
