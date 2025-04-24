# SPI Slave with RAM Verification using UVM

## Overview
This project presents a **SystemVerilog UVM-based verification environment** for an SPI Slave module integrated with an internal RAM. The environment verifies both the correctness of the SPI communication protocol and the behavior of the connected RAM.

The testbench is modular and reusable, leveraging **multiple UVM agents** and **assertion-based verification** to achieve comprehensive validation.

---

## SPI Structure
![SPI general](https://github.com/MohamedHussein27/I2C-Protocl-with-three-different-slaves/blob/main/Images/General%20Structure.png)

## Key Features

- **Multi-Agent UVM Environment**  
  - **Active SPI Agent**: Drives stimulus to the SPI Slave through serial communication (MOSI, MISO, SCLK, SS).
  - **Passive RAM Agent**: Observes and validates memory transactions without interfering with the DUT.

- **Functional & Protocol Verification**
  - Covers read/write SPI transactions.
  - Validates memory access correctness.
  - Supports various test scenarios including normal operations, error conditions, and corner cases.

- **Assertion-Based Verification**
  - Integrated **SystemVerilog Assertions (SVA)** to enforce protocol-level and memory-level correctness.
  - Two dedicated assertion modules:
    - `SPI_SLV_SVA.sv`: Checks SPI timing, edge behavior, chip select validity, and data alignment.
    - `RAM_SVA.sv`: Monitors correct RAM read/write timing, underflow/overflow protection, and access constraints.

- **Reusable Shared Package**
  - Shared definitions (parameters, typedefs, signals) placed in a central `shared_pkg.sv` file.
  - Promotes reusability across components and avoids redundancy.
  - Used instead of configuration objects for signal sharing to keep setup lightweight and accessible.

---
