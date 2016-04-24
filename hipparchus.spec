%global __requires_exclude libc.so.6(GLIBC_PRIVATE)(64bit)

Name: hipparchus
Version: 0.1
Release: 1%{?dist}
Summary: Cache responces from Google Maps API
Group: Applications/System
License: MIT
URL: http://strzibny.name/
Source0: hipparchus
Source1: hipparchus.service
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
#unzip -o %{SOURCE0} -d %{buildroot}%{_bindir}
install -m 0755 %{SOURCE0} %{buildroot}%{_bindir}

# systemd service
mkdir -p %{buildroot}%{_unitdir}
install -m 0644 %SOURCE1 %{buildroot}%{_unitdir}

%post
%systemd_post hipparchus.service

%preun
%systemd_preun hipparchus.service

%postun
%systemd_postun_with_restart hipparchus.service

%files
%{_bindir}/*
%{_unitdir}/hipparchus.service

%changelog
* Mon Apr 18 2016 Josef Strzibny <strzibny@strzibny.name> - 0.1-1
- Initial package
