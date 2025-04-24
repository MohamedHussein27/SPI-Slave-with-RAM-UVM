# SPI Slave with RAM Verification using UVM

## Overview
This project presents a **SystemVerilog UVM-based verification environment** for an SPI Slave module integrated with an internal RAM. The environment verifies both the correctness of the SPI communication protocol and the behavior of the connected RAM.

The testbench is modular and reusable, leveraging **multiple UVM agents** and **assertion-based verification** to achieve comprehensive validation.

---

## SPI Structure
![SPI general](https://github.com/MohamedHussein27/SPI-Slave-with-RAM-UVM/blob/main/Images/SPI%20RAM%20general.png)

### Specifications
-	In write address state: first received bit by MOSI is **“0”** followed by two other zeros **“2’b00”**.
-	In write data state: first received bit by MOSI is **“0”** followed by zero then one **“2’b01”**.
-	In read address state: first received bit by MOSI is **“1”** followed by one then zero **“2’b10”**.
-	In read data state: first received bit by MOSI is **“1”** followed by two other ones **“2’b11”**.
> **Note:** •	If you want to know more about Specs try checking the Design Repository: [SPI Slave with single port RAM](https://github.com/MohamedHussein27/SPI_Slave_With_Single_Port_Memory)

---

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

## Verification
> **Note:** In QuestaSim simulation snapshots, the Wrapper will be highlighted in gold, while the Slave in cyan and RAM in dark red for clarity and differentiation.

### SPI Wrapper

- UVM Structure
![Wrapper UVM](https://github.com/MohamedHussein27/SPI-Slave-with-RAM-UVM/blob/main/Images/SPI%20UVM%20Structure.png)

- Full Waveform
![Full Wrapper](https://github.com/MohamedHussein27/SPI-Slave-with-RAM-UVM/blob/main/Images/Full%20Wrapper.png)

- Functional Coverage **100%**
![Functoinal Wrapper](https://github.com/MohamedHussein27/SPI-Slave-with-RAM-UVM/blob/main/Images/Functional%20Wrapper.png)

- Assertions Coverage 
![Assertions Wrapper](https://github.com/MohamedHussein27/SPI-Slave-with-RAM-UVM/blob/main/Images/Assertions%20Wrapper.png)
All assertions are passed!

- UVM Report
![Report Wrapper](https://github.com/MohamedHussein27/SPI-Slave-with-RAM-UVM/blob/main/Images/Report%20Wrapper.png)

### SPI Slave

- UVM Structure
![Slave UVM](https://github.com/MohamedHussein27/SPI-Slave-with-RAM-UVM/blob/main/Images/Slave%20UVM%20structure.png)

- UVM Report
![Report Wrapper](https://github.com/MohamedHussein27/SPI-Slave-with-RAM-UVM/blob/main/Images/Report%20Slave.png)

### RAM

- UVM Structure
![Slave UVM](https://github.com/MohamedHussein27/SPI-Slave-with-RAM-UVM/blob/main/Images/RAM%20UVM%20Structure.png)

- UVM Report
![Report Wrapper](https://github.com/MohamedHussein27/SPI-Slave-with-RAM-UVM/blob/main/Images/Report%20RAM.png)

-- 
For more details try checking the [project Documentation](https://github.com/MohamedHussein27/SPI-Slave-with-RAM-UVM/blob/main/Documentation/SPI%20using%20UVM.pdf)

---

## Contact Me!
- [Email](mailto:Mohamed_Hussein2100924@outlook.com)
- [WhatsApp](https://wa.me/+2001097685797)
- [LinkedIn](https://www.linkedin.com/in/mohamed-hussein-274337231)