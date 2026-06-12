#Script to install 26021_RTOS5 class on a Windows PC
Write-Host "Installing 26021_RTOS5 MASTERs Class" -ForegroundColor Green
Write-Host ""
$currentDir = Get-Location
Write-Host "Checking for Required Software" -ForegroundColor Green
Write-Host ""
# Check if VSCode is installed otherwise it install it
$vscodePkg = winget list --id Microsoft.VisualStudioCode --exact | Select-String "Microsoft.VisualStudioCode"
if ($vscodePkg)  {
    Write-Host "Visual Studio Code already installed" -ForegroundColor Green
    try {
        Write-Host "Visual Studio Code v" -NoNewline
        code.cmd --version
    }
    catch {
        Write-Host "code.cmd --version failed"
        Write-Host "PLEASE Install Visual Studio Code..." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "Visual Studio Code not installed"
    Write-Host "PLEASE Install Visual Studio Code..." -ForegroundColor Red
    exit
}
Write-Host ""
# Check if CMake is installed otherwise it install it
$cmakePkg = winget list --id Kitware.CMake --exact | Select-String "Kitware.CMake"
if ($cmakePkg)  {
    Write-Host "CMake dependency already installed" -ForegroundColor Green
    try {
        cmake.exe --version
    }
    catch {
        Write-Host "cmake --version failed"
        Write-Host "PLEASE Install CMake..." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "CMake dependency not installed"
    Write-Host "PLEASE Install CMake..." -ForegroundColor Red
    exit
}
Write-Host ""
# Check if Ninja is installed otherwise it install it
$ninjaPkg = winget list --id Ninja-build.Ninja --exact | Select-String "Ninja-build.Ninja"
if ($ninjaPkg)  {
    Write-Host "Ninja dependency already installed" -ForegroundColor Green
    try {
        Write-Host "Ninja version " -NoNewline
        ninja --version
    }
    catch {
        Write-Host "ninja --version failed"
        Write-Host "PLEASE Install Ninja..." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "Ninja dependency not installed"
    Write-Host "PLEASE Install Ninja..." -ForegroundColor Red
    exit
}
Write-Host ""
# Check if gperf is installed otherwise it install it
$gperfPkg = winget list --id oss-winget.gperf --exact | Select-String "oss-winget.gperf"
if ($gperfPkg)  {
    Write-Host "gperf dependency already installed" -ForegroundColor Green
    try {
        gperf --version
    }
    catch {
        Write-Host "gperf --version failed"
        Write-Host "PLEASE Install gperf..." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "gperf dependency not installed"
    Write-Host "PLEASE Install gperf..." -ForegroundColor Red
    exit
}
Write-Host ""
# Check if Python v3.12 is installed otherwise it install it
$pythonPkg = winget list --id Python.Python.3.12 --exact | Select-String "Python.Python.3.12"
if ($pythonPkg)  {
    Write-Host "Python dependency already installed" -ForegroundColor Green
    try {
        $version = python --version 2>&1
        if ($version -notlike "Python *") {
            throw "Python is missing."
        } else {
            python --version
        }
    }
    catch {
        Write-Host "Python --version failed"
        Write-Host "PLEASE Install Python..." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "Python dependency not installed"
    Write-Host "PLEASE Install Python..." -ForegroundColor Red
    exit
}
Write-Host ""
# Check if Git is installed otherwise it install it
$gitPkg = winget list --id Git.Git --exact | Select-String "Git.Git"
if ($gitPkg)  {
    Write-Host "Git dependency already installed" -ForegroundColor Green
    try {
        git --version
    }
    catch {
        Write-Host "git --version failed"
        Write-Host "PLEASE Install Git..." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "Git dependency not installed"
    Write-Host "PLEASE Install Git..." -ForegroundColor Red
    exit
}
Write-Host ""
# Check if Device Tree Compiler is installed otherwise it install it
$dtcPkg = winget list --id oss-winget.dtc --exact | Select-String "oss-winget.dtc"
if ($dtcPkg)  {
    Write-Host "DTC dependency already installed" -ForegroundColor Green
    try {
        dtc --version
    }
    catch {
        Write-Host "dtc --version failed"
        Write-Host "PLEASE Install Device Tree Compiler..." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "DTC dependency not installed"
    Write-Host "PLEASE Install Device Tree Compiler..." -ForegroundColor Red
    exit
}
Write-Host ""
# Check if wget is installed otherwise it install it
$wgetPkg = winget list --id JernejSimoncic.Wget --exact | Select-String "JernejSimoncic.Wget"
if ($wgetPkg)  {
    Write-Host "wget dependency already installed" -ForegroundColor Green
    try {
        winget list --id JernejSimoncic.Wget
    }
    catch {
        Write-Host "wget check failed"
        Write-Host "PLEASE Install wget..." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "wget dependency not installed"
    Write-Host "PLEASE Install wget..." -ForegroundColor Red
    exit
}
Write-Host ""
# Check if 7-Zip is installed otherwise it install it
$7zipPkg = winget list --id 7zip.7zip --exact | Select-String "7zip.7zip"
if ($7zipPkg)  {
    Write-Host "7-Zip dependency already installed" -ForegroundColor Green
    try {
        Write-Host "7-Zip version " -NoNewline
        (7z | Select-String "7-Zip").ToString().Split(' ')[1]
    }
    catch {
        Write-Host "7-Zip check failed"
        Write-Host "PLEASE Install 7-Zip..." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "7-Zip dependency not installed"
    Write-Host "PLEASE Install 7-Zip..." -ForegroundColor Red
    exit
}
Write-Host ""
# Check if openOCD is installed otherwise it install it
$openocdPkg = winget list --id xpack-dev-tools.openocd-xpack --exact | Select-String "xpack-dev-tools.openocd-xpack"
if ($openocdPkg) {
    Write-Host "OpenOCD dependency already installed" -ForegroundColor Green
    try {
        openocd --version
    }
    catch {
        Write-Host "openocd --version failed"
        Write-Host "PLEASE Install openOCD..." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "OpenOCD dependency not installed"
    Write-Host "PLEASE Install openOCD..." -ForegroundColor Red
    exit
}
Write-Host ""
# Check if Zephyr SDK v0.17.4 is installed in the <HomeFolder>; if not it ask if you want install it
$sdkFolder = "$home\zephyr-sdk-0.17.4"
if (Test-Path $sdkFolder) {
    Write-Host "Zephyr SDK 0.17.4 already installed in $sdkFolder" -ForegroundColor Green
} else {
    Write-Host "Zephyr SDK 0.17.4 not installed in $sdkFolder"
    Write-Host "PLEASE Install Zephyr SDK 0.17.4..." -ForegroundColor Red
    exit
}
Write-Host ""
# Check if C:\MASTERs\26021_RTOS5 is exist and if it exists, it deletes it, creating an empty one
$mastersFolder = "C:\MASTERs\26021_RTOS5"
Write-Host "Create $mastersFolder folder..." -ForegroundColor Green
if (Test-Path $mastersFolder) {
    Write-Host "Deleting old $mastersFolder folder. It can take up to 3 minutes, please wait..."
    Remove-Item -Force -Recurse $mastersFolder
}
mkdir $mastersFolder 
Set-Location $mastersFolder
Write-Host ""
# Create the Python Environmet and activate it
Write-Host "Create the virtual environment and activate it..." -ForegroundColor Green
python -m venv zephyrproject\.venv
if ($LASTEXITCODE -ne 0) {
    Write-Error "Virtual Environment setup failed! PLEASE RUN THE SCRIPT AGAIN!"
    exit $LASTEXITCODE
}
.\zephyrproject\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
if ($LASTEXITCODE -ne 0) {
    deactivate
    Write-Error "pip upgrade failed! PLEASE RUN THE SCRIPT AGAIN!"
    exit $LASTEXITCODE
}
Write-Host ""
# Install West
Write-Host "Install West..." -ForegroundColor Green
pip install west
if ($LASTEXITCODE -ne 0) {
    deactivate
    Write-Error "west installation failed! PLEASE RUN THE SCRIPT AGAIN!"
    exit $LASTEXITCODE
}
Write-Host ""
# Install Zephyr OS v4.3.0
Write-Host "Install Zephyr v4.3.0 in zephyrproject folder..." -ForegroundColor Green
Set-Location zephyrproject
mkdir manifest
Set-Location manifest
& cmd.exe /c wget https://raw.githubusercontent.com/gcolombo-mchp/26021_RTOS5/refs/heads/main/Scripts/26021_RTOS5.yml
Move-Item 26021_RTOS5.yml west.yml
west init --local .
if ($LASTEXITCODE -ne 0) {
    deactivate
    Write-Error "west init failed! PLEASE RUN THE SCRIPT AGAIN!"
    exit $LASTEXITCODE
}
Set-Location ..
west update
if ($LASTEXITCODE -ne 0) {
    deactivate
    Write-Error "west update failed! PLEASE RUN THE SCRIPT AGAIN!"
    exit $LASTEXITCODE
}
west zephyr-export
Write-Host ""
# Install Python Packages
Write-Host "Install Python packages..." -ForegroundColor Green
python -m pip install @((west packages pip) -split ' ')
if ($LASTEXITCODE -ne 0) {
    Write-Error "Python packages installation failed! PLEASE RUN THE SCRIPT AGAIN!"
    exit $LASTEXITCODE
}
Write-Host ""
# Clone the labs file from github and delete the Scripts folder that contain this file
deactivate
Write-Host "Clone Labs files..." -ForegroundColor Green
git init
git remote add origin https://github.com/gcolombo-mchp/26021_RTOS5.git
git fetch
git checkout -b main origin/main
Move-Item -Path ".\Scripts\Restore_26021_RTOS5.bat" -Destination $mastersFolder
Move-Item -Path ".\Scripts\Copy_Blinky_Sample.bat" -Destination $mastersFolder
Move-Item -Path ".\Scripts\Copy_Lab1_Files.bat" -Destination $mastersFolder
Move-Item -Path ".\Scripts\Copy_Lab1_Solution.bat" -Destination $mastersFolder
Move-Item -Path ".\Scripts\Copy_Lab2_Solution.bat" -Destination $mastersFolder
Move-Item -Path ".\Scripts\Copy_Lab3_Solution.bat" -Destination $mastersFolder
Remove-Item -Recurse -Force ".\Scripts"
Move-Item -Path ".\26021_RTOS5_LabManual.pdf" -Destination "..\"
Write-Host ""
# Ask if you want to copy the C:\MASTERs\26021_RTOS5 folder to C:\Backup
Write-Host "Do you want to copy the 26021 RTOS5 Class content to C:\Backup folder? [y/N]" -ForegroundColor Green -NoNewLine
$backup = Read-Host
if ($backup -eq "Y" -or $backup -eq "y") {
    Write-Host ""
    Write-Host "Copying files on C:\Backup folder..." -ForegroundColor Green
    $backupFolder = "C:\Backup\26021_RTOS5"
    if (Test-Path $backupFolder) {
        Write-Host "Deleting old $backupFolder folder. It can take up to 3 minutes, please wait..."
        Remove-Item -Force -Recurse $backupFolder 
    }
    robocopy $mastersFolder $backupFolder /E /Z /MT:32
}
Remove-Item -Force "$mastersFolder\Restore_26021_RTOS5.bat"
Write-Host ""
# Installation completed
Write-Host "Installation Complete!" -ForegroundColor Green
Set-Location $currentDir
