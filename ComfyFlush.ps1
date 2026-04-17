# Metadata
$Author     =   "Hugo Remington"
$Version    =   "0.0.2.0"
$Date       =   "17-Apr-2026"
# Get parent console process ID
$parentPid = [System.Diagnostics.Process]::GetCurrentProcess().Id
# Get the actual Process Object using that ID
$parent = Get-Process -Id $parentPid

try
{
    while($True)
    {
        # --- CONFIGURATION ---
        $ComfyDir      = "C:\Program Files\StabilityMatrix\Packages\ComfyUI"
        $VenvScripts   = "$ComfyDir\venv\Scripts"
        $LogFile       = "$ComfyDir\comfyui.log"
        $Timeout       = 595 # 5 seconds under 10 minutes. Must reflect with your scheduled task frequency.

        # --- PRE-FLIGHT CHECKS ---
        if (-not (Test-Path $ComfyDir)) { 
            # Write-Host "ComfyUI directory path does not exist. Please retry."
        }

        # Inject the VENV into the session PATH this allows us to call "python" directly as a native command.
        $env:PATH = "$VenvScripts;" + $env:PATH

        # Change directory to ComfyUI (Required so main.py finds its files)
        Set-Location -Path $ComfyDir

        # Start Logging
        " [START] $(Get-Date) " | Out-File -FilePath $LogFile -Append
        # Write-Host "Launching ComfyUI via native venv 'python'..."
        # Write-Host "Logging to: $LogFile"

        # Using 'cmd /c' only to handle the log redirection (>>).
        $Command = "cmd /c python main.py >> `"$LogFile`" 2>&1"

        $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $Command" -PassThru -WindowStyle Hidden

        # The Watchdog Timer
        # Write-Host "Waiting $Timeout seconds for process to complete..."
        Start-Sleep -Seconds $Timeout

        # Termination Logic
        if (-not $process.HasExited) {
            # Write-Host "Timeout reached! Forcefully terminating process tree..." -ForegroundColor Red
            # Kill the CMD processand everything it started (Python process).
            taskkill /F /T /PID $process.Id | Out-Null
            # Kill the parent PowerShell console.
            taskkill /F /T /PID $parent.Id | Out-Null
            " [TIMEOUT] $(Get-Date) - Process terminated by watchdog." | Out-File -FilePath $LogFile -Append
        } else {
            # Write-Host "ComfyUI finished successfully." -ForegroundColor Green
            " [FINISH] $(Get-Date) - Process completed naturally." | Out-File -FilePath $LogFile -Append
        }
    }
}
Finally
{
    # Write-Host "Exit received. Forcefully terminating process tree..." -ForegroundColor Yellow
    # Kill the CMD process and everything it started (the Python process)
    taskkill /F /T /PID $process.Id | Out-Null
    # Kill the parent PowerShell console.
    taskkill /F /T /PID $parent.Id | Out-Null
    " [TIMEOUT] $(Get-Date) - Process terminated by watchdog." | Out-File -FilePath $LogFile -Append
}

<# Attempt to cleanly exit.
# WatchDog end.
if ($parent.HasExited -eq $True)
{
    taskkill /F /T /PID $process.Id | Out-Null
    taskkill /F /T /PID $parent.Id | Out-Null
}
$parent.WaitForExit()
#>