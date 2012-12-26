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
	notifiers :restart, "service[ntpd]"
end

service "ntpd" do
	action [:enable, :start]
end


rightscale_marker :end
