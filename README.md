# 🧪 APB Bus Verification Testbench in SystemVerilog
A complete SystemVerilog-based verification environment for the AMBA APB (Advanced Peripheral Bus) protocol. This testbench features randomized transaction generation, protocol-accurate bus functional modeling, passive monitoring, and a self-checking scoreboard — all designed to validate read/write operations against a memory-backed DUT.

## 📦 Project Structure
```
apb_tb/
├── apb_tx.sv         // Transaction class with constraints
├── apb_gen.sv        // Generator: randomized stimulus
├── apb_bfm.sv        // Bus Functional Model: drives DUT
├── apb_mon.sv        // Monitor: observes interface
├── apb_scb.sv        // Scoreboard: checks correctness
├── apb_env.sv        // Environment: orchestrates components
├── apb_test.sv       // Test program
├── apb_intf.sv       // APB interface with clocking blocks
├── apb_dut.sv        // DUT: APB-compliant memory model
├── apb_tb_top.sv     // Top-level testbench
├── top.svh           // Include file for compilation
├── run.do            // Simulation script for ModelSim
```

---
🚀 Features

- ✅ **Randomized Transaction Generation**  
  Weighted distribution of read/write operations with address and data constraints.

- ✅ **Protocol-Compliant BFM**  
  Drives APB signals in setup/access/idle phases with proper `psel`, `penable`, and `pready` handling.

- ✅ **Passive Monitor**  
  Observes transactions during the ACCESS phase and forwards them to the scoreboard.

- ✅ **Self-Checking Scoreboard**  
  Maintains a reference memory model and compares DUT read data against expected values.

- ✅ **Functional Logging**  
  Time-stamped `$display` statements for every transaction and scoreboard result.

- ✅ **Final Report**  
  Summary of pass/fail counts and success rate at end of simulation.

---

## 🧠 Verification Flow

1. **Generator (`apb_gen`)**  
   Produces alternating write-read pairs to validate memory behavior.

2. **BFM (`apb_bfm`)**  
   Drives APB interface using clocking block and waits for `pready`.

3. **Monitor (`apb_mon`)**  
   Samples transactions during valid protocol windows and sends them to the scoreboard.

4. **Scoreboard (`apb_scb`)**  
   Compares DUT output with reference model and logs results.

5. **Environment (`apb_env`)**  
   Forks all components and runs them in parallel.

---

## 🛠️ How to Run

### 🧾 Compile
```tcl
vlog -work work -vopt -sv -stats=none top.svh
```

### ▶️ Simulate
```tcl
vsim -voptargs=+acc -l output.log work.apb_tb_top -l log.txt
add wave -position insertpoint sim:/apb_tb_top/intf/*
run -all
```

---

## 📊 Sample Output

```text
✅ WRITE: Addr=0x0000001F Data=0x000000A5
✅ READ:  Addr=0x0000001F (expecting 0x000000A5)
SCB: ✅ READ PASS
SCB STATS: Pass=2 Fail=0
```

---

## 📚 Protocol Reference

This testbench adheres to the **AMBA APB v2.0** protocol:
- Setup phase: `psel=1`, `penable=0`
- Access phase: `psel=1`, `penable=1`
- Completion: wait for `pready=1`

---

## 🧩 Future Enhancements

- Functional coverage integration  
- Error injection and `pslverr` handling  
- Multi-slave APB support  
- UVM-style sequence layering

---

