Name: hazelcast
Version:
Release:	1%{?dist}
Summary: Hazelcast in Memory Data Grid
Group: Development Tools
License: ASL 2.0
URL: http://www.hazelcast.org
Source0: %{name}.tar.gz
BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch: noarch
Requires: java-1.7.0-openjdk
%define  debug_package %{nil}

%description

%prep
%setup -q

%build
cd ./opt/hazelcast/ && mvn -DskipTests=true clean assembly:assembly

%install
rm -rf %{buildroot}
unzip ./opt/hazelcast/target/*.zip -d %{buildroot}/
mkdir %{buildroot}/opt/
mv %{buildroot}/hazelcast-%{version}  %{buildroot}/opt/hazelcast

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
/opt/hazelcast
%defattr(0755,root,root,-)
/opt/hazelcast/bin/*.sh
%doc

%pre

%post

%preun

%changelog
