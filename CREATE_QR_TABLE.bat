@echo off
echo ╔════════════════════════════════════════════════════════════════════╗
echo ║         Creating QR Payments Table                                ║
echo ╚════════════════════════════════════════════════════════════════════╝
echo.
echo This will create the qr_payments table in your database.
echo.
echo Please enter your MySQL credentials:
echo.

set /p username="MySQL Username (default: root): "
if "%username%"=="" set username=root

set /p database="Database Name (default: election_expense_db): "
if "%database%"=="" set database=election_expense_db

echo.
echo Executing SQL script...
echo.

mysql -u %username% -p %database% < database\qr_payments_table.sql

if %errorlevel% equ 0 (
    echo.
    echo ╔════════════════════════════════════════════════════════════════════╗
    echo ║  ✅ SUCCESS! QR Payments table created successfully               ║
    echo ╚════════════════════════════════════════════════════════════════════╝
    echo.
    echo You can now:
    echo 1. Restart your Tomcat server
    echo 2. Login as admin
    echo 3. Click "Verify QR Payments" in the navbar
    echo.
) else (
    echo.
    echo ╔════════════════════════════════════════════════════════════════════╗
    echo ║  ❌ ERROR! Failed to create table                                 ║
    echo ╚════════════════════════════════════════════════════════════════════╝
    echo.
    echo Please check:
    echo - MySQL username and password are correct
    echo - Database name is correct
    echo - MySQL service is running
    echo.
)

pause
