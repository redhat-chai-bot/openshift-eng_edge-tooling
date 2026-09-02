#!/usr/bin/env bash

set -euo pipefail

SCRIPTDIR="$(dirname "${BASH_SOURCE[0]}")"
REPOROOT="$(git rev-parse --show-toplevel)"
ENVDIR="${REPOROOT}/_output/release_testing"

if [[ ! -d "${ENVDIR}" ]]; then
    echo "Setting up required tools..." >&2
    mkdir -p "${REPOROOT}/_output"
    python3 -m venv "${ENVDIR}"
fi
"${ENVDIR}/bin/python3" -m pip install -r "${SCRIPTDIR}/requirements.txt" >&2
# Optional: Kerberos auth (needs krb5-devel headers to build).
"${ENVDIR}/bin/python3" -m pip install 'requests-gssapi>=1.3.0,<2' 2>/dev/null \
    || echo "Note: requests-gssapi not installed (Kerberos auth unavailable)" >&2

cd "${SCRIPTDIR}"
"${ENVDIR}/bin/python3" -m unittest unit_tests.test_logic unit_tests.test_prow -v
