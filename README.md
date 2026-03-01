# x86 Assembly Shape Generator

A console-based application engineered in 32-bit x86 Assembly (NASM) for Linux environments. It features a fully interactive CLI menu that allows users to generate dynamically scaled ASCII and Unicode shapes based on custom size inputs.

## Features
* **Algorithmic Rendering:** Utilizes complex nested loops and conditional branching to calculate 2D spatial positioning for Squares, Triangles, Lines, Rectangles, and Circles.
* **Direct Linux Syscalls:** Leverages `int 0x80` software interrupts for all user I/O, completely bypassing standard C libraries.
* **Low-Level Control Flow:** Implements manual register management and precise memory offsets to track loop counters, size scaling parameters, and ASCII/Unicode character printing.
* **Input Validation:** Features an interactive menu loop with error handling for invalid user selections.

## Tech Stack
* **Language:** x86 Assembly (32-bit)
* **Assembler:** NASM
* **OS Target:** Linux
