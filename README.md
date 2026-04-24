# Microchip MASTERs Class 26021 - RTOS5

## Title

Mastering USB communication: Develop USB Device applications with Zephyr's USB Device Stack on your custom board

## Abstract

USB is now a standard serial communication channel to connect embedded systems to PCs. Upon completion of the course, you will be able to create an enumerable USB device and transfer data between a Microchip MCU and a PC using Zephyr's USB Device Stack.  
The hands-on part of this class is based on a development board that is not yet supported by Zephyr tree, and you will also learn how to add your own board to a Zephyr based application.

## Labs files Setup

You can install labs files on your PC opening a Windows PowerShell and executing the following command:

```powershell
powershell -ExecutionPolicy Bypass -Command "IEX (Invoke-RestMethod 'https://raw.githubusercontent.com/gcolombo-mchp/26021_RTOS5/refs/heads/main/Scripts/install_26021_RTOS5.ps1')"
```

The script checks if the required software is installed before installing the labs files.  
If the process ends because a required software is missing, you can use the following section to install it.

## Required Software Setup

You can install the required software downloading the installation files from their website, or you can run a script that has been crated to check if a required software is missing and install it.  
Open a Windows PowerShell with administrator rights (right click on its icon and select "Run as administrator") then execute the following command:

```powershell
powershell -ExecutionPolicy Bypass -Command "IEX (Invoke-RestMethod 'https://raw.githubusercontent.com/gcolombo-mchp/26021_RTOS5/refs/heads/main/Scripts/Install_Required_Software_26021_RTOS5.ps1')"
```

If the script fails, you can install the missing packages manually, opening a Windows PowerShell and using **winget** commands:

- **Visual Studio Code:**

  ```powershell
  winget install Microsoft.VisualStudioCode
  ```

  > **IMPORTANT:**
  > You will need to create a profile with the following Extensions installed:
  > - Python
  > - C/C++ Extension Pack
  > - Serial Monitor
  > - Cortex-Debug
  > - MPLAB AI Coding Assistant

- **Python v3.12:**

  ```powershell
  winget install Python.Python.3.12

- **CMake:**

  ```powershell
  winget install Kitware.CMake

- **Ninja:**

  ```powershell
  winget install Ninja-build.Ninja

- **Gperf:**

  ```powershell
  winget install oss-winget.gperf
- **Git:**

  ```powershell
  winget install Git.Git

- **Device Tree Compiler:**

  ```powershell
  winget install oss-winget.dtc

- **Wget:**

  ```powershell
  winget install JernejSimoncic.Wget

- **7-Zip:**

  ```powershell
  winget install 7zip.7zip

- **openOCD:**

  ```powershell
  winget install xpack-dev-tools.openocd-xpack

The **Zephyr SDK v0.17.4** cannot be installed using **winget** so you need to download, extract and setup it with a sequence of commands that requires **Wget** and **7-Zip** already available (if you just installed them, you might need to close and reopen Windows PowerShell to update the environment path):

```powershell
& {
    cd $home
    & cmd.exe /c wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.4/zephyr-sdk-0.17.4_windows-x86_64.7z
    7z x zephyr-sdk-0.17.4_windows-x86_64.7z -aoa
    cd zephyr-sdk-0.17.4
    & cmd.exe /c setup.cmd
    cd ..
    Remove-Item -Force ".\zephyr-sdk-0.17.4_windows-x86_64.7z"
}
```
