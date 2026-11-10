[CmdletBinding()]
param(
    [string]$OutputPath
)

$ErrorActionPreference = "Continue"
$repoRoot = Split-Path -Parent $PSScriptRoot
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $env:TEMP "MobileBIOS-Windows-Report-$timestamp.md"
}

$report = New-Object System.Collections.Generic.List[string]
function Add-Line([string]$Value = "") { [void]$report.Add($Value) }
function Add-Section([string]$Title) {
    Add-Line ""
    Add-Line "## $Title"
    Add-Line ""
}
function Add-CommandResult([string]$Title, [string]$Command, [string[]]$Arguments) {
    Add-Line "### $Title"
    Add-Line '~~~text'
    Add-Line ("> $Command " + ($Arguments -join " "))
    try {
        $output = & $Command @Arguments 2>&1 | Out-String
        if ([string]::IsNullOrWhiteSpace($output)) { Add-Line "(no output)" }
        else { foreach ($line in ($output.TrimEnd() -split "\r?\n")) { Add-Line $line } }
    }
    catch {
        Add-Line ("ERROR: " + $_.Exception.Message)
    }
    Add-Line '~~~'
    Add-Line ""
}

Add-Line "# MobileBIOS Windows Environment Report"
Add-Line ""
Add-Line ("Generated: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"))
Add-Line ("Computer architecture: " + $env:PROCESSOR_ARCHITECTURE)
Add-Line ""
Add-Line "> Diagnostic report only. This script does not install software, change settings, build firmware, or modify project files."
Add-Line "> Review the report before sharing it. It may contain local installation paths and account-specific folder names."

Add-Section "Windows and PowerShell"
try {
    $os = Get-CimInstance Win32_OperatingSystem
    Add-Line ("- OS: {0} (version {1}, build {2})" -f $os.Caption, $os.Version, $os.BuildNumber)
    Add-Line ("- PowerShell: {0}" -f $PSVersionTable.PSVersion)
    Add-Line ("- PowerShell edition: {0}" -f $PSVersionTable.PSEdition)
    Add-Line ("- 64-bit process: {0}" -f ([Environment]::Is64BitProcess))
    Add-Line ("- 64-bit operating system: {0}" -f ([Environment]::Is64BitOperatingSystem))
}
catch { Add-Line ("OS detection error: " + $_.Exception.Message) }

Add-Section "Visual Studio 2022"
$vswhere = Join-Path \${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
$vsInstallations = @()
if (Test-Path $vswhere) {
    try {
        $vsJson = & $vswhere -all -products * -format json 2>$null
        if ($LASTEXITCODE -eq 0 -and $vsJson) {
            $vsInstallations = @($vsJson | ConvertFrom-Json)
        }
    } catch { Add-Line ("vswhere error: " + $_.Exception.Message) }
} else {
    Add-Line "- vswhere.exe: NOT FOUND"
}
if ($vsInstallations.Count -eq 0) {
    Add-Line "- Visual Studio installations: none detected"
} else {
    foreach ($vs in $vsInstallations) {
        Add-Line ("- Installation: {0}" -f $vs.displayName)
        Add-Line ("- Version: {0}" -f $vs.installationVersion)
        Add-Line ("- Path: {0}" -f $vs.installationPath)
        Add-Line ("- Product ID: {0}" -f $vs.productId)
        $packages = @($vs.packages | ForEach-Object { $_.id })
        foreach ($component in @(
            "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
            "Microsoft.VisualStudio.Component.Windows11SDK.26100",
            "Microsoft.VisualStudio.Component.Windows10SDK.19041",
            "Microsoft.VisualStudio.Component.VC.CMake.Project"
        )) {
            $present = $packages -contains $component
            Add-Line ("- Component {0}: {1}" -f $component, $(if ($present) { "installed" } else { "not detected" }))
        }

        $devCmd = Join-Path $vs.installationPath "Common7\Tools\VsDevCmd.bat"
        if (Test-Path $devCmd) {
            Add-Line "- MSVC compiler check:"
            Add-Line '~~~text'
            $cmdLine = '"' + $devCmd + '" -no_logo -arch=amd64 -host_arch=amd64 && cl /Bv'
            $clOutput = & $env:ComSpec /d /s /c $cmdLine 2>&1 | Out-String
            if ([string]::IsNullOrWhiteSpace($clOutput)) { Add-Line "cl produced no output" }
            else { foreach ($line in ($clOutput.TrimEnd() -split "\r?\n")) { Add-Line $line } }
            Add-Line '~~~'
        } else {
            Add-Line "- VsDevCmd.bat: NOT FOUND"
        }
    }
}

Add-Section "Required and Useful Tools"
$toolNames = @("git", "python", "py", "nasm", "iasl", "qemu-system-aarch64", "cmake", "ninja")
foreach ($name in $toolNames) {
    $cmd = Get-Command $name -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($cmd) {
        Add-Line ("- {0}: {1}" -f $name, $cmd.Source)
        if ($name -in @("git", "python", "nasm", "iasl", "qemu-system-aarch64", "cmake", "ninja")) {
            try {
                $versionArgs = if ($name -eq "git") { @("--version") }
                    elseif ($name -eq "python") { @("--version") }
                    elseif ($name -eq "nasm") { @("-v") }
                    elseif ($name -eq "iasl") { @("-v") }
                    elseif ($name -eq "qemu-system-aarch64") { @("--version") }
                    else { @("--version") }
                $versionOutput = & $name @versionArgs 2>&1 | Select-Object -First 2
                foreach ($line in $versionOutput) { Add-Line ("  " + $line) }
            } catch { Add-Line ("  version check failed: " + $_.Exception.Message) }
        }
    } else {
        Add-Line ("- {0}: NOT FOUND in PATH" -f $name)
    }
}

Add-Section "Python Launcher"
$pyLauncher = Get-Command py -ErrorAction SilentlyContinue
if ($pyLauncher) {
    Add-CommandResult "Installed Python interpreters" "py" @("-0p")
} else {
    Add-Line "- Python launcher 'py' not found."
}

Add-Section "MobileBIOS Repository"
if (Get-Command git -ErrorAction SilentlyContinue) {
    Add-CommandResult "Repository root" "git" @("-C", $repoRoot, "rev-parse", "--show-toplevel")
    Add-CommandResult "Current branch" "git" @("-C", $repoRoot, "branch", "--show-current")
    Add-CommandResult "Current commit" "git" @("-C", $repoRoot, "rev-parse", "HEAD")
    Add-CommandResult "Working tree status" "git" @("-C", $repoRoot, "status", "--short")
} else {
    Add-Line "- Git is unavailable; repository metadata could not be read."
}

Add-Section "EDK II Checkout"
$edk2Path = Join-Path $repoRoot ".deps\edk2"
if (Test-Path (Join-Path $edk2Path ".git")) {
    Add-CommandResult "EDK II commit" "git" @("-C", $edk2Path, "rev-parse", "HEAD")
    Add-CommandResult "EDK II branch or tag" "git" @("-C", $edk2Path, "describe", "--tags", "--always", "--dirty")
} else {
    Add-Line "- .deps\edk2: not present (normal before the first source checkout)."
}

Add-Section "Project Build Files"
foreach ($relativePath in @(
    "scripts\setup-ubuntu.sh",
    "scripts\build-qemu.sh",
    "scripts\report-windows.ps1",
    "docs\DEVELOPMENT.md"
)) {
    $fullPath = Join-Path $repoRoot $relativePath
    Add-Line ("- {0}: {1}" -f $relativePath, $(if (Test-Path $fullPath) { "present" } else { "missing" }))
}

Add-Line ""
Add-Line "---"
Add-Line "End of report."

$parent = Split-Path -Parent $OutputPath
if (-not [string]::IsNullOrWhiteSpace($parent) -and -not (Test-Path $parent)) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
}
$report | Set-Content -Path $OutputPath -Encoding UTF8
Write-Host ""
Write-Host "MobileBIOS diagnostic report created:" -ForegroundColor Green
Write-Host $OutputPath
Write-Host "Review the report before sharing it." -ForegroundColor Yellow
