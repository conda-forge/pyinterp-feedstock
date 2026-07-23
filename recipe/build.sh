#!/bin/bash
set -euxo pipefail

# Patch the Boost.Geometry headers pulled from libboost-headers with the
# upstream fix for the LineString/Polygon intersection bug on the equator.
# https://github.com/boostorg/geometry/pull/1483 (not yet in a Boost release)
# https://github.com/CNES/pangeo-pyinterp/issues/36
patch -p1 -d "$PREFIX" < "$RECIPE_DIR/patches/1483-sjoberg-intersection.patch"

$PYTHON -m pip install . -vv --no-build-isolation
