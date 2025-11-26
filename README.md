# Gemini Thinking with 3 Pro 
## Prompt 
I want to create a Watch Face for the Garmin Forerunner 165, that looks like a Mondaine watch.

Do everything perfectly so I can send it to my watch as easily and quickly as possible.

I'm on Windows, and I have a Samsung Galaxy S25+. I have VS Code.


# Garmin Forerunner 165: Mondaine Watch Face Guide

This guide covers the setup, code, and installation of a custom Mondaine "Swiss Railway" watch face for the Garmin Forerunner 165.

## Prerequisites
* **OS:** Windows
* **Editor:** VS Code
* **Device:** Garmin Forerunner 165
---

## Phase 1: Environment Setup
1.  **Install Java JDK:** [Download JDK 17](https://adoptium.net/).
2.  **Install Monkey C Extension:**
    * Open VS Code Extensions.
    * Search for **"Monkey C"** (by Garmin).
    * Install it.
3.  **Download SDK:**
    * Press `Ctrl + Shift + P` in VS Code.
    * Type `Monkey C: Verify Installation` (accept prompts to download SDK Manager).
    * In the SDK Manager, download the latest **Connect IQ SDK**.
    * **Important:** In the SDK Manager "Devices" tab, search for and download **Forerunner 165**.

## Phase 2: Create the Project
1.  Press `Ctrl + Shift + P` in VS Code.
2.  Select `Monkey C: New Project`.
3.  Name: `MondaineFace`.
4.  Type: **Watch Face** (Simple).
5.  Device: Select **Forerunner 165**.

## Phase 3: The Code (Complete Version)
This version includes the classic Mondaine design + a **Movement Alert** (Red blocks appear in the bottom half if inactive).

**File:** `source/MondaineFaceView.mc`

## Phase 4: Installation (Sideloading)
1. **Build**: In VS Code, press `Ctrl + Shift + P` -> `Monkey C: Build for Device` -> Select `Forerunner 165` -> Select output folder.

2. **Connect**: Plug watch into PC via USB.

3. **Transfer**: Copy the `MondaineFace.prg` file into the watch drive folder: `Primary\GARMIN\APPS`.

4. **Activate**: Unplug watch -> Long press Up/Menu -> Watch Face -> Select the new face.