@echo on

:: Patch the Boost.Geometry headers pulled from libboost-headers with the
:: upstream fix for the LineString/Polygon intersection bug on the equator.
:: https://github.com/boostorg/geometry/pull/1483 (not yet in a Boost release)
:: https://github.com/CNES/pangeo-pyinterp/issues/36
patch -p1 -d "%LIBRARY_PREFIX%" < "%RECIPE_DIR%\patches\1483-sjoberg-intersection.patch"
if errorlevel 1 exit 1

%PYTHON% -m pip install . -vv --no-build-isolation -Cgenerator="Visual Studio 17 2022"
if errorlevel 1 exit 1
