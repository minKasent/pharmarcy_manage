#!/bin/bash

echo "========================================"
echo "Starting Flutter Pharmacy App"
echo "========================================"
echo ""

echo "Installing dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "Failed to install dependencies!"
    exit 1
fi

echo ""
echo "Checking available devices..."
flutter devices

echo ""
echo "Starting Flutter app..."
echo "Make sure you have an emulator running or device connected!"
echo ""
flutter run