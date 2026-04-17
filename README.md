# 🚽 ComfyFlush

ComfyFlush is a PowerShell script designed to automatically recycle [ComfyUI](https://www.comfy.org/) background processes at set intervals with Windows Task Scheduler to effectively flush and reclaim VRAM. It is intended to help run AI LLM and SD Image Generation features in tandem on cost-effective hardware, for [Open WebUI Desktop](https://github.com/open-webui/desktop) downstream service.

## ✨ Features

*   **VRAM Reclamation:** Automatically start/stop ComfyUI background `python` processes to reclaim significant VRAM, potentially freeing up capacity equivalent to a consumer-grade GPU (approx. $499 USD average capacity as of 2026).
*   **Memory Reclamation:** Clears out system memory as well.
*   **Multi-Task Support:** Designed to work seamlessly in tandem with services like [Open WebUI Desktop](https://github.com/open-webui/desktop), allowing efficient resource sharing.
*   **Automation:** Integrates with the Windows Task Scheduler to run autonomously, ensuring consistent VRAM management without manual intervention. No extensions required!
*   **Logging:** Log capture.

## ⚙️ Requirements

*   **Operating System:** Windows 10 or Windows 11
*   **Software:** ComfyUI installed
*   **Hardware:** NVIDIA GPU (required for effective VRAM management)

## 🛠️ Usage & Setup

Follow these steps to configure ComfyFlush for automated VRAM flushing via Windows Task Scheduler.

### Step 1: Configure the Script

1.  **Edit the Script:** Open the `ComfyFlush.ps1` file and modify the following variables according to your setup:
    ```powershell
    # --- Configuration ---

    # Set the path to your ComfyUI installation directory
    $ComfyDir      = "C:\Program Files\ComfyUI"

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

### v0.0.1.0 (Beta) - 2026-04-17
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
ComfyUI often leaves consumed VRAM and RAM locked even when processes are idle, which hinders multi-tasking on cost-effective systems. This script automates native Windows management to reliably recycle resources, ensuring that VRAM and RAM are cleared when not actively needed.
Allowing you to enable large language models (LLM) and image generation ([ComfyUI](https://www.comfy.org/)) upstream features together for [Open WebUI Desktop](https://github.com/open-webui/desktop).
This is intended for system automation, not manual extension activation.

## 🪪 Attribution & License

Author: Hugo Remington

License: MIT