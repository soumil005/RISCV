# RISCV
# 🚀 Pipelined RISC-V Processor (RV32I Subset) — SystemVerilog Design

This project implements a **five-stage pipelined RISC-V processor** in **SystemVerilog**, designed around the **RV32I base integer instruction set** (subset only). The processor includes hazard detection and forwarding logic to handle common pipeline hazards and ensures correct execution of control-flow and memory instructions.

## ✅ Supported Instructions

| Type       | Instruction | Description                          |
|------------|-------------|--------------------------------------|
| Arithmetic | `add`       | Register-register addition           |
| Arithmetic | `sub`       | Register-register subtraction        |
| Logical    | `and`       | Bitwise AND                          |
| Logical    | `or`        | Bitwise OR                           |
| Comparison | `slt`       | Set if less than (signed)            |
| Branch     | `beq`       | Branch if equal                      |
| Memory     | `lw`        | Load word from memory                |
| Memory     | `sw`        | Store word to memory                 |

## 🏗️ Pipeline Architecture

The processor follows a classic 5-stage pipeline:

1. **IF (Instruction Fetch)**
2. **ID (Instruction Decode & Register Fetch)**
3. **EX (Execute / ALU)**
4. **MEM (Memory Access)**
5. **WB (Write Back)**

### ⛓️ Hazard Handling

- **Data hazards** handled via:
  - **Forwarding unit**
  - **Hazard detection unit**
- **Control hazards** are handled with simple pipeline stalling.

---

### 🧠 Design Overview
This project implements a five-stage pipelined RISC-V processor in SystemVerilog, supporting a subset of the RV32I instruction set. The processor is capable of executing basic arithmetic, logic, memory access, and control flow operations. It also handles data hazards and control hazards, including lw-beq situations, using a dedicated hazard detection unit and forwarding logic.

### 🔩 Key Features of the Design
Five-Stage Pipeline:

1. IF (Instruction Fetch) — Fetches the instruction from instruction memory (INMEM)
2. ID (Instruction Decode) — Decodes instruction, reads register operands, and generates control signals
3. EX (Execute) — Performs ALU operations and computes branch targets
4. MEM (Memory Access) — Reads from or writes to data memory (DMEM)
5. WB (Write Back) — Writes results back to the register file

### Hazard Detection: 
  Implements a dedicated Hazard Unit to detect and handle:
      -> Data hazards (e.g., RAW)
      -> Load-use hazards (lw followed by a dependent instruction)
      -> Control hazards from branches (beq)

  Uses forwarding paths and stall/flush mechanisms to preserve correctness without unnecessary stalls

  Memory Model: 
    -> Separate instruction (INMEM) and data (DMEM) memories modeled as byte-addressable arrays
    -> Word-aligned load and store operations (32-bit lw, sw)

  Register File:
    -> Supports reading two source registers and writing one destination register per cycle
    -> Write-back is done in the WB stage using a multiplexer based on the ResultSrc control signal
  
  Control Logic:
    -> Includes a ControlUnit for instruction decoding and signal generation
    -> ImmGen extracts immediate values based on instruction type
  
  Pipeline Registers:
    -> Includes all standard inter-stage registers: IF_ID, ID_EX, EX_MEM, and MEM_WB
    -> Carries both data and control signals across stages
  
  Stall and Flush Control:
    -> StallF and StallD signals hold pipeline stages during hazards
    -> FlushD and FlushE flush pipeline stages when necessary

### Architecture: 
<img width="1524" height="969" alt="image" src="https://github.com/user-attachments/assets/3e860c41-6749-46a9-ba2b-595bb61c63fc" />

### 🧪 Testbench
A comprehensive testbench is written to validate the functionality of the pipelined RISC-V processor. The testbench performs the following:

  -> Clock & Reset Generation: A periodic clock signal with 10 ns cycle time and proper reset sequencing is implemented.
  
  -> Memory Initialization:
      1. INMEM: Instruction memory is loaded manually with a custom instruction sequence covering most instruction types (add, sub, or, lw, sw, beq, slt, and).
      2. DMEM: Data memory is preloaded with values to support load/store instructions.

  -> Register Initialization: General-purpose registers (x1, x2, etc.) are initialized with known values to trace operations easily.

  -> Hazard Testing:
      1. The test includes a classic load-use hazard, where lw is immediately followed by a beq that uses the loaded value.
      2. The processor’s pipeline is expected to handle this through stalling or forwarding logic.

  -> Correctness Checks: After simulation:
      1. Output register values are printed using $display.
      2. The expected outputs are verified against actual outputs.
      3. If all conditions match, "**Test Passed**" is printed; otherwise, "**Test Failed**" is displayed.

### 📌 Instruction Sequence
add x3, x1, x2         # x3 = 5 + 10 = 15
sub x4, x3, x1         # x4 = 15 - 5 = 10
sw x4, 0(x0)           # MEM[0] = x4 = 10
lw x5, 0(x0)           # x5 = MEM[0] = 10
beq x4, x5, 8          # branch taken -> skips instruction, x6 = 0
add x6, x0, x0         # skipped due to branch
slt x8, x1, x2         # x8 = (5 < 10) = 1
add x6, x1, x2         # x6 = 5 + 10 = 15
and x10, x1, x2        # x10 = 5 & 10
or x11, x1, x2         # x11 = 5 | 10

This testbench validates both the functional correctness and basic pipeline hazard handling of the RISC-V processor implementation.
