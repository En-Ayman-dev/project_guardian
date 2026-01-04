@echo off
REM سكربت لإنشاء هيكل lib كما هو مطلوب

SET "ROOT=lib"

REM المجلد الجذر
IF NOT EXIST "%ROOT%" MKDIR "%ROOT%"

REM --------------------
REM config
REM --------------------
MKDIR "%ROOT%\config"
MKDIR "%ROOT%\config\routes"
MKDIR "%ROOT%\config\theme"
MKDIR "%ROOT%\config\l10n"

REM --------------------
REM core
REM --------------------
MKDIR "%ROOT%\core"
MKDIR "%ROOT%\core\constants"
MKDIR "%ROOT%\core\errors"
MKDIR "%ROOT%\core\utils"
MKDIR "%ROOT%\core\di"
MKDIR "%ROOT%\core\widgets"

REM --------------------
REM features
REM --------------------
MKDIR "%ROOT%\features"

REM auth
MKDIR "%ROOT%\features\auth"
MKDIR "%ROOT%\features\auth\data"
MKDIR "%ROOT%\features\auth\domain"
MKDIR "%ROOT%\features\auth\presentation"

REM باقي الميزات
MKDIR "%ROOT%\features\dashboard"
MKDIR "%ROOT%\features\inventory"
MKDIR "%ROOT%\features\sales"
MKDIR "%ROOT%\features\purchases"
MKDIR "%ROOT%\features\clients_suppliers"
MKDIR "%ROOT%\features\finance"

REM --------------------
REM main.dart داخل lib
REM --------------------
IF NOT EXIST "%ROOT%\main.dart" TYPE NUL > "%ROOT%\main.dart"

ECHO الهيكل المطلوب تم إنشاؤه بنجاح.
PAUSE
