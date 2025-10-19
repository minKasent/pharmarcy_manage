@echo off
echo ========================================
echo Starting Flutter Pharmacy App
echo ========================================
echo.

echo Installing dependencies...
call flutter pub get

if %errorlevel% neq 0 (
    echo Failed to install dependencies!
    pause
    exit /b %errorlevel%
)

echo.
echo Checking available devices...
call flutter devices

echo.
echo Starting Flutter app...
echo Make sure you have an emulator running or device connected!
echo.
call flutter run

pause