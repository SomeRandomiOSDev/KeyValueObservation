#!/usr/bin/env bash

# Needed to circumvent an issue with Carthage version < 0.37.0: https://github.com/Carthage/Carthage/issues/3019
#
# carthage.sh
# Usage example: ./carthage.sh build --platform iOS

function compare_versions() {
    if [ $1 = $2 ]; then
        return 0
    fi

    local IFS=.
    local i LHS=($1) RHS=($2)

    for ((i=${#LHS[@]}; i<${#RHS[@]}; i++)); do
        LHS[i]=0
    done

    for ((i=0; i<${#LHS[@]}; i++)); do
        if [ -z ${RHS[i]} ]; then
            RHS[i]=0
        fi

        if ((10#${LHS[i]} > 10#${RHS[i]})); then
            return 1
        elif ((10#${LHS[i]} < 10#${RHS[i]})); then
            return -1
        fi
    done

    return 0
}

VERSION=`carthage version`
compare_versions "$VERSION" "0.37.0"

if [ $? -ge 0 ]; then
    # Carthage version is greater than or equal to 0.37.0 meaning we can use the --use-xcframeworks flag
    carthage "$@" --use-xcframeworks
else
    # Workaround for Xcode 12 issue for Carthage versions prior to 0.37.0
    set -euo pipefail

    xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
    trap 'rm -f "$xcconfig"' INT TERM HUP EXIT

    # For Xcode 12 make sure EXCLUDED_ARCHS is set to arm architectures otherwise
    # the build will fail on lipo due to duplicate architectures.
    for simulator in iphonesimulator appletvsimulator; do
        echo "EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_${simulator}__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200 = arm64 arm64e armv7 armv7s armv6 armv8" >> $xcconfig
    done
    echo 'EXCLUDED_ARCHS = $(inherited) $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(PLATFORM_NAME)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))' >> $xcconfig

    export XCODE_XCCONFIG_FILE="$xcconfig"
    cat $XCODE_XCCONFIG_FILE
    carthage "$@"
fi
