#
# Cookbook Name:: movabletype
# Recipe:: default
#
# Copyright 2014, Yuichi Takeuchi
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'yum-epel'
include_recipe 'mysql::server'
include_recipe 'mysql::client'
include_recipe 'memcached'
include_recipe 'perl'
include_recipe 'database::mysql'

%w{
  httpd
  php
  php-mbstring
  php-devel
  php-gd
  php-mbstring
  php-mysql
}.each do |name|
  package name do
    action :install
  end
end

service 'httpd' do
  action [:start, :enable]
end

mysql_connection_info = {
  host: 'localhost',
  username: 'root',
  password: node['mysql']['server_root_password']
}
mysql_database 'mt' do
  connection mysql_connection_info
  action :create
end

%w{
    perl-YAML
    perl-IPC-Run
    perl-Archive-Zip
    perl-GD
    perl-Archive-Tar
    perl-XML-Parser
    perl-Digest-SHA1
    perl-Time-HiRes
    perl-MailTools
    perl-CGI
    perl-MIME-Lite
    perl-File-Copy-Recursive
    perl-IO-String
    perl-XML-SAX
    perl-XML-LibXML
    perl-Cache-Memcached
    perl-Crypt-SSLeay
    perl-Authen-SASL
    perl-Class-Accessor
    perl-SOAP-Lite
    perl-YAML-Syck
    perl-JSON
    perl-Net-SSLeay
    perl-IO-Socket-SSL
    perl-Net-SMTP-SSL
    perl-DBD-MySQL
    ImageMagick-perl
}.each do |pkg_name|
  yum_package pkg_name do
    action :install
  end
end

%w{
  HTTP::Date
  JSON::XS
  Cache::File
  Crypt::DSA
}.each do |module_name|
  cpan_module module_name
end

{
  'mt.conf' => '/etc/httpd/conf.d/mt.conf',
  'httpd.conf' => '/etc/httpd/conf/httpd.conf',
}.each do |from, to|
  cookbook_file from do
    path to
    action :create
    notifies :restart, 'service[httpd]'
  end
end

%w{
  public
  logs
}.each do |dirname|
  directory "/vagrant/#{dirname}" do
    action :create
    user 'vagrant'
    group 'vagrant'
  end
end

git '/vagrant/public/mt' do
  repository 'https://github.com/movabletype/movabletype.git'
  action :export
  user 'vagrant'
  group 'vagrant'
end

cookbook_file 'mt-config.cgi' do
  path '/vagrant/public/mt/mt-config.cgi'
  user 'vagrant'
  group 'vagrant'
  mode '0644'
end

directory "/vagrant/public/mt/site-plugins" do
  action :create
  user 'vagrant'
  group 'vagrant'
end
