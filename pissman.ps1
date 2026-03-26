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
    if ($null -ne $Value -and $Value -ne "") {
        $clean = $Value.ToString() -replace '[=\r\n]', ''
        Add-Content -Path $out -Value "$Name=$clean"
    }
}

$os  = Get-CimInstance Win32_OperatingSystem
$cs  = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$gpu = Get-CimInstance Win32_VideoController | Select-Object -First 1
$bios = Get-CimInstance Win32_BIOS

Write-Var "Timestamp" (Get-Date -Format o)
Write-Var "User" $env:USERNAME
Write-Var "ComputerName" $env:COMPUTERNAME
Write-Var "Domain" $env:USERDOMAIN
Write-Var "OS" $os.Caption
Write-Var "OSVersion" $os.Version
Write-Var "BuildNumber" $os.BuildNumber
Write-Var "Architecture" $os.OSArchitecture
Write-Var "InstallDate" $os.InstallDate
Write-Var "Manufacturer" $cs.Manufacturer
Write-Var "Model" $cs.Model
Write-Var "BIOSVersion" ($bios.SMBIOSBIOSVersion)
Write-Var "SerialNumber" ($bios.SerialNumber)
Write-Var "RAM" (Format-Size $cs.TotalPhysicalMemory)

Write-Var "CPU" $cpu.Name
Write-Var "CPUCores" $cpu.NumberOfCores
Write-Var "CPULogical" $cpu.NumberOfLogicalProcessors
Write-Var "CPUMaxClock" $cpu.MaxClockSpeed
Write-Var "GPU" $gpu.Name
Write-Var "GPUDriver" $gpu.DriverVersion

Get-CimInstance Win32_LogicalDisk | ForEach-Object {
    Write-Var "Disk_$($_.DeviceID)_Size" (Format-Size $_.Size)
    Write-Var "Disk_$($_.DeviceID)_Free" (Format-Size $_.FreeSpace)
    Write-Var "Disk_$($_.DeviceID)_FS" $_.FileSystem
}

Get-NetIPAddress -AddressFamily IPv4 | ForEach-Object {
    Write-Var "IP_$($_.InterfaceAlias)" $_.IPAddress
}

Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | ForEach-Object {
    Write-Var "MAC_$($_.Name)" $_.MacAddress
    Write-Var "Speed_$($_.Name)" $_.LinkSpeed
}

$lastBoot = [Management.ManagementDateTimeConverter]::ToDateTime($os.LastBootUpTime)
$uptime = (Get-Date) - $lastBoot
Write-Var "LastBoot" $lastBoot
Write-Var "Uptime" $uptime

Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 | ForEach-Object {
    Write-Var "Process_$($_.Name)" $_.CPU
}

Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
Where-Object { $_.DisplayName } |
Select-Object -First 20 |
ForEach-Object {
    Write-Var "App_$($_.DisplayName)" $_.DisplayVersion
}

Get-ChildItem Env: | ForEach-Object {
    Write-Var "ENV_$($_.Name)" $_.Value
}

try {
    $wifi = netsh wlan show interfaces | Select-String "SSID"
    if ($wifi) {
        Write-Var "WiFi" ($wifi -replace "SSID\s*:\s*", "")
    }
} catch {}

try {
    $pubip = (Invoke-WebRequest -Uri "https://api.ipify.org").Content
    Write-Var "PublicIP" $pubip
} catch {}

"done=1" | Out-File -FilePath "done.txt" -Encoding ascii
