@echo off
echo ========================================
echo Starting Pharmacy Management Backend
echo ========================================
echo.

cd backend\pharmacy-management

echo Building project...
call mvn clean install

if %errorlevel% neq 0 (
    echo Build failed! Please check the error messages above.
    pause
    exit /b %errorlevel%
)

echo.
echo Starting Spring Boot application...
echo Backend will be available at: http://localhost:8080/api
echo.
call mvn spring-boot:run

pause