@echo off
echo ========================================
echo   PharmacyLife - Run Script
echo ========================================
echo.

REM Check if Maven is installed
where mvn >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Maven is not installed or not in PATH!
    echo Please install Maven or add it to your PATH environment variable.
    echo Download from: https://maven.apache.org/download.cgi
    pause
    exit /b 1
)

echo [INFO] Maven found!
echo.

REM Check if Java is installed
where java >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Java is not installed or not in PATH!
    pause
    exit /b 1
)

echo [INFO] Java found!
java -version
echo.

REM Change to project directory
cd /d "%~dp0"

echo [INFO] Building project...
call mvn clean package -DskipTests

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed!
    pause
    exit /b 1
)

echo.
echo [INFO] Build successful!
echo.
echo [INFO] Starting Tomcat server...
echo [INFO] Application will be available at: http://localhost:8080/PharmacyLife/ImportController
echo [INFO] Press Ctrl+C to stop the server
echo.

call mvn tomcat7:run

pause
