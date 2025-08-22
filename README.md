# APB-Protocol-Verification-using-System-Verilog-
APB bus verification testbench in SystemVerilog – complete flow with random transaction generation and self-checking scoreboard.

This project implements a complete SystemVerilog verification environment for the AMBA APB (Advanced Peripheral Bus) protocol. It includes all the essential components of a modern testbench such as a transaction generator, driver (BFM), monitor, scoreboard, and DUT. The generator creates randomized APB transactions, the driver applies them to the DUT using APB protocol handshaking, and the monitor observes bus activity. The scoreboard maintains a reference memory model to perform self-checking verification by comparing expected and actual results. This environment demonstrates stimulus generation, protocol checking, and functional validation in a structured testbench setup. It is useful for students, beginners, and verification engineers who want to learn or showcase a working APB protocol verification flow in SystemVerilog.

apb_verification/
│
├── apb_config_db.sv   # Global configuration & mailboxes
├── apb_tx.sv          # APB transaction class
├── apb_gen.sv         # Transaction generator
├── apb_bfm.sv         # Bus Functional Model (driver)
├── apb_mon.sv         # Monitor
├── apb_scb.sv         # Scoreboard
├── apb_env.sv         # Environment (connects all components)
├── apb_test.sv        # Test program
├── apb_intf.sv        # APB interface (with clocking blocks & modports)
├── apb_dut.sv         # Design Under Test (simple APB slave model)
├── apb_tb_top.sv      # Top-level testbench module
└── top.svh            # File including all sources

📊 Simulation Flow
1.Generator   (apb_gen) → creates random read/write transactions.
2.BFM         (apb_bfm) → drives APB protocol on the interface.
3.DUT         (apb_dut) → processes read/write operations in internal memory.
4.Monitor     (apb_mon) → captures bus activity.
5.Scoreboard  (apb_scb) → checks correctness of read/write against reference model.
6.Environment (apb_env) → orchestrates all components

✅ Features
-->APB protocol compliant Write and Read transactions.
-->Configurable address range (1KB memory).
-->Randomized transaction generation with constraints.
-->Self-checking Scoreboard for functional verification.
-->Detailed simulation logs with PASS/FAIL statistics.
-->Final memory dump for post-simulation analysis.
