#!/bin/bash

echo "========================================"
echo "Starting Pharmacy Management Backend"
echo "========================================"
echo ""

cd backend/pharmacy-management

echo "Building project..."
mvn clean install

if [ $? -ne 0 ]; then
    echo "Build failed! Please check the error messages above."
    exit 1
fi

echo ""
echo "Starting Spring Boot application..."
echo "Backend will be available at: http://localhost:8080/api"
echo ""
mvn spring-boot:run