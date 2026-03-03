#Script to install 26021_RTOS5 class on a Windows PC
Write-Host "Installing 26021_RTOS5 MASTERs Class" -ForegroundColor Green
Write-Host ""
Write-Host "Checking for Zephyr dependency" -ForegroundColor Green
Write-Host "" 
# Check if CMake is installed otherwise it install it
$cmakePkg = winget list --id Kitware.CMake --exact | Select-String "Kitware.CMake"
if ($cmakePkg)  {
    Write-Host "CMake dependency already installed" -ForegroundColor Green
    cmake.exe --version
} else {
    Write-Host "Installing CMake dependency..." -ForegroundColor Green
    winget install Kitware.CMake
}
Write-Host ""
# Check if Ninja is installed otherwise it install it
$ninjaPkg = winget list --id Ninja-build.Ninja --exact | Select-String "Ninja-build.Ninja"
if ($ninjaPkg)  {
    Write-Host "Ninja dependency already installed" -ForegroundColor Green
    ninja --version
} else {
    Write-Host "Installing Ninja dependency..." -ForegroundColor Green
    winget install Ninja-build.Ninja
}
Write-Host ""
# Check if gperf is installed otherwise it install it
$gperfPkg = winget list --id oss-winget.gperf --exact | Select-String "oss-winget.gperf"
if ($gperfPkg)  {
    Write-Host "gperf dependency already installed" -ForegroundColor Green
    gperf --version
} else {
    Write-Host "Installing gperf dependency..." -ForegroundColor Green
    winget install oss-winget.gperf
}
Write-Host ""
# Check if Python v3.12 is installed otherwise it install it
$pythonPkg = winget list --id Python.Python.3.12 --exact | Select-String "Python.Python.3.12"
if ($pythonPkg)  {
    Write-Host "Python dependency already installed" -ForegroundColor Green
    python --version
} else {
    Write-Host "Installing Python dependency..." -ForegroundColor Green
    winget install Python.Python.3.12
}
Write-Host ""
# Check if Git is installed otherwise it install it
$gitPkg = winget list --id Git.Git --exact | Select-String "Git.Git"
if ($gitPkg)  {
    Write-Host "Git dependency already installed" -ForegroundColor Green
    git --version
} else {
    Write-Host "Installing Git dependency..." -ForegroundColor Green
    winget install Git.Git
}
Write-Host ""
# Check if Device Tree Compiler is installed otherwise it install it
$dtcPkg = winget list --id oss-winget.dtc --exact | Select-String "oss-winget.dtc"
if ($dtcPkg)  {
    Write-Host "DTC dependency already installed" -ForegroundColor Green
    dtc --version
} else {
    Write-Host "Installing DTC dependency..." -ForegroundColor Green
    winget install oss-winget.dtc
}
Write-Host ""
# Check if wget is installed otherwise it install it
$wgetPkg = winget list --id JernejSimoncic.Wget --exact | Select-String "JernejSimoncic.Wget"
if ($wgetPkg)  {
    Write-Host "WGET dependency already installed" -ForegroundColor Green
    winget list --id JernejSimoncic.Wget
} else {
    Write-Host "Installing WGET dependency..." -ForegroundColor Green
    winget install JernejSimoncic.Wget
}
Write-Host ""
# Check if 7zip is installed otherwise it install it
$7zipPkg = winget list --id 7zip.7zip --exact | Select-String "7zip.7zip"
if ($7zipPkg)  {
    Write-Host "7zip dependency already installed" -ForegroundColor Green
    (7z | Select-String "7-Zip").ToString().Split(' ')[1]
} else {
    Write-Host "Installing 7zip dependency..." -ForegroundColor Green
    winget install 7zip.7zip
}
Write-Host ""
# Check if C:\MASTERs\26021_RTOS5 is exist and if it exists, it deletes it, creating an empty one
$mastersFolder = "C:\MASTERs\26021_RTOS5"
Write-Host "Create $mastersFolder folder..." -ForegroundColor Green
if (Test-Path $mastersFolder) {
    Write-Host "Deleting old $mastersFolder folder..."
    $items = Get-ChildItem -Path $mastersFolder -Recurse
    $total = $items.Count
    for ($i = 0; $i -lt $total; $i++) {
        if ($i % 100 -eq 0) {
            $percent = ($i / $total) * 100
            Write-Progress -Activity "Removing $mastersFolder..." -PercentComplete $percent
        }
        $items[$i].Delete()
    }
}
mkdir $mastersFolder
cd $mastersFolder
Write-Host ""
# Create the Python Environmet and activate it
Write-Host "Create the virtual environment and activate it..." -ForegroundColor Green
python -m venv zephyrproject\.venv
.\zephyrproject\.venv\Scripts\Activate.ps1
Write-Host ""
# Install West
Write-Host "Install West..." -ForegroundColor Green
pip install west
Write-Host ""
# Install Zephyr OS v4.3.0
Write-Host "Install Zephyr v4.3.0 in zephyrproject folder..." -ForegroundColor Green
west init --mr v4.3.0 zephyrproject
cd zephyrproject
west update
west zephyr-export
Write-Host ""
# Install Python Packages
Write-Host "Install Python packages..." -ForegroundColor Green
python -m pip install @((west packages pip) -split ' ')
Write-Host ""
# Clone the labs file from github and delete the Scripts folder that contain this file
Write-Host "Clone Labs files..." -ForegroundColor Green
git init
git remote add origin https://github.com/gcolombo-mchp/26021_RTOS5.git
git fetch
git checkout -b main origin/main
Remove-Item -Recurse -Force ".\Scripts"
Write-Host ""
# Check if Zephyr SDK v0.17.4 is installed in the <HomeFolder>; if not it ask if you want install it
$sdkFolder = "$home\zephyr-sdk-0.17.4"
if (Test-Path $sdkFolder) {
    Write-Host "Zephyr SDK 0.17.4 already installed in $sdkFolder" -ForegroundColor Green
} else {
    Write-Host "Do you want to install Zephyr SDK 0.17.4 in the $home folder? [Y/N]" -ForegroundColor Green -NoNewLine
    $sdk = Read-Host
    if ($sdk -eq "Y" -or $sdk -eq "y") {
        Write-Host ""
        Write-Host "Install Zephyr SDK 0.17.4..." -ForegroundColor Green
        cd $home
        & cmd.exe /c wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.4/zephyr-sdk-0.17.4_windows-x86_64.7z
        7z x zephyr-sdk-0.17.4_windows-x86_64.7z -aoa
        cd zephyr-sdk-0.17.4
        & cmd.exe /c setup.cmd
        [System.Environment]::SetEnvironmentVariable("ZEPHYR_SDK_INSTALL_DIR", "$home\zephyr-sdk-0.17.4", "User")
        cd $mastersFolder
    }
}
Write-Host ""
# Ask if you want to copy the C:\MASTERs\26021_RTOS5 folder to C:\Backup
Write-Host "Do you want to copy the installation on C:\Backup folder? [Y/N]" -ForegroundColor Green -NoNewLine
$backup = Read-Host 
if ($backup -eq "Y" -or $backup -eq "y") {
    Write-Host ""
    Write-Host "Copying installation on C:\Backup folder..." -ForegroundColor Green
    $backupFolder = "C:\Backup\26021_RTOS5"
    if (Test-Path $backupFolder) {
        Write-Host "Deleting old $backupFolder folder..."
        $items = Get-ChildItem -Path $backupFolder -Recurse
        $total = $items.Count
        for ($i = 0; $i -lt $total; $i++) {
            if ($i % 100 -eq 0) {
                $percent = ($i / $total) * 100
                Write-Progress -Activity "Removing $backupFolder..." -PercentComplete $percent
            }
            $items[$i].Delete()
        }
    }
    robocopy $mastersFolder $backupFolder /E /Z /MT:8
}
Write-Host ""
# Installation completed
Write-Host "Installation Complete!" -ForegroundColor Green
