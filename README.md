# 🚽 ComfyFlush

ComfyFlush is a PowerShell script that enables seamless multi-tasking between AI LLMs and Image Generation on a single GPU. It achieves this by automatically recycling [ComfyUI](https://www.comfy.org/) processes at set intervals via Windows Task Scheduler to effectively flush and reclaim GPU VRAM. The tool is designed to run local LLM and Stable Diffusion workloads side-by-side on cost-effective hardware using [Open WebUI Desktop](https://github.com/open-webui/desktop).

---

## 💡 Why ComfyFlush?

Running heavy AI models simultaneously often leads to "Out of Memory" errors. ComfyFlush solves this by:
* **Automating VRAM Recovery:** Periodically clears VRAM by cycling ComfyUI processes.
* **Enabling Multi-Tasking:** Allows you to run LLMs and Diffusion models on the same GPU without manual intervention.
* **Low Overhead:** Runs as a lightweight background task with minimal CPU/RAM usage.

## ✨ Features

* **🔄 Automated VRAM Management:** Clears memory without needing manual restarts. Potentially saving you resources equivalent to a consumer grade GPU (approx. $499 in 2026).
* **🛠️ Native Integration:** Designed specifically for users of [Stability Matrix](https://github.com/LykosAI/StabilityMatrix). It may work with other ComfyUI packages, if they too use batch and python scripts.
* **🚀 Zero-Touch Operation:** Set it up once and let it run in the background.
* **📋 Detailed Logging:** Keeps track of process cycles for easy debugging.

## 🚀 Getting Started

### Prerequisites

* **Windows OS** (Optimized for Windows Task Scheduler)
* **Python/PowerShell** environment
* A running instance of ComfyUI (Stability Matrix recommended)

## 🛠️ Usage & Setup

Follow these steps to configure ComfyFlush for automated VRAM flushing via Windows Task Scheduler.

### Step 1: Configure the Script

1.  **Edit the Script:** Open the `ComfyFlush.ps1` file and modify the following variables according to your setup:
    ```powershell
    # --- Configuration ---

    # Set the path to your ComfyUI installation directory
    $ComfyDir      = "C:\Program Files\StabilityMatrix\Packages\ComfyUI"

    # Set your preferred recycle timer in seconds (Default: 595 seconds / ~10 minutes)
    $Timeout       = 595
    ```
2.  **Save the file.**

### Step 2: Set up the Windows Scheduled Task

Create a new task in the Windows Task Scheduler to execute the script automatically:

1.  **Trigger:** Set the task to run on a recurring schedule (e.g., Daily).
2.  **Action:** Set the task to **Start a program**.
3.  **Program/Script:** Specify the PowerShell executable:
    ```
    C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
    ```
4.  **Add Arguments:** Use the following arguments to execute the script, specifying the path and the timeout:
    ```
    -ExecutionPolicy Bypass -File "C:\Program Files\ComfyUI\ComfyFlush.ps1"
    ```
    *(Note: You must ensure the script path is correct.)*
5.  **Settings:** Ensure the task runs under an account that has the necessary permissions to interact with the ComfyUI processes.

### Step 💡 Important Note on Execution Policy

Because this script is a beta release, you may need to temporarily adjust the PowerShell Execution Policy for this task to run successfully:

*   **Action:** If necessary, configure the Task Scheduler to run with elevated permissions, or temporarily set the execution policy via an elevated PowerShell session before setting up the task.

## 📜 Changelog

### v0.0.2.0 (Beta) - 2026-Apr-17
*   🛠️ **Bugfix:** Got process tree close working for ad-hoc CLI / PowerShell using try/while/finally blocks. Need to incorporate the similar for Task Scheduler using $parentPid.
### v0.0.1.0 (Beta) - 2026-Apr-17
*   ✅ **Feature:** Initial functional beta release.
*   ✅ **Feature:** Designed to integrate with Open WebUI environments.
*   🐛 **Bug:** Python.exe processes will not always terminate when manually ended via Task Scheduler. (Working on robust exit handling.)
*   🐛 **Bug:** StabilityMatrix may fail to detect background instances of the ComfyUI package.
*   ➡️ **To Do:** Incorporate dynamic parameters for path and timeout configuration.
*   ➡️ **To Do:** Implement modular functions for better code organization.
*   ➡️ **To Do:** Optimize script execution by utilizing memory management and avoiding excessive `Write-Host` calls.
*   ➡️ **To Do:** GUI Interface by [me](https://hvtools.wordpress.com/2021/10/21/how-to-build-a-colourful-gui-for-powershell-using-winforms-runspacepools-and-hash-tables/).
*   ➡️ **To Do:** Compile app signed executable package using [PS2EXE](https://github.com/MScholtes/PS2EXE).
*   ➡️ **To Do:** Create professional application package using [AdvancedInstaller](https://www.advancedinstaller.com/).

### v0.0.0.1 (Alpha)
*   Alpha pre-release version.
*   Initial code.

## Background

**The Problem**
Let's be honest: running AI models is a constant battle for VRAM. ComfyUI and other tools are amazing, but they have a habit of holding onto memory long after you're done with a task. If you're trying to switch between an LLM and an image generator on a single GPU, you usually end up in a "memory full" loop or stuck manually killing processes.

**The Solution**
I built this because I was tired of the manual cleanup. This tool automs the process of clearing out that stuck VRAM, making it possible to actually use your GPU for more than one thing at a time without the headache.

## ⚖️ License

Distributed under the MIT License. See `LICENSE` for more information.

---
*Disclaimer: This tool is provided "as is" without warranty. Use at your own risk. Always ensure your work is saved before running automated process management tools.*