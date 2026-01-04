# FPGA Vending Machine Controller

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![FPGA](https://img.shields.io/badge/FPGA-Nexys_A7-green)
![FSM](https://img.shields.io/badge/design-FSM-orange)

## 📋 Description

A complete **vending machine controller** implemented in Verilog for the Nexys A7-100T FPGA board using a Finite State Machine (FSM) design. The system manages product selection, payment processing, product dispensing, and change return, simulating a real-world vending machine operation.

Developed as Laboratory Project 3 for the EL-3310 Digital Systems Design course at Costa Rica Institute of Technology (TEC).

## 🎯 Key Features

### State Machine Design
- ✅ **5-State FSM** - INICIO → SELECCION → PAGO → DISPENSANDO → CAMBIO
- ✅ **Product selection** - 4 different products with real prices (₡350-₡1100)
- ✅ **Payment processing** - Accepts ₡50, ₡100, and ₡500 coins
- ✅ **Change calculation** - Automatic change return for overpayment
- ✅ **Product dispensing** - LED indicator with blinking effect
- ✅ **Error handling** - Robust state transitions and input validation

### User Interface
- 🎮 **Switch controls** - Product selection (SW[1-4]), Payment (SW[5-7])
- 🖥️ **8 7-segment displays** - Show state, price, payment, and change
- 📜 **Scrolling text** - Product names scroll across displays
- 💡 **LED indicator** - Blinking LED when product ready to collect
- 🔘 **Button controls** - Confirm (SW[0]), Collect product (BTNR), Reset (BTNC)

### Products Available
- 🥤 **Product 1:** GINGER - ₡400
- 🥤 **Product 2:** COCA - ₡800
- 🥤 **Product 3:** POP - ₡1100
- 🍫 **Product 4:** GRANUTS - ₡350

## 🛠️ Technologies Used

- **HDL**: Verilog (IEEE 1364-2005)
- **FPGA**: Nexys A7-100T (Artix-7 XC7A100T)
- **IDE**: Xilinx Vivado Design Suite
- **Design Pattern**: Finite State Machine (FSM)
- **Display**: 8 common anode 7-segment displays
- **Clock**: 100 MHz onboard oscillator

## 📦 Requirements

### Hardware
- Nexys A7-100T FPGA board
- USB cable for programming
- Power supply

### Software
- Xilinx Vivado Design Suite (2018.2+)
- Windows/Linux OS
- Digilent board files

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/AlbertoDAMG30/fpga-vending-machine.git
cd fpga-vending-machine
```

### 2. Open in Vivado
```
File → Project → Open Project
Select project file in repository
```

### 3. Synthesize and Program
```
Flow → Run Synthesis
Flow → Run Implementation
Flow → Generate Bitstream
Flow → Program Device
```

## 📂 Project Structure

```
fpga-vending-machine/
├── main.v                       # Top-level module
├── vending_machine_fsm.v       # FSM controller (5 states)
├── producto_scroll.v           # Product name scrolling animation
├── display_controller.v        # 7-segment display driver
├── divisor_reloj.v             # Clock divider module
├── Nexys-A7-100T-Master.xdc   # Pin constraints
├── README.md                   # This file
└── Proyectos_Lab3_IS2025.pdf  # Project specifications (Spanish)
```

## 🎮 How to Use

### Basic Operation Flow

```
1. INICIO (Start)
   ↓ (Wait 2 seconds)
2. SELECCION (Selection)
   ↓ (Select product SW[1-4] + confirm SW[0])
3. PAGO (Payment)
   ↓ (Insert coins SW[5-7] until paid)
4. DISPENSANDO (Dispensing)
   ↓ (Collect product BTNR)
5. CAMBIO (Change) - if applicable
   ↓ (Collect change BTNR)
   Return to SELECCION
```

### Control Mapping

| Input | Function |
|-------|----------|
| **SW[0]** | Confirm selection / Cancel operation |
| **SW[1]** | Select Product 1 (GINGER - ₡400) |
| **SW[2]** | Select Product 2 (COCA - ₡800) |
| **SW[3]** | Select Product 3 (POP - ₡1100) |
| **SW[4]** | Select Product 4 (GRANUTS - ₡350) |
| **SW[5]** | Insert ₡50 coin |
| **SW[6]** | Insert ₡100 coin |
| **SW[7]** | Insert ₡500 coin |
| **BTNC** | Reset machine (BTNC) |
| **BTNR** | Collect product/change (BTNR) |
| **LED[0]** | Product ready indicator (blinking) |

### Display Layout

**State: INICIO (Start)**
```
Displays: [H][O][L][A]
Duration: ~2 seconds
```

**State: SELECCION (Selection)**
```
Without selection: [E][L][I][G][E] (Choose in Spanish)
With selection:    Product name scrolls across all 8 displays
Example: [1][.][G][I][N][G][E][R] scrolling
```

**State: PAGO (Payment)**
```
Upper displays (7-4): Product price
Lower displays (3-0): Amount paid
Example: [0][4][0][0][0][2][5][0]
         Price:400   Paid:250
```

**State: DISPENSANDO (Dispensing)**
```
Displays: [L][I][S][T][O] (Ready in Spanish)
LED0: Blinking
Action: Press BTNR to collect
```

**State: CAMBIO (Change)**
```
Upper displays: [C][A][M][B]
Lower displays: Change amount
Example: [C][A][M][B][0][2][0][0]
         Change: ₡200
```

## 🔧 FSM State Diagram

```
       ┌─────────┐
  ┌───▶│ INICIO  │◀─┐ BTNC (Reset)
  │    └─────────┘  │
  │         │        │
  │    Auto (2s)    │
  │         │        │
  │         ▼        │
  │    ┌──────────┐  │
  │    │SELECCION │  │
  │    └──────────┘  │
  │         │        │
  │   SW[1-4]+SW[0] │
  │         │        │
  │         ▼        │
  │    ┌─────────┐   │
  │    │  PAGO   │   │
  │    └─────────┘   │
  │         │        │
  │   Amount>=Price │
  │         │        │
  │         ▼        │
  │  ┌────────────┐  │
  │  │DISPENSANDO │  │
  │  └────────────┘  │
  │         │        │
  │      BTNR       │
  │         │        │
  │         ▼        │
  │    ┌────────┐    │
  └────│ CAMBIO │────┘
       └────────┘
    (if change>0)
```

## 📊 State Descriptions

### State 0: INICIO (Start/Idle)
- **Purpose**: Welcome screen
- **Display**: "HOLA" (Hello in Spanish)
- **Duration**: ~2 seconds
- **Transition**: Automatically to SELECCION
- **Reset**: Any time via BTNC

### State 1: SELECCION (Product Selection)
- **Purpose**: Select product to purchase
- **Displays**: 
  - No selection: "ELIGE" (Choose)
  - With selection: Product name scrolling
- **Controls**:
  - SW[1-4]: Select product
  - SW[0]: Confirm selection → PAGO
- **Scrolling**: Product info scrolls continuously
- **Products**:
  - SW[1]: "1.GINGER ₡400"
  - SW[2]: "2.COCA ₡800"
  - SW[3]: "3.POP ₡1100"
  - SW[4]: "4.GRANUTS ₡350"

### State 2: PAGO (Payment)
- **Purpose**: Accept payment for selected product
- **Display**:
  - Upper (7-4): Product price
  - Lower (3-0): Amount paid so far
- **Controls**:
  - SW[5]: +₡50
  - SW[6]: +₡100
  - SW[7]: +₡500
  - SW[0]: Cancel → SELECCION
- **Transition**: When paid >= price → DISPENSANDO
- **Features**: Accumulates payment, shows real-time balance

### State 3: DISPENSANDO (Dispensing)
- **Purpose**: Product ready to collect
- **Display**: "LISTO" (Ready)
- **LED**: LED0 blinking rapidly
- **Control**: BTNR to collect product
- **Transition**: 
  - If change > 0 → CAMBIO
  - If change = 0 → SELECCION
- **Feature**: Must press button to continue

### State 4: CAMBIO (Change)
- **Purpose**: Return change to user
- **Display**:
  - Upper (7-4): "CAMB" (Change)
  - Lower (3-0): Change amount
- **Control**: BTNR to collect change
- **Transition**: BTNR → SELECCION
- **Calculation**: Change = Paid - Price

## 🧩 Module Descriptions

### main.v (Top Module)
- Instantiates all submodules
- Connects FSM to display controller
- Routes clock signals
- Manages product scrolling animation
- ~112 lines

### vending_machine_fsm.v (FSM Controller)
- Implements 5-state machine
- Handles all state transitions
- Processes payments with edge detection
- Calculates change
- Controls LED blinking
- Generates display data for each state
- ~298 lines

### producto_scroll.v (Product Scrolling)
- Scrolls product names across displays
- 4 product ROM tables
- Smooth right-to-left animation
- Enables only in SELECCION state
- ~200 lines

### display_controller.v (Display Driver)
- Converts 4-bit values to 7-segment codes
- Multiplexes 8 displays
- Supports letters and numbers
- Custom character encoding
- ~70 lines

### divisor_reloj.v (Clock Divider)
- Input: 100 MHz
- Outputs:
  - `clk_slow`: ~6 kHz (multiplexing)
  - `clk_anim1`: ~1.5 Hz (slow animation)
  - `clk_anim2`: ~6 Hz (fast animation)  
  - `clk_anim3`: ~2 Hz (FSM clock)
- ~30 lines

## 🔍 Technical Details

### Payment System
- **Coin values**: ₡50, ₡100, ₡500
- **Detection**: Edge detection prevents double-counting
- **Accumulation**: Running total displayed in real-time
- **Validation**: Only accepts payment when in PAGO state

### Edge Detection
```verilog
// Prevents multiple triggers from single switch action
wire sw_flanco_positivo = sw_actual && !sw_anterior;
```

### Change Calculation
```verilog
if (monto_pagado > precio_producto) begin
    cambio_a_devolver = monto_pagado - precio_producto;
    estado_actual = CAMBIO;
end else begin
    estado_actual = SELECCION;
end
```

### LED Blinking
```verilog
// Toggles every clock cycle (~2 Hz)
parpadeo <= ~parpadeo;
led0 <= parpadeo;
```

### Product Scrolling
- 22 characters per product (name + price + spaces)
- Circular buffer implementation
- Updates position every ~0.5 seconds
- Wraps around for infinite loop

## 📈 Resource Utilization

Typical usage on Nexys A7-100T:

| Resource | Used | Available | Utilization |
|----------|------|-----------|-------------|
| LUTs | ~200 | 63,400 | <1% |
| Flip-Flops | ~150 | 126,800 | <1% |
| I/O Pins | 27 | 210 | ~13% |
| Block RAM | 0 | 135 | 0% |

## 🐛 Troubleshooting

### Machine doesn't start
- Check FPGA is programmed
- Press BTNC to reset
- Verify power connection

### Displays show wrong values
- Re-synthesize project
- Check constraint file
- Verify clock divider frequencies

### Coins don't register
- Use quick on/off switch actions
- Edge detection requires clean transitions
- Don't hold switch continuously

### LED doesn't blink
- Normal in DISPENSANDO state only
- Check you've reached DISPENSANDO state
- Verify LED0 connection

### Machine stuck in state
- Press BTNC to reset
- Check state transition conditions
- Verify button connections

## 🎯 Example Purchase Flow

### Scenario 1: Exact Payment
```
1. Machine shows "HOLA" → Auto advance
2. Machine shows "ELIGE" → Select SW[4] (GRANUTS ₡350)
3. See "4.GRANUTS ₡350" scrolling → Confirm SW[0]
4. See "0350 0000" → Insert SW[7] (₡500)
5. Machine advances to "LISTO" → LED blinks
6. Press BTNR to collect
7. See "CAMB 0150" (change ₡150)
8. Press BTNR to collect change
9. Return to "ELIGE"
```

### Scenario 2: Exact Payment
```
1-4. Same as above, select GINGER (₡400)
5. Insert SW[7] (₡500) → "0400 0500"
6. Auto advance to "LISTO"
7. Press BTNR
8. No change state, return to "ELIGE"
```

### Scenario 3: Multiple Coins
```
1-4. Select COCA (₡800)
5. Insert SW[7] (₡500) → "0800 0500"
6. Insert SW[6] (₡100) → "0800 0600"
7. Insert SW[6] (₡100) → "0800 0700"
8. Insert SW[6] (₡100) → "0800 0800"
9. Auto advance to "LISTO"
10. Press BTNR, return to "ELIGE"
```

## 🏆 Project Requirements Compliance

### Mandatory Requirements ✅
- ✅ FSM implementation (5 states)
- ✅ Product selection interface
- ✅ Payment processing (3 coin values)
- ✅ Display shows state, price, balance
- ✅ Real product prices in colones
- ✅ Change calculation and return
- ✅ Product dispensing simulation (LED)
- ✅ Error handling
- ✅ Robust state transitions
- ✅ User-friendly interface

### Key States ✅
- ✅ Idle/Start (INICIO)
- ✅ Product Selection (SELECCION)
- ✅ Payment Processing (PAGO)
- ✅ Dispensing (DISPENSANDO)
- ✅ Change Return (CAMBIO)

## 👨‍💻 Author

**David Alberto Miranda Gonzalez**
- Student ID: 2020207762
- Institution: Costa Rica Institute of Technology (TEC)
- Professor: Javier Rivera Alvarado
- Semester: I-2025

## 📄 License

This project was developed for educational purposes for the Digital Systems Design course at Costa Rica Institute of Technology.

## 🙏 Acknowledgments

- Digilent for Nexys A7 documentation
- Xilinx for Vivado Design Suite
- TEC Digital Systems Lab

## 📚 References

- [Finite State Machines in Verilog](https://www.nandland.com/verilog/tutorials/tutorial-state-machines-in-verilog.html)
- [Nexys A7 Reference Manual](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual)
- [Verilog HDL Quick Reference](https://web.stanford.edu/class/ee183/handouts_win2003/VerilogQuickRef.pdf)

## 🔗 Related Projects

- [Battle City NES Replica](https://github.com/AlbertoDAMG30/battle-city-nes-replica) - Project 1
- [FPGA 7-Segment Animator](https://github.com/AlbertoDAMG30/fpga-7segment-animator) - Lab 2
- [RISC-V Assembler](https://github.com/AlbertoDAMG30/riscv-assembler) - Project 3

---

⭐ If you found this project helpful, give it a star on GitHub!

**Note**: This project demonstrates real-world FSM applications, payment processing logic, and user interface design in hardware description language. Perfect for learning state machine design!
