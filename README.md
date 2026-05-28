# Elevator Control System using Verilog

## Overview

This project implements a **Finite State Machine (FSM)-based Elevator Controller** using **Verilog HDL**.
The system simulates the operation of a multi-floor elevator with floor request handling, movement control, door operations, and return-home functionality.

The design was developed and verified using **Xilinx Vivado**.

---

## Features

* FSM-based elevator control
* Supports 4-floor elevator operation
* Handles floor requests using priority encoding
* Controls:

  * Elevator movement (Up/Down/Stop)
  * Door opening and closing
  * Floor display indicators
* Automatic return-to-ground-floor functionality
* Modular RTL design
* Testbench included for functional verification
* Simulation waveform validation

---

## Technologies Used

* **Language:** Verilog HDL
* **Tool:** Xilinx Vivado
* **Concepts:** FSM Design, RTL Design, Digital Logic Design

---

## Elevator FSM States

| State       | Description                      |
| ----------- | -------------------------------- |
| IDLE        | Waits for floor requests         |
| MOVE_UP     | Elevator moves upward            |
| MOVE_DOWN   | Elevator moves downward          |
| OPEN_DOOR   | Opens elevator door              |
| CLOSE_DOOR  | Closes elevator door             |
| RETURN_HOME | Returns elevator to ground floor |
| RETURN_BACK | Returns to previous target floor |

---

## Inputs and Outputs

### Inputs

| Signal               | Description            |
| -------------------- | ---------------------- |
| `clk`                | System clock           |
| `reset`              | Resets elevator system |
| `request[3:0]`       | Floor request buttons  |
| `current_floor[1:0]` | Current floor sensor   |

### Outputs

| Signal               | Description            |
| -------------------- | ---------------------- |
| `motor[1:0]`         | Elevator motor control |
| `door_open`          | Door control signal    |
| `floor_display[1:0]` | Current floor display  |

---

## Motor Encoding

| Motor Value | Operation |
| ----------- | --------- |
| `00`        | Stop      |
| `01`        | Move Up   |
| `10`        | Move Down |

---

## Project Architecture

```text
                    +------------------+
                    |  Request Inputs  |
                    +------------------+
                              |
                              v
                    +------------------+
                    | FSM Controller   |
                    +------------------+
                      |      |      |
             ---------       |       ---------
            v                v                v
      +-----------+    +-----------+    +-----------+
      | Motor     |    | Door Ctrl |    | Floor     |
      | Controller|    | Logic     |    | Display   |
      +-----------+    +-----------+    +-----------+
```

---

## Simulation Flow

1. Reset elevator system
2. Send floor request
3. Elevator moves toward target floor
4. Door opens at destination
5. Door closes after operation
6. Elevator returns to ground floor
7. System waits for next request

---

## How to Run

### Using Xilinx Vivado

1. Open Vivado
2. Create a new RTL project
3. Add:

   * `src/elevator.v`
   * `tb/elevator_tb.v`
4. Run Simulation
5. Observe waveform outputs

---

## Simulation Results

### Functional Verification

* Verified elevator movement between floors
* Verified door operations
* Verified return-home mechanism
* Verified floor display updates

---

## Screenshots

Add the following images inside the `screenshots/` or `docs/` folder:

* RTL Schematic
* Simulation Waveform
* Timing Analysis
* Power Analysis

Example:

```markdown
![Waveform](screenshots/simulation_waveform.png)
```

---

## Future Improvements

* Multiple elevator support
* Dynamic scheduling algorithm
* Emergency handling system
* Overload protection
* Door obstruction detection
* FPGA hardware implementation
* Seven-segment floor display

---

## Author

**KADARI VENU**

Electronics and Communication Engineering
Interested in:

* RTL Design
* Verification Engineering
* FPGA Design
* Digital System Design

---

## License

This project is open-source and available under the MIT License.
