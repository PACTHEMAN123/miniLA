# LoongArch 5-Stage Pipelined CPU Implementation

## Overview
This project implements a 5-stage pipelined LoongArch CPU supporting 38 base instructions with comprehensive hazard handling. The design has been verified through both simulation(diff-test) and FPGA(ego) implementation.

## Key Features
- 5-stage pipeline (IF, ID, EX, MEM, WB)
- Support for 38 fundamental LoongArch instructions
- Hazard detection and handling mechanisms:
  - Data hazards (forwarding/stalling)
  - Control hazards (static branch prediction/flushing)
- Verified through both trace-based simulation and FPGA implementation

## Repository Structure
The repository contains 4 main branches:

1. `cdp-tests` - Single-cycle implementation for trace verification
2. `ego` - Single-cycle implementation for FPGA deployment
3. `cdp-pipeline` - 5-stage pipelined implementation for trace verification
4. `ego-pipeline` - 5-stage pipelined implementation for FPGA deployment

## Verification

### Trace Testing
- Golden model comparison for functional verification
- Instruction-by-instruction behavior matching
- Pipeline-specific hazard scenario testing

### FPGA Implementation
- Synthesizable RTL design
- Verified on EGO1
- Meets timing constraints at 100MHz