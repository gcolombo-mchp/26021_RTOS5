#Script to install required software for 26021_RTOS5 class on a Windows PC
function Refresh-Env {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
}

Refresh-Env
if (-not (Test-Path -Path "path.txt")) {
    $env:Path -split ";" | Out-File -FilePath "path.txt" -Encoding utf8
}
Write-Host "Installing required software for 26021_RTOS5 MASTERs Class" -ForegroundColor Green
Write-Host ""
$currentDir = Get-Location
$wingetPath = "$home\AppData\Local\Microsoft\WinGet\Packages\"

# Check if VSCode is installed otherwise it install it
try {
    Write-Host "Check if Visual Studio Code is already installed" -ForegroundColor Green
    Write-Host "Visual Studio Code version " -NoNewline
    code.cmd --version
    if ($LASTEXITCODE -ne 0) {
        throw "VSCode is missing."
    }
}
catch {
    $vscodePkg = winget list --id Microsoft.VisualStudioCode --exact | Select-String "Microsoft.VisualStudioCode"
    if ($vscodePkg)  {
        $vscodePath = "$home\AppData\Local\Programs\Microsoft VS Code\bin"
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$vscodePath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        Write-Host "Visual Studio Code v" -NoNewline
        code.cmd --version
    } else {
        Write-Host ""
        Write-Host "Visual Studio Code not installed" -ForegroundColor Green
        winget install Microsoft.VisualStudioCode
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Visual Studio Code installation failed! PLEASE INSTALL SOFTWARE MANUALLY!"
            exit $LASTEXITCODE
        }
        $vscodePath = "$home\AppData\Local\Programs\Microsoft VS Code\bin"
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$vscodePath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        Write-Host "Visual Studio Code installed!" -ForegroundColor Green
        Write-Host "Visual Studio Code version " -NoNewline
        code.cmd --version
    }
}

# Check if Python v3.12 is installed otherwise it install it
try {
    Write-Host "Check if Python is already installed" -ForegroundColor Green
    $version = python --version 2>&1
    if ($version -notlike "Python *") {
        throw "Python is missing."
    } else {
        python --version
    }
}
catch {
    $pythonPkg = winget list --id Python.Python.3.12 --exact | Select-String "Python.Python.3.12"
    if ($pythonPkg)  {
        $pythonPath = "$home\AppData\Local\Programs\Python\Python312"
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$pythonPath;$currentPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        python --version
    } else {
        Write-Host "Python not installed" -ForegroundColor Green
        winget install Python.Python.3.12
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Python installation failed! PLEASE INSTALL SOFTWARE MANUALLY!"
            exit $LASTEXITCODE
        }
        $pythonPath = "$home\AppData\Local\Programs\Python\Python312"
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$pythonPath;$currentPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        Write-Host "Python installed!" -ForegroundColor Green
        python --version
    }
}

# Check if CMake is installed otherwise it install it
try {
    Write-Host "Check if CMake is already installed" -ForegroundColor Green
    cmake --version
    if ($LASTEXITCODE -ne 0) {
        throw "CMake is missing."
    }
}
catch {
# Check if CMake is installed otherwise it install it
    $cmakePkg = winget list --id Kitware.CMake --exact | Select-String "Kitware.CMake"
    if ($cmakePkg)  {
        $cmakePath = "C:\Program Files\CMake\bin\"
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$cmakePath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        cmake --version
    } else {
        Write-Host "CMake not installed" -ForegroundColor Green
        winget install Kitware.CMake
        if ($LASTEXITCODE -ne 0) {
           Write-Error "CMake installation failed! PLEASE INSTALL SOFTWARE MANUALLY!"
            exit $LASTEXITCODE
        }
        $cmakePath = "C:\Program Files\CMake\bin\"
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$cmakePath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        Write-Host "CMake installed!" -ForegroundColor Green
        cmake --version
    }
}

# Check if Ninja is installed otherwise it install it
try {
    Write-Host "Check if Ninja is already installed" -ForegroundColor Green
    Write-Host "Ninja version " -NoNewline
    ninja --version
    if ($LASTEXITCODE -ne 0) {
        throw "Ninja is missing."
    }
}
catch {
    $ninjaPkg = winget list --id Ninja-build.Ninja --exact | Select-String "Ninja-build.Ninja"
    if ($ninjaPkg)  {
        $ninjaFolder = Get-ChildItem -Path $wingetPath -Filter "Ninja-build.Ninja*" -Directory | Select-Object -First 1
        $ninjaPath = $ninjaFolder.FullName
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$ninjaPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        Write-Host "Ninja version " -NoNewline
        ninja --version
    } else {
        Write-Host ""
        Write-Host "Ninja not installed" -ForegroundColor Green
        winget install Ninja-build.Ninja
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Ninja installation failed! PLEASE INSTALL SOFTWARE MANUALLY!"
            exit $LASTEXITCODE
        }
        $ninjaFolder = Get-ChildItem -Path $wingetPath -Filter "Ninja-build.Ninja*" -Directory | Select-Object -First 1
        $ninjaPath = $ninjaFolder.FullName
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$ninjaPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        Write-Host "Ninja installed!" -ForegroundColor Green
        Write-Host "Ninja version " -NoNewline
        ninja --version
    }
}

# Check if gperf is installed otherwise it install it
try {
    Write-Host "Check if gperf is already installed" -ForegroundColor Green
    gperf --version
    if ($LASTEXITCODE -ne 0) {
        throw "gperf is missing."
    }
}
catch {
    $gperfPkg = winget list --id oss-winget.gperf --exact | Select-String "oss-winget.gperf"
    if ($gperfPkg)  {
        $gperfFolder = Get-ChildItem -Path $wingetPath -Filter "oss-winget.gperf*" -Directory | Select-Object -First 1
        $gperfPath = $gperfFolder.FullName
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$gperfPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        gperf --version
    } else {
        Write-Host "gperf not installed" -ForegroundColor Green
        winget install oss-winget.gperf
        if ($LASTEXITCODE -ne 0) {
            Write-Error "gperf installation failed! PLEASE INSTALL SOFTWARE MANUALLY!"
            exit $LASTEXITCODE
        }
        $gperfFolder = Get-ChildItem -Path $wingetPath -Filter "oss-winget.gperf*" -Directory | Select-Object -First 1
        $gperfPath = $gperfFolder.FullName
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$gperfPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        Write-Host "gperf installed!" -ForegroundColor Green
        gperf --version
    }
}

# Check if Git is installed otherwise it install it
try {
    Write-Host "Check if Git is already installed" -ForegroundColor Green
    git --version
    if ($LASTEXITCODE -ne 0) {
        throw "Git is missing."
    }
}
catch {
    $gitPkg = winget list --id Git.Git --exact | Select-String "Git.Git"
    if ($gitPkg)  {
        $gitPath = "C:\Program Files\Git"
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$gitPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        git --version
    } else {
        Write-Host "Git not installed" -ForegroundColor Green
        winget install Git.Git
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Git installation failed! PLEASE INSTALL SOFTWARE MANUALLY!"
            exit $LASTEXITCODE
        }
        $gitPath = "C:\Program Files\Git"
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$gitPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        Write-Host "Git installed!" -ForegroundColor Green
        git --version
    }
}

# Check if Device Tree Compiler is installed otherwise it install it
try {
    Write-Host "Check if DTC is already installed" -ForegroundColor Green
    dtc --version
    if ($LASTEXITCODE -ne 0) {
        throw "DTC is missing."
    }
}
catch {
    $dtcPkg = winget list --id oss-winget.dtc --exact | Select-String "oss-winget.dtc"
    if ($dtcPkg)  {
        $dtcFolder = Get-ChildItem -Path $wingetPath -Filter "oss-winget.dtc*" -Directory | Select-Object -First 1
        $dtcPath = $dtcFolder.FullName + "\usr\bin"
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$dtcPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        dtc --version
    } else {
        Write-Host "DTC not installed" -ForegroundColor Green
        winget install oss-winget.dtc
        if ($LASTEXITCODE -ne 0) {
            Write-Error "DTC installation failed! PLEASE INSTALL SOFTWARE MANUALLY!"
            exit $LASTEXITCODE
        }
        $dtcFolder = Get-ChildItem -Path $wingetPath -Filter "oss-winget.dtc*" -Directory | Select-Object -First 1
        $dtcPath = $dtcFolder.FullName + "\usr\bin"
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$dtcPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        Write-Host "DTC installed!" -ForegroundColor Green
        dtc --version
    }
}

# Check if wget is installed otherwise it install it
try {
    Write-Host "Check if wget is already installed" -ForegroundColor Green
    winget list --id JernejSimoncic.Wget --exact
    if ($LASTEXITCODE -ne 0) {
        throw "Wget is missing."
    }
}
catch {
    $wgetPkg = winget list --id JernejSimoncic.Wget --exact | Select-String "JernejSimoncic.Wget"
    if ($wgetPkg)  {
        $wgetFolder = Get-ChildItem -Path $wingetPath -Filter "JernejSimoncic.Wget*" -Directory | Select-Object -First 1
        $wgetPath = $wgetFolder.FullName
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$wgetPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        winget list --id JernejSimoncic.Wget
    } else {
        Write-Host "wget not installed" -ForegroundColor Green
        winget install JernejSimoncic.Wget
        if ($LASTEXITCODE -ne 0) {
            Write-Error "wget installation failed! PLEASE INSTALL SOFTWARE MANUALLY!"
            exit $LASTEXITCODE
        }
        $wgetFolder = Get-ChildItem -Path $wingetPath -Filter "JernejSimoncic.Wget*" -Directory | Select-Object -First 1
        $wgetPath = $wgetFolder.FullName
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$wgetPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        Write-Host "wget installed!" -ForegroundColor Green
        winget list --id JernejSimoncic.Wget
    }
}

# Check if 7-Zip is installed otherwise it install it
try {
    Write-Host "Check if 7-Zip is already installed" -ForegroundColor Green
    Write-Host "7-Zip version " -NoNewline
    (7z | Select-String "7-Zip").ToString().Split(' ')[1]
    if ($LASTEXITCODE -ne 0) {
        throw "7-Zip is missing."
    }
}
catch {
    
    $7zipPkg = winget list --id 7zip.7zip --exact | Select-String "7zip.7zip"
    if ($7zipPkg)  {
        $7zipPath = "C:\Program Files\7-Zip"
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$7zipPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        Write-Host "7-Zip version " -NoNewline
        (7z | Select-String "7-Zip").ToString().Split(' ')[1]
    } else {
        Write-Host ""
        Write-Host "7-Zip not installed" -ForegroundColor Green
        winget install 7zip.7zip
        if ($LASTEXITCODE -ne 0) {
            Write-Error "7-Zip installation failed! PLEASE INSTALL SOFTWARE MANUALLY!"
            exit $LASTEXITCODE
        }
        $7zipPath = "C:\Program Files\7-Zip"
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$7zipPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        Write-Host "7-Zip installed!" -ForegroundColor Green
        Write-Host "7-Zip version " -NoNewline
        (7z | Select-String "7-Zip").ToString().Split(' ')[1]
    }
}

# Check if openOCD is installed otherwise it install it
try {
    Write-Host "Check if openOCD is already installed" -ForegroundColor Green
    openocd --version
    if ($LASTEXITCODE -ne 0) {
        throw "openOCD is missing."
    }
}
catch {
    $openocdPkg = winget list --id xpack-dev-tools.openocd-xpack --exact | Select-String "xpack-dev-tools.openocd-xpack"
    if ($openocdPkg) {
        $openocdFolder = Get-ChildItem -Path $wingetPath -Filter "xpack-dev-tools.openocd-xpack*" -Directory | Select-Object -First 1
        $openocdPath = $openocdFolder.FullName
        $openocdBinPath = (Resolve-Path "$openocdPath\xpack-openocd-*\bin").Path
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$openocdBinPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        openocd --version
    } else {
        Write-Host "openOCD not installed" -ForegroundColor Green
        winget install xpack-dev-tools.openocd-xpack
        if ($LASTEXITCODE -ne 0) {
            Write-Error "openOCD installation failed! PLEASE INSTALL SOFTWARE MANUALLY!"
            exit $LASTEXITCODE
        }
        $openocdFolder = Get-ChildItem -Path $wingetPath -Filter "xpack-dev-tools.openocd-xpack*" -Directory | Select-Object -First 1
        $openocdPath = $openocdFolder.FullName
        $openocdBinPath = (Resolve-Path "$openocdPath\xpack-openocd-*\bin").Path
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPath = "$currentPath;$openocdBinPath"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Refresh-Env
        Write-Host "openOCD installed!" -ForegroundColor Green
        openocd --version
    }
}

# Check if Zephyr SDK v0.17.4 is installed in the <HomeFolder>; if not it ask if you want install it
$sdkFolder = "$home\zephyr-sdk-0.17.4"
if (Test-Path $sdkFolder) {
    Write-Host "Zephyr SDK 0.17.4 already installed in $sdkFolder" -ForegroundColor Green
} else {
    Write-Host "Install Zephyr SDK 0.17.4..." -ForegroundColor Green
    cd $home
    & cmd.exe /c wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.4/zephyr-sdk-0.17.4_windows-x86_64.7z
    if ($LASTEXITCODE -ne 0) {
        Remove-Item -Force ".\zephyr-sdk-0.17.4_windows-x86_64.7z"
        Write-Error "Zephyr SDK 0.17.4 installation failed! PLEASE INSTALL SOFTWARE MANUALLY!"
        exit $LASTEXITCODE
    }
    7z x zephyr-sdk-0.17.4_windows-x86_64.7z -aoa
    if ($LASTEXITCODE -ne 0) {
        Remove-Item -Force -Recurse $sdkFolder
        Write-Error "Zephyr SDK 0.17.4 installation failed! PLEASE INSTALL SOFTWARE MANUALLY!"
        exit $LASTEXITCODE
    }
    cd zephyr-sdk-0.17.4
    & cmd.exe /c setup.cmd
    if ($LASTEXITCODE -ne 0) {
        Remove-Item -Force -Recurse $sdkFolder
        Write-Error "Zephyr SDK 0.17.4 installation failed! PLEASE INSTALL SOFTWARE MANUALLY!"
        exit $LASTEXITCODE
    }
    [System.Environment]::SetEnvironmentVariable("ZEPHYR_SDK_INSTALL_DIR", "$home\zephyr-sdk-0.17.4", "Machine")
    cd $home
    Remove-Item -Force ".\zephyr-sdk-0.17.4_windows-x86_64.7z"
    cd $currentDir
}
Write-Host ""

# Installation completed
Write-Host "Installation Complete!" -ForegroundColor Green
cd $currentDir
