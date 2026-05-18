#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Build a dummy webkit2gtk3 package to satisfy cloudflare-warp deps
# without pulling in the full GUI stack on a headless install.

dnf5 -y install rpm-build

build_root="$(mktemp -d)"
spec_file="${build_root}/webkit2gtk3-dummy.spec"

cat >"${spec_file}" <<'EOF'
Name:           webkit2gtk3-dummy
Version:        1.0
Release:        1%{?dist}
Summary:        Dummy package to satisfy cloudflare-warp dependencies

License:        MIT
BuildArch:      x86_64

Provides:       webkit2gtk3 = 2.999-1
Provides:       webkit2gtk3(x86-64) = 2.999-1
Provides:       libwebkit2gtk-4.0.so.37()(64bit)

%description
Fake package to bypass GUI dependencies for headless WARP.

%build
:

%install
:

%files

%changelog
* Mon May 18 2026 nhubaotruong <bao.truong@parcelperform.com> - 1.0-1
- Initial dummy package.
EOF

rpmbuild \
    --define "_topdir ${build_root}" \
    --define "_rpmdir ${build_root}/RPMS" \
    --define "_srcrpmdir ${build_root}/SRPMS" \
    --define "_builddir ${build_root}/BUILD" \
    --define "_specdir ${build_root}/SPECS" \
    --define "_sourcedir ${build_root}/SOURCES" \
    -bb "${spec_file}"

rpm_file="$(find "${build_root}/RPMS" -name 'webkit2gtk3-dummy-*.rpm' | head -n1)"
dnf5 -y install "${rpm_file}"

rm -rf "${build_root}"
dnf5 -y remove rpm-build
