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

## 👷 How It Works
ComfyFlush manages ComfyUI by starting python venv and stopping it using an automatic timer. Windows Task Scheduler recycles this process for constant uptime.

> [!IMPORTANT]
> In order for it to work, you must start ComfyUI through ComfyFlush. Any instances of ComfyUI running outside of this scope won't work, it will still hog up GPU VRAM!

### Workflow Overview
Task Scheduler → ComfyFlush → Activate Python Venv → Launch ComfyUI → Wait (User Defined Time) → Kill Process (Flush VRAM) → Repeat

## 🛠 Usage & Setup

Follow these steps to configure and automate **ComfyFlush**.

### 1. Installation
1. Download the repository ZIP file.
2. Extract the contents to your preferred local directory (e.g., `C:\Program Files\StabilityMatrix\Packages\ComfyUI`).

### 2. Edit the script
1. Change var to your install path to your extracted ComfyFlush.ps1 script location
```$ComfyDir      = "C:\Program Files\StabilityMatrix\Packages\ComfyUI"```.
2. Set your preferred timer (Default: 595 seconds for 10 minutes). This will need to match Windows Task Scheduler
```$Timeout       = 595```.
3. Save and close.

### 3. Create a Windows Scheduled Task
1. **General**
 * Name: ComfyFlush
 * Description: ComfyFlush is a tool that enables automatic GPU VRAM reclamation by managing ComfyUI venve start/stop.
 * When running the task, use the following user account: Run whether user is logged on or not.
 * Configure for: Windows 10.
2. **Triggers**
 * Begin the task: On a schedule.
 * Settings: Daily, Recur every [1] days.
 * Advanced settings
 * Repeat task every: 10 minutes.
3. **Actions**
 * Action: Start a program.
 * Program/script: `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`
 * Add arguments (optional): `-ExecutionPolicy Bypass -File "C:\Program Files\StabilityMatrix\Packages\ComfyUI\ComfyFlush.ps1"`
   > Note: You will need to bypass execution policy as this is a beta release.
 * Start in (optional): `C:\Program Files\StabilityMatrix\Packages\ComfyUI`
 * Note: There are no "" quote marks in Start in (optional).
4. **Finish**
Click OK to finish.

### 4. Run ComfyFlush
1. Run the task via Windows Task Scheduler.

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