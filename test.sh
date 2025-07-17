#!/usr/bin/env bash

set -euo pipefail

# Set which flox you want to use
if [ -z "${FLOXBIN:-}" ]; then
  FLOXBIN="nix run github:flox/flox --"
fi

echo "Using flox command: $FLOXBIN"

# Config
BASE_PORT=3000
TIMEOUT=15
ENVS=$(find ./* -type d -prune -print |xargs -0 | tr -d './')
declare -a DEFAULT_BUILD_MODIFIERS
DEFAULT_BUILD_MODIFIERS=("" "-pure" "-nix")
declare -a FIXME_BUILDS
FIXME_BUILDS=(
    "quotes-app-jvm-pure"
    "quotes-app-cpp-nix"
    "quotes-app-go-nix"
    "quotes-app-jvm-nix"
    "quotes-app-nodejs-nix"
    "quotes-app-python-nix"
    "quotes-app-ruby-nix"
    "quotes-app-rust-nix"
)

# Global test results
declare -a TEST_RESULTS
TEST_RESULTS=()

build_app() {
  local env_name="$1"
  local build_name="$2"
	echo "🔨 Building $build_name with Flox..."
	pushd "$env_name" > /dev/null
	$FLOXBIN build clean
	$FLOXBIN build "$build_name"
	popd > /dev/null
}

wait_for_server() {
	local port=$1
	for _i in $(seq 1 "$TIMEOUT"); do
		if curl -s "http://localhost:${port}/quotes/1" > /dev/null; then
			return 0
		fi
		sleep 1
	done
	return 1
}

test_app() {
  local env_name="$1"
  local build_name="$2"
	local port=$BASE_PORT
	echo "Testing $build_name on port $port..."

  declare binary
  declare dir
  dir=$(dirname "$env_name")
	binary="${env_name}/result-${build_name}/bin/${build_name}"

	pushd "$dir" > /dev/null
	echo "Running binary $binary"
	./"$binary" &
	local SERVER_PID=$!
	popd > /dev/null

	if ! wait_for_server "$port"; then
		echo "❌ Server $build_name did not become ready on port $port."
		TEST_RESULTS+=("❌ $build_name server not ready")
		kill $SERVER_PID
		wait $SERVER_PID 2>/dev/null || true
		return 1
	fi

	local status
	status=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$port/quotes/1")
	echo "Status code: $status"

	if [[ "$status" -eq 200 ]]; then
		echo "✅ $build_name test passed."
		TEST_RESULTS+=("✅ ${build_name}")
	else
		echo "❌ $build_name test failed: bad response."
		TEST_RESULTS+=("❌ $build_name response $status")
	fi

	kill $SERVER_PID
	wait $SERVER_PID 2>/dev/null || true
}

print_summary() {
	echo
	echo "📋 Test Summary:"
	for result in "${TEST_RESULTS[@]}"; do
		echo "  - $result"
	done
}

main() {
	local targets=()

	if [[ $# -eq 0 ]]; then
		targets=($ENVS)
	else
		targets=("$@")
	fi

	for env_name in "${targets[@]}"; do
		if [[ ! -d "$env_name" ]]; then
			echo "⚠️  Skipping '${env_name}': directory not found."
			continue
		fi
	  for build_mod in "${DEFAULT_BUILD_MODIFIERS[@]}"; do
	    local build_name
	    build_name="${env_name}${build_mod}"
	    local should_skip
	    should_skip="false"
	    for fixme_build in "${FIXME_BUILDS[@]}"; do
	    	if [ "$build_name" == "$fixme_build" ]; then
					echo "⚠️  Skipping '${build_name}': FIXME"
					TEST_RESULTS+=("⚠️ FIXME: ${build_name}")
					should_skip="true"
					break;
	    	fi
	    done
	  	if [ "$should_skip" == "false" ]; then
	  		build_app "$env_name" "$build_name"
	  		test_app "$env_name" "$build_name"
	  	fi
	  done
	done

	print_summary
}

main "$@"
