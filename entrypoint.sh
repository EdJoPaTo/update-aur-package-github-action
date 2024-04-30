#!/usr/bin/env bash
set -eu -o pipefail
export HOME=/home/builder

pkgname=$INPUT_PACKAGE_NAME

NEW_VERSION=${GITHUB_REF##*/v}

echo "$INPUT_SSH_PRIVATE_KEY" > ~/.ssh/aur
chmod 600 ~/.ssh/aur

cd /tmp
git clone "ssh://aur@aur.archlinux.org/$pkgname.git"
cd "$pkgname"

sed -i "s/^pkgver=.*$/pkgver=$NEW_VERSION/" PKGBUILD
sed -i "s/^pkgrel=.*$/pkgrel=1/" PKGBUILD

echo "::group::updpkgsums"
updpkgsums
echo "::endgroup::"

makepkg --printsrcinfo > .SRCINFO

echo "::group::git commit"
git add PKGBUILD .SRCINFO
git commit -m "Update to $NEW_VERSION"
echo "::endgroup::"
echo "::group::git show"
git show --color
echo "::endgroup::"

echo "::group::Build"
makepkg --clean --cleanbuild --syncdeps --noconfirm --needed
echo "::endgroup::"

echo "::group::git push"
git push
echo "::endgroup::"
