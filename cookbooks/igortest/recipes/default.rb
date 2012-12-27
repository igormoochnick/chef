#
# Cookbook Name:: igortest
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

log "Hello World! You should try Chef with RightScale!"

package "ntp" do
	action [:install]
end

template "/etc/ntp.conf" do
	source "ntp.conf.erb"
	variables( :ntp_server => "time.nist.gov" )
	notifies :restart, "service[ntpd]"
end

service "ntpd" do
	action [:enable, :start]
end

user "random" do
  comment "Random User"
  uid 1000
  gid "users"
  home "/home/random"
  shell "/bin/zsh"
  password "$1$JJsvHslV$szsCjVEroftprNn4JHtDi."
end

username = 'dev'

ssh_keys = node[:ssh_access].map do |f|
	File.read("/tmp/chef-solo/ssh_keys/#{f}")
end

template "/home/#{username}/.ssh/authorised_keys" do
	source "authorized_keys.erb"
	owner username
	group ;users'
	mode "0600"
	variable :ssh_keys => ssh_keys
end

rightscale_marker :end
