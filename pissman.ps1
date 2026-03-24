$out = "info.txt"
if (Test-Path $out) { Remove-Item $out -Force }

function Format-Size {
    param([long]$bytes)
    if ($bytes -ge 1TB) { "{0:N2} TB" -f ($bytes / 1TB) }
    elseif ($bytes -ge 1GB) { "{0:N2} GB" -f ($bytes / 1GB) }
    elseif ($bytes -ge 1MB) { "{0:N2} MB" -f ($bytes / 1MB) }
    elseif ($bytes -ge 1KB) { "{0:N2} KB" -f ($bytes / 1KB) }
    else { "$bytes B" }
}

function Write-Var {
    param($Name, $Value)
    if ($Value) {
        $clean = $Value.ToString() -replace '[=\r\n]', ''
        Add-Content -Path $out -Value "$Name=$clean"
    }
}

# Basic Info
$os  = Get-CimInstance Win32_OperatingSystem
$cs  = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$gpu = Get-CimInstance Win32_VideoController | Select-Object -First 1

Write-Var "Timestamp" (Get-Date -Format o)
Write-Var "User" $env:USERNAME
Write-Var "ComputerName" $env:COMPUTERNAME
Write-Var "OS" $os.Caption
Write-Var "OSVersion" $os.Version
Write-Var "BuildNumber" $os.BuildNumber
Write-Var "Architecture" $os.OSArchitecture
Write-Var "Model" $cs.Model
Write-Var "Manufacturer" $cs.Manufacturer
Write-Var "RAM" (Format-Size $cs.TotalPhysicalMemory)

# CPU / GPU
Write-Var "CPU" $cpu.Name
Write-Var "CPUCores" $cpu.NumberOfCores
Write-Var "CPULogical" $cpu.NumberOfLogicalProcessors
Write-Var "GPU" $gpu.Name

# Disk (C: only for simplicity)
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
if ($disk) {
    Write-Var "DiskSize" (Format-Size $disk.Size)
    Write-Var "DiskFree" (Format-Size $disk.FreeSpace)
}

# Uptime
$lastBoot = [Management.ManagementDateTimeConverter]::ToDateTime($os.LastBootUpTime)
$uptime = (Get-Date) - $lastBoot
Write-Var "LastBoot" $lastBoot
Write-Var "Uptime" $uptime

# Signal completion
"done=1" | Out-File -FilePath "done.txt" -Encoding ascii