# ==========================================================================================
# STANDALONE SCRIPT: M365 PowerShell Module Installer / Updater / Repair Engine
# ==========================================================================================

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "        MICROSOFT 365 POWERSHELL MODULE MAINTENANCE         " -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# ==========================================================================================
# DEPENDENCY MANIFEST
# ==========================================================================================
$Manifest = @(
    @{ Name = "Microsoft.Graph";                                RequiredVersion = "2.0.0" }
    @{ Name = "Microsoft.Graph.Beta";                           RequiredVersion = "2.0.0" }
    @{ Name = "ExchangeOnlineManagement";                       RequiredVersion = "3.4.0" }
    @{ Name = "MicrosoftTeams";                                 RequiredVersion = "5.0.0" }
    @{ Name = "AzureAD";                                        RequiredVersion = "2.0.2.140" }
    @{ Name = "AzureADPreview";                                 RequiredVersion = "2.0.2.149" }
    @{ Name = "MSOnline";                                       RequiredVersion = "1.1.183.66" }
    @{ Name = "SharePointPnPPowerShellOnline";                  RequiredVersion = "3.29.2101.0" }
    @{ Name = "Microsoft.Online.SharePoint.PowerShell";         RequiredVersion = "16.0.23912.12000" }
    @{ Name = "Microsoft.Graph.Intune";                         RequiredVersion = "1.0.0" }
    @{ Name = "Defender";                                       RequiredVersion = "1.0.0" }
    @{ Name = "MicrosoftPurview";                               RequiredVersion = "1.0.0" }
    @{ Name = "PowerAppsAdministration";                        RequiredVersion = "2.0.0" }
    @{ Name = "PowerApps";                                      RequiredVersion = "2.0.0" }
    @{ Name = "Microsoft.PowerApps.Administration.PowerShell";  RequiredVersion = "2.0.0" }
    @{ Name = "Microsoft.PowerApps.PowerShell";                 RequiredVersion = "2.0.0" }
)

# ==========================================================================================
# VERSION REPORTING
# ==========================================================================================
Write-Host "Collecting module version information..." -ForegroundColor Yellow

$Report = foreach ($entry in $Manifest) {
    $installed = Get-Module -ListAvailable -Name $entry.Name | Sort-Object Version -Descending | Select-Object -First 1

    [PSCustomObject]@{
        Module    = $entry.Name
        Installed = if ($installed) { $installed.Version.ToString() } else { "Not Installed" }
        Required  = $entry.RequiredVersion
        Status    = if ($installed) {
                        if ([version]$installed.Version -lt [version]$entry.RequiredVersion) { "Outdated" }
                        else { "OK" }
                    }
                    else { "Missing" }
    }
}

Write-Host ""
Write-Host "MODULE VERSION REPORT" -ForegroundColor Cyan
$Report | Format-Table -AutoSize

# ==========================================================================================
# INSTALL / UPDATE / REPAIR ENGINE
# ==========================================================================================
Write-Host ""
Write-Host "Beginning module installation/update..." -ForegroundColor Yellow

$total = $Manifest.Count
$i = 0

foreach ($entry in $Manifest) {
    $i++
    $module = $entry.Name

    Write-Progress -Activity "Installing/Updating Microsoft 365 Modules" `
                   -Status ("Processing {0} ({1} of {2})" -f $module, $i, $total) `
                   -PercentComplete (($i / $total) * 100)

    try {
        $installed = Get-Module -ListAvailable -Name $module | Sort-Object Version -Descending | Select-Object -First 1

        if ($installed) {
            Write-Host ("Updating {0} (Installed: {1})..." -f $module, $installed.Version) -ForegroundColor Yellow

            try {
                Update-Module -Name $module -Force -ErrorAction Stop
            }
            catch {
                Write-Host ("Update failed — attempting repair for {0}..." -f $module) -ForegroundColor Red

                try {
                    Uninstall-Module -Name $module -AllVersions -Force -ErrorAction Stop
                    Install-Module -Name $module -Force -AllowClobber -ErrorAction Stop
                    Write-Host ("Repair successful for {0}" -f $module) -ForegroundColor Green
                }
                catch {
                    $msg = $_.Exception.Message
                    Write-Host ("ERROR repairing {0}: {1}" -f $module, $msg) -ForegroundColor Red
                }
            }
        }
        else {
            Write-Host ("Installing {0}..." -f $module) -ForegroundColor Green
            Install-Module -Name $module -Force -AllowClobber -ErrorAction Stop
        }
    }
    catch {
        $msg = $_.Exception.Message
        Write-Host ("ERROR installing/updating {0}: {1}" -f $module, $msg) -ForegroundColor Red
    }
}

Write-Progress -Activity "Installing/Updating Microsoft 365 Modules" -Completed
Write-Host ""
Write-Host "All module operations completed." -ForegroundColor Green

# ==========================================================================================
# HEALTH CHECK
# ==========================================================================================
Write-Host ""
Write-Host "Running module health check..." -ForegroundColor Yellow

$Health = foreach ($entry in $Manifest) {
    $installed = Get-Module -ListAvailable -Name $entry.Name | Sort-Object Version -Descending | Select-Object -First 1

    [PSCustomObject]@{
        Module    = $entry.Name
        Installed = if ($installed) { $installed.Version.ToString() } else { "Not Installed" }
        Healthy   = if ($installed) { $true } else { $false }
    }
}

Write-Host ""
Write-Host "MODULE HEALTH CHECK" -ForegroundColor Cyan
$Health | Format-Table -AutoSize

Write-Host ""
Write-Host "Standalone module maintenance completed successfully." -ForegroundColor Green

# ==========================================================================================
# END OF STANDALONE SCRIPT
# ==========================================================================================
