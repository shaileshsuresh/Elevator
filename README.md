**Elevator Controller – VHDL
Overview**

This project implements a synthesizable elevator (lift) controller in VHDL using a finite state machine (FSM). The design models elevator movement across multiple floors, request handling, and door control while following industry-standard RTL design practices.

**Key Features**

FSM-based control logic

Single-clock, clock-enable–based architecture (no derived clocks)

Event-based floor request handling

Bounded floor tracking for safe operation

**Design Files**

lift.vhdl – Elevator controller RTL

clock_divider.vhdl – Clock-enable generator

top.vhdl – Top-level integration

**Testbench File**

top_tb.vhdl – Self-checking testbech for the top design
**Tools**

Language: VHDL

Simulation: ModelSim (or equivalent)

**Notes**

This project emphasizes clean RTL structure, deterministic simulation behavior, and hardware-safe design, making it suitable for FPGA or ASIC design flows.

