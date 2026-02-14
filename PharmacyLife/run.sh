#!/bin/bash

echo "========================================"
echo "  PharmacyLife - Run Script"
echo "========================================"
echo ""

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "[ERROR] Maven is not installed or not in PATH!"
    echo "Please install Maven or add it to your PATH environment variable."
    echo "Download from: https://maven.apache.org/download.cgi"
    exit 1
fi

echo "[INFO] Maven found!"
echo ""

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "[ERROR] Java is not installed or not in PATH!"
    exit 1
fi

echo "[INFO] Java found!"
java -version
echo ""

# Change to project directory
cd "$(dirname "$0")"

echo "[INFO] Building project..."
mvn clean package -DskipTests

if [ $? -ne 0 ]; then
    echo "[ERROR] Build failed!"
    exit 1
fi

echo ""
echo "[INFO] Build successful!"
echo ""
echo "[INFO] Starting Tomcat server..."
echo "[INFO] Application will be available at: http://localhost:8080/PharmacyLife/ImportController"
echo "[INFO] Press Ctrl+C to stop the server"
echo ""

mvn tomcat7:run
