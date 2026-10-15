#!/bin/bash
set -euxo pipefail

# Patch the Boost.Geometry headers pulled from libboost-headers with the
# upstream fix for the LineString/Polygon intersection bug on the equator.
# https://github.com/boostorg/geometry/pull/1483 (merged in develop, absent from Boost <= 1.92)
# https://github.com/CNES/pangeo-pyinterp/issues/36
patch -p1 -d "$PREFIX" < "$RECIPE_DIR/patches/1483-sjoberg-intersection.patch"

# FindPython ignores free-threaded interpreters unless explicitly requested
# (4th element of Python_FIND_ABI, CMake >= 3.30).
if [[ -d "$PREFIX/include/python${PY_VER}t" ]]; then
  export CMAKE_ARGS="${CMAKE_ARGS:-} -DPython_FIND_ABI=ANY;ANY;ANY;ON"
fi

$PYTHON -m pip install . -vv --no-build-isolation
