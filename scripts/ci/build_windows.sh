#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
dist_dir="${repo_root}/dist"
commit_sha="$(git -C "${repo_root}" rev-parse HEAD)"

mkdir -p "${dist_dir}"

build_target() {
  local arch="$1"
  local label="$2"
  local exe_name="stockfish18-aggr-win-${label}.exe"
  local info_name="stockfish18-aggr-win-${label}-build.txt"
  local make_cmd="make -j2 build ARCH=${arch} COMP=mingw"

  (cd "${repo_root}/src" && make objclean)
  (cd "${repo_root}/src" && ${make_cmd})
  (cd "${repo_root}/src" && make strip)

  cp "${repo_root}/src/stockfish.exe" "${dist_dir}/${exe_name}"

  {
    echo "Stockfish Windows build"
    echo "Command: ${make_cmd}"
    echo "Commit: ${commit_sha}"
    echo "Strip: make strip"
  } > "${dist_dir}/${info_name}"
}

build_target "x86-64-avx2" "avx2"
build_target "x86-64-bmi2" "avx2-bmi2"
