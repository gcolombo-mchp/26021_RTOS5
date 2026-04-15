#Restore path and remove packet installed with Winget
if (Test-Path "path.txt") {
    $lines = Get-Content -Path "path.txt"
    $env:Path = $lines -join ";"
    [System.Environment]::SetEnvironmentVariable("Path", $env:Path, "Machine")
    Remove-Item -Force "path.txt"
}
winget remove Microsoft.VisualStudioCode
winget remove Python.Python.3.12
winget remove Kitware.CMake
winget remove Ninja-build.Ninja
winget remove oss-winget.gperf
winget remove Git.Git
winget remove oss-winget.dtc
winget remove JernejSimoncic.Wget
winget remove 7zip.7zip
winget remove xpack-dev-tools.openocd-xpack
$sdkFolder = "$home\zephyr-sdk-0.17.4"
if (Test-Path $sdkFolder) {
    Remove-Item -Force -Recurse $sdkFolder
}