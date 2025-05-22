# Microtonal Scale Guide Generator for REAPER

**Author:** Christopher Josephs (crimzonclotta) / with help from GPT
**Version:** 0.1  
**Requirements:**  
- REAPER (with SWS Extension)  
- [`js_ReaImGui`](https://github.com/cfillion/reaimgui) (install from ReaPack)

---

## 🎯 What It Does

This script helps you **visually guide microtonal composition** in REAPER by generating **ghost MIDI notes** that represent a custom scale in any EDO (Equal Divisions of the Octave).

Use it to:
- Design microtonal scales with arbitrary EDOs (e.g., 24-EDO, 31-EDO, 53-EDO)
- Save and reload custom scale definitions
- Generate long guide notes as a visual overlay ("ghost notes") in the MIDI editor
- Assist microtonal MIDI editing using REAPER’s source ghosting feature

---

## 🔧 How It Works

- Opens a GUI window using Dear ImGui via ReaImGui
- You define:
  - **EDO**: number of equal divisions (e.g. 24 for 24-TET)
  - **Scale steps**: a list of scale degrees (e.g. `0, 3, 7, 10`)
  - **Root note**: starting MIDI note (e.g. 60 = C4)
  - **Octaves**: how many to span
- It inserts a long MIDI note for each pitch in the scale across the specified octave range
- These notes are inserted into a new MIDI item for use as a ghost guide

---

## 💾 Saving and Loading Scales

You can:
- Name and **save your custom scale** definitions
- **Reload** saved scales by name
- Saved scales are stored in a file called `MicrotonalScales.lua` inside your REAPER resource folder

---

## 📦 Installation

1. **Install dependencies**:
   - `SWS Extension`
   - `js_ReaImGui` from ReaPack
2. Save the script to:
3. In REAPER:
- Open `Actions → Show Action List`
- Click `ReaScript → Load...` and select the script
- Run it from the action list or assign it to a toolbar button

---

## 🖥️ Usage Tips

- Use **source ghosting** in the MIDI editor to show the guide notes while editing other MIDI takes.
- To change key or scale mid-project, delete and regenerate the guide notes.

---

## 📌 Limitations

- Guide notes are rounded to nearest 12-TET MIDI note — they are **visual only** (not true microtonal playback).
- No support (yet) for pitch bend tuning or actual playback of fractional notes.
- REAPER currently does **not allow custom row greying or hiding** in the MIDI editor.

---

## 🛠 Future Features (Planned)
- `.scl` and `.tun` file import support
- Chords
- Modes
- Folders to organise / scale / [ mode || chord]
- Step names, colors, or dynamic key changes
- Auto-update when switching keys

---

## 💬 Feedback & Ideas

If you have ideas or requests, feel free to suggest them!
