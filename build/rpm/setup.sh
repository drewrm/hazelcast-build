#!/usr/bin/env bash

SOURCE_DIR="/home/vagrant/hazelcast"
GIT_CMD="git --work-tree=$SOURCE_DIR --git-dir=$SOURCE_DIR/.git"
REPO_FILE="/etc/yum.repos.d/epel-apache-maven.repo"

if [ ! -f "$REPO_FILE" ]; then
  sudo wget -O "$REPO_FILE" http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo
fi 

sudo yum install -y jpackage-utils rpmbuild rpmdevtools fedpkg git java-1.7.0-openjdk-devel apache-maven
sudo touch /usr/share/apache-maven/conf/logging
rpmdev-setuptree

if [ ! -d $SOURCE_DIR ]; then
    git clone https://github.com/hazelcast/hazelcast.git $SOURCE_DIR
fi

latest_tag=$($GIT_CMD describe --abbrev=0 --tags)
version=$(echo $latest_tag | cut -c 2-)
release=$($GIT_CMD rev-list ${latest_tag}..HEAD | wc -l)

$GIT_CMD checkout master
$GIT_CMD archive ${latest_tag} --format=tar --prefix=hazelcast-${version}/opt/hazelcast/ | gzip > ~/rpmbuild/SOURCES/hazelcast.tar.gz


cp /vagrant/build/rpm/hazelcast.spec ~/rpmbuild/SPECS/
sed -i "s/Version:.*$/Version: ${version}/g" ~/rpmbuild/SPECS/hazelcast.spec
sed -i "s/Release:.*1/Release: ${release}/g" ~/rpmbuild/SPECS/hazelcast.spec


rm ~/rpmbuild/RPMS/x86_64/hazelcast*.rpm
rpmbuild -bb ~/rpmbuild/SPECS/hazelcast.spec
sudo cp ~/rpmbuild/RPMS/noarch/hazelcast-3.1-1.el6.noarch.rpm /vagrant/packages/
