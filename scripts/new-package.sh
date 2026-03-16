#!/usr/bin/env bash
# =============================================================================
# CoreOS Repo — new-package helper
# Usage: ./scripts/new-package.sh <pkgname> <github-source-url>
# Example: ./scripts/new-package.sh modforge-cli https://github.com/Frank1o3/ModForge-CLI
# =============================================================================

set -euo pipefail

BLD='\033[1m'
BLU='\033[0;34m'
GRN='\033[0;32m'
RST='\033[0m'

info()    { echo -e "${BLU}${BLD}==> ${RST}${BLD}$*${RST}"; }
success() { echo -e "${GRN}${BLD}==> ${RST}${BLD}$*${RST}"; }

[[ $# -lt 2 ]] && { echo "Usage: $0 <pkgname> <github-url>"; exit 1; }

PKGNAME="$1"
GITHUB_URL="$2"
PKGDIR="packages/${PKGNAME}"

[[ -d "$PKGDIR" ]] && { echo "Package ${PKGNAME} already exists."; exit 1; }

info "Creating package scaffold for ${PKGNAME}..."
mkdir -p "$PKGDIR"

cat > "${PKGDIR}/PKGBUILD" << EOF
# Maintainer: Franklin <https://github.com/Frank1o3>
pkgname=${PKGNAME}
pkgver=1.0.0
pkgrel=1
pkgdesc="TODO: describe your package"
arch=('any')
url="${GITHUB_URL}"
license=('MIT')
depends=()
optdepends=()
conflicts=()
provides=('${PKGNAME}')
# Update source URL to match your release asset filename
source=("\${pkgname}-\${pkgver}.tar.gz::${GITHUB_URL}/releases/download/v\${pkgver}/\${pkgname}-\${pkgver}.tar.gz")
sha256sums=('SKIP')

package() {
    # TODO: implement your install logic
    cd "\${srcdir}/\${pkgname}-\${pkgver}"
    make DESTDIR="\${pkgdir}" install
}
EOF

success "Created ${PKGDIR}/PKGBUILD"
info "Next steps:"
echo "  1. Edit ${PKGDIR}/PKGBUILD — fill in depends, source URL, and package() function"
echo "  2. git add ${PKGDIR}"
echo "  3. git commit -m 'packages: add ${PKGNAME}'"
echo "  4. git push"
echo "  5. When ready to release: git tag ${PKGNAME}-v1.0.0 && git push --tags"
echo "     → GitHub Action builds, signs, and publishes automatically"
