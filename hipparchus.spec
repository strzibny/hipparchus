%global __requires_exclude libc.so.6(GLIBC_PRIVATE)(64bit)

# To create an SRPM for Copr submission:
#   touch sources
#   fedpkg --dist f23 srpm
Name: hipparchus
Version: 0.1
Release: 1%{?dist}
Summary: Cache responces from Google Maps API
Group: Applications/System
License: MIT
URL: https://github.com/strzibny/hipparchus
# To make the binary:
#   git clone https://github.com/strzibny/hipparchus.git && cd hipparchus
#   git checkout vVERSION
#   crystal build --release src/hipparchus.cr
Source0: hipparchus
Source1: hipparchus.service
Source2: LICENSE
Requires: redis
Requires(post):   systemd
Requires(preun):  systemd
Requires(postun): systemd
BuildRequires:    systemd

%description
Hipparchus saves requests to Google Maps API by caching the responces in a local Redis store.

%prep

%build

%install
mkdir -p %{buildroot}%{_bindir}
install -m 0755 %{SOURCE0} %{buildroot}%{_bindir}

# systemd service
mkdir -p %{buildroot}%{_unitdir}
install -m 0644 %SOURCE1 %{buildroot}%{_unitdir}

# license file
mkdir -p %{buildroot}%{_defaultdocdir}/hipparchus
install -m 0444 %SOURCE2 %{buildroot}%{_defaultdocdir}/hipparchus

%post
%systemd_post hipparchus.service

%preun
%systemd_preun hipparchus.service

%postun
%systemd_postun_with_restart hipparchus.service

%files
%{_bindir}/*
%{_unitdir}/hipparchus.service
%doc %{_defaultdocdir}/hipparchus/LICENSE

%changelog
* Mon Apr 18 2016 Josef Strzibny <strzibny@strzibny.name> - 0.1-1
- Initial package
