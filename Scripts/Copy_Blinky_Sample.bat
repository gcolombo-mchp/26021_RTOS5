powershell -ExecutionPolicy Bypass -Command "robocopy 'C:\MASTERs\26021_RTOS5\zephyrproject\zephyr\samples\basic\blinky\src' 'C:\MASTERs\26021_RTOS5\zephyrproject\Lab\src' /E /IS /IT /NP"
powershell -ExecutionPolicy Bypass -Command "Copy-Item 'C:\MASTERs\26021_RTOS5\zephyrproject\zephyr\samples\basic\blinky\prj.conf' 'C:\MASTERs\26021_RTOS5\zephyrproject\Lab\prj.conf' -Force"
powershell -ExecutionPolicy Bypass -Command "Copy-Item 'C:\MASTERs\26021_RTOS5\zephyrproject\zephyr\samples\basic\blinky\CMakeLists.txt' 'C:\MASTERs\26021_RTOS5\zephyrproject\Lab\CMakeLists.txt' -Force"
