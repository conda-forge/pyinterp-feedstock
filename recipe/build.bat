@echo on

:: Patch the Boost.Geometry headers pulled from libboost-headers with the
:: upstream fix for the LineString/Polygon intersection bug on the equator.
:: https://github.com/boostorg/geometry/pull/1483 (merged in develop, absent from Boost <= 1.92)
:: https://github.com/CNES/pangeo-pyinterp/issues/36
patch -p1 -d "%LIBRARY_PREFIX%" < "%RECIPE_DIR%\patches\1483-sjoberg-intersection.patch"
if errorlevel 1 exit 1

:: FindPython ignores free-threaded interpreters unless explicitly requested
:: (4th element of Python_FIND_ABI, CMake >= 3.30).
:: FindPython leaves Python_SOABI empty here, so nanobind would not build its
:: free-threaded support (nb_ft.cpp): provide the SOABI explicitly.
%PYTHON% -c "import sys, sysconfig; sys.exit(0 if sysconfig.get_config_var('Py_GIL_DISABLED') else 1)"
if errorlevel 1 goto :build
for /f "delims=" %%i in ('%PYTHON% -c "import sysconfig; print(sysconfig.get_config_var('SOABI'))"') do set "PY_SOABI=%%i"
set "CMAKE_ARGS=%CMAKE_ARGS% -DPython_FIND_ABI=ANY;ANY;ANY;ON -DSKBUILD_SOABI=%PY_SOABI%"

:build

%PYTHON% -m pip install . -vv --no-build-isolation -Cgenerator="Visual Studio 17 2022"
if errorlevel 1 exit 1
