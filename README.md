# 🎮 VGA Controller for Basys 3 FPGA

This project implements a VGA controller on the **Basys 3 FPGA board** that displays the message **"HELLO WORLD"** with colorful, animated text and a vibrant gradient background. It's built from scratch using Verilog and is fully synthesizable.

---

## ✨ Features

- ✅ 640x480 VGA resolution at 60Hz
- ✅ 25MHz pixel clock derived from the 100MHz system clock
- ✅ VGA synchronization (HSYNC, VSYNC) generation
- ✅ 8x8 bitmap-based text rendering
- ✅ 4x character scaling for high visibility
- ✅ Centered display of **"HELLO WORLD"**
- ✅ Animated text colors: **Cyan**, **Yellow**, and **Magenta**
- ✅ Dynamic gradient background based on screen position

---

## 🔤 Character Set

The following characters are pre-defined in the bitmap ROM:
- `H`, `E`, `L`, `O`, `W`, `R`, `D`
- Space character (` `)

---

## ⚙️ VGA Timing Parameters

### Horizontal Timing
| Signal         | Pixels |
|----------------|--------|
| Display        | 640    |
| Front Porch    | 16     |
| Sync Pulse     | 96     |
| Back Porch     | 48     |
| **Total**      | 800    |

### Vertical Timing
| Signal         | Lines  |
|----------------|--------|
| Display        | 480    |
| Front Porch    | 10     |
| Sync Pulse     | 2      |
| Back Porch     | 33     |
| **Total**      | 525    |

---

## 🔧 Implementation Details

- Written in **Verilog HDL**
- Uses accurate VGA timing for 640x480 @ 60Hz
- Built-in **character bitmap ROM**
- **4x text scaling** logic for improved readability
- RGB color generation based on pixel coordinates
- Animated color changes via frame counter

---

## 🖥️ Usage Instructions

1. Connect a **VGA monitor** to the Basys 3 board
2. Open project in **Xilinx Vivado** (or compatible tool)
3. Generate bitstream and program the FPGA
4. You should see **"HELLO WORLD"** appear at the center with:
   - Changing text colors
   - Gradient-colored background

---

## 🧪 Requirements

- ✅ Digilent **Basys 3** FPGA development board
- ✅ VGA cable and compatible monitor
- ✅ Xilinx **Vivado** (recommended version: 2020.2 or later)

---

## 🛠️ Customization

You can easily modify the display or extend the project:

| What to Change        | Where                     |
|-----------------------|---------------------------|
| Displayed text        | `text_string` array       |
| New characters        | Add to `char_bitmap` ROM  |
| Text size             | Modify `SCALE` parameter  |
| Color effects         | Change `color_logic` block|

---

## 📂 File Structure

vga_hello_world/
├── vga_controller.v # VGA timing and sync generator

├── text_renderer.v # Character scaling and rendering

├── char_bitmap.v # Character ROM for letter bitmaps

├── top_module.v # Top-level instantiation

├── constraints.xdc # Pin constraints for Basys 3

└── README.md # Project documentation


---

## 📸 Preview (Optional - add screenshot)
![WhatsApp Image 2025-07-10 at 23 08 11](https://github.com/user-attachments/assets/df2d7d28-2d31-4b72-952e-ae14173bd270)

---

## 📄 License

This project is licensed under the **MIT License**.  

---

## 💡 Credits

Designed and implemented by prormrxcn  
Inspired by the classic VGA Hello World FPGA demo concept

---



