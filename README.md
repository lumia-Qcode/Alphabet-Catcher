# Alphabet Catcher - x86 Assembly Game

**Alphabet Catcher** is a text-based arcade-style game implemented entirely in x86 Assembly Language using. The game features both single-player and multiplayer modes and is designed to run in a DOS environment.

---

## Features

- 🔤 Falling alphabets from top of the screen
- 🕹️ Move the catcher box left/right (two players supported)
- 🧠 Score increases on catching alphabets
- ⏱️ In-game timer (HH:MM:SS format)
- ❌ Miss counter and game-over condition
- ↪️ Restart and Quit options
- 🎨 Colorful characters with smooth movement
- 🧮 Custom pseudo-random alphabet generator
- ⌨️ Real-time keyboard ISR (interrupt handling)

---

## Controls

| Key        | Function                    |
|------------|-----------------------------|
| `Arrow Keys` | Move Player 1 left/right     |
| `A` / `D`    | Move Player 2 left/right     |
| `Shift`      | Fast movement                |
| `0`          | Start single-player mode     |
| `1`          | Start multiplayer mode       |
| `Q` or `q`   | Quit game                    |
| `R` or `r`   | Restart game                 |
| `ESC`        | Exit game                    |

---

## Requirements

- DOS Emulator (e.g., DOSBox) or real-mode DOS environment
- NASM (Netwide Assembler) for assembling:
  ```bash
  nasm -f bin Alphabet Catcher.asm -o catcher.com
##  How to Run
Assemble the file:
nasm -f bin "Alphabet Catcher.asm" -o catcher.com<br>
Run it in DOSBox:
dosbox catcher.com<br>
Follow on-screen instructions to select the game mode and start catching falling letters.

## Game Logic Highlights
Uses Interrupt Vector Table (IVT) to hook custom keyboard and timer handlers.<br>
Implements pseudo-random character spawning using LCG (Linear Congruential Generator).<br>
Character movement and collisions are handled through screen memory manipulation (0xB800).<br>
Real-time score tracking, miss count, and playtime tracking.<br>
Separate logic for single-player and multiplayer modes.<br>
Clean restart and graceful exit with screen clearing.<br>

## File Overview
Alphabet Catcher.asm: Full source code of the game (written in NASM-compatible x86 Assembly)

## Screens
Welcome Screen: "Press 0 for Single Player. Press 1 for Multiplayer."<br>
Game Play: Colored characters falling from the top, a box at the bottom that players control.<br>
Game Over: Displays "Game Over!" with score and timer.<br>
Instructions Panel: On how to restart or quit.<br>

## Author
Lumia Noman Qureshi<br>
BSCS – Computer Science Student<br>
FAST NUCES LHR
