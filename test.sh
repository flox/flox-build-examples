#!/usr/bin/env bash

set -euo pipefail

# Set which flox you want to use
if [ -z "${FLOXBIN:-}" ]; then
  case "$(uname)" in
    Darwin)
      FLOXBIN="/usr/local/bin/flox"
      ;;
    Linux)
      FLOXBIN="/usr/bin/flox"
      ;;
    *)
      echo "Unsupported OS: $(uname)" >&2
      exit 1
      ;;
  esac
fi

echo "Using flox binary: $FLOXBIN"


# Config
BASE_PORT=3000
TIMEOUT=15

APPS=$(find ./* -type d -prune -print |xargs -0 | tr -d './')

# Global test results
declare -a TEST_RESULTS=()

build_app() {
	local app=$1
	echo "🔨 Building $app with Flox..."
	pushd "$app" > /dev/null
	$FLOXBIN build clean 
	$FLOXBIN build 
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
	local app=$1
	local port=$BASE_PORT
	echo "Testing $app on port $port..."

  declare binary
  declare dir
  dir=$(dirname "$app")
	binary="${app}/result-$(basename "$app")/bin/${app}"

	pushd "$dir" > /dev/null
	echo "Running binary $binary"
	./"$binary" &
	local SERVER_PID=$!
	popd > /dev/null

	if ! wait_for_server "$port"; then
		echo "❌ Server $app did not become ready on port $port."
		TEST_RESULTS+=("❌ $app server not ready")
		kill $SERVER_PID
		wait $SERVER_PID 2>/dev/null || true
		return 1
	fi

	local status
	status=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$port/quotes/1")
	echo "Status code: $status"

	if [[ "$status" -eq 200 ]]; then
		echo "✅ $app test passed."
		TEST_RESULTS+=("✅ $app.")
	else
		echo "❌ $app test failed: bad response."
		TEST_RESULTS+=("❌ $app response $status")
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
		targets=($APPS)
	else
		targets=("$@")
	fi

	for app in "${targets[@]}"; do
		if [[ ! -d "$app" ]]; then
			echo "⚠️  Skipping '$app': directory not found."
			continue
		fi
		build_app "$app"
		test_app "$app"
	done

	print_summary
}

main "$@"

