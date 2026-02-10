@echo off
SETLOCAL
set "command=%1"

if "%command%" == "" (
    echo Usage: make.bat [build^|up^|down^|logs^|shell^|lint^|lint-fix]
    exit /b 1
)

if "%command%" == "build" (
    echo "Building docker images..."
    docker-compose build
) else if "%command%" == "up" (
    echo "Starting services..."
    docker-compose up -d
) else if "%command%" == "down" (
    echo "Stopping services..."
    docker-compose down -v
) else if "%command%" == "logs" (
    echo "Tailing logs..."
    docker-compose logs -f
) else if "%command%" == "shell" (
    echo "Opening shell in server container..."
    docker-compose run --rm servidor bash
) else if "%command%" == "lint" (
    echo "Running linter with ruff..."
    ruff check .
) else if "%command%" == "lint-fix" (
    echo "Running linter with ruff and fixing errors..."
    ruff check --fix .
) else (
    echo "Unknown command: %command%"
    echo Usage: make.bat [build^|up^|down^|logs^|shell^|lint^|lint-fix]
    exit /b 1
)

ENDLOCAL
