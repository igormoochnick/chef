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

rightscale_marker :end
