#!/usr/bin/env bash
# Runs the GearScout backend. The build requires JDK 25, so we
# locate a JDK 25 installation and run Gradle with it, without requiring
# JAVA_HOME to be set globally.
set -euo pipefail
cd "$(dirname "$0")"

is_jdk25() {
	[[ -n "${1:-}" && -x "$1/bin/java" ]] &&
		"$1/bin/java" -version 2>&1 | grep -q 'version "25\.'
}

candidates=()
[[ -n "${JAVA_HOME:-}" ]] && candidates+=("$JAVA_HOME")

if [[ -x /usr/libexec/java_home ]]; then
	resolved="$(/usr/libexec/java_home -v 25 2>/dev/null || true)"
	[[ -n "$resolved" ]] && candidates+=("$resolved")
fi

candidates+=(
	/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home
	/usr/local/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home
)

if [[ -d /usr/lib/jvm ]]; then
	while IFS= read -r dir; do
		candidates+=("$dir")
	done < <(find /usr/lib/jvm -maxdepth 1 -type d -name "*25*" 2>/dev/null)
fi

for jdk in "${candidates[@]}"; do
	if is_jdk25 "$jdk"; then
		export JAVA_HOME="$jdk"
		break
	fi
done

if ! is_jdk25 "${JAVA_HOME:-}"; then
	echo "error: JDK 25 not found." >&2
	echo "Install it, e.g.: brew install --cask temurin@25" >&2
	echo "(Linux: sudo apt install openjdk-25-jdk or your distro's equivalent)" >&2
	exit 1
fi

echo "Using JAVA_HOME=$JAVA_HOME"
exec ./gradlew bootRun
