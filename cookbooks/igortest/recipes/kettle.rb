#
# Cookbook Name:: igortest
# Recipe:: default
#
# Copyright 2012, Percipio Media
#
# All rights reserved - Do Not Redistribute
#
# Set flag on server rs_agent_dev:download_cookbooks_once=true

rightscale_marker :begin

log "Installing Kettle through Chef on RightScale!"

cookbookDir = run_context.cookbook_collection[cookbook_name].root_dir
log "Cookbook directory #{cookbookDir}"

#app_server = true

=begin
ruby_block "reload_client_config" do
  block do
    #Chef::Config.from_file("/etc/chef/client.rb")
    #puts ROOT_DIR

    # http://stackoverflow.com/questions/13689811/get-deployed-cookbook-version
    #puts "HERE!!!!!  -> " + run_context.cookbook_collection[cookbook_name].metadata.version
    puts "HERE!!!!!  -> " + run_context.cookbook_collection[cookbook_name].root_dir

    f = File.open('/home/pentaho/output.txt', 'w')
	f.puts node.inspect
	f.close
	f = File.open("/home/pentaho/#{cookbook_name}.txt", 'w')
	f.puts run_context.cookbook_collection[cookbook_name].inspect
	f.close
	f = File.open('/home/pentaho/env.txt', 'w')
	f.puts ENV.inspect
	f.close
    #puts ENV.inspect
    #puts node.inspect
    #node.each do |key,value|
    #	puts key.to_s + " -> " + value.to_s
    	#log item.to_s
    #end
  end
  action :create
end

# http://stackoverflow.com/questions/10318919/how-to-access-current-values-from-a-chef-data-bag?rq=1
file "/home/pentaho/script.json" do
  owner "root"
  group "root"
  mode 0644
  content node[:whatever].to_json
 end
=end

#right_link_tag "rs_agent_dev:download_cookbooks_once=true" do
#  log "No servers to detach" do
#    only_if { app_server == true }
#  end
#end

=begin
cookbook_file "/tmp/kettle.tar.gz" do
  source "kettle/pdi-ce-4.3.0-stable.tar.gz" # this is the value that would be inferred from the path parameter
  mode "0644"
end
=end

homeDir = "/home/pentaho"

user "pentaho" do
  comment "Pentaho User"
  #uid 1000
  gid "users"
  home homeDir
  #shell "/bin/zsh"
  #system true
  #shell "/bin/false"
  shell "/bin/bash"
  #password "$1$JJsvHslV$szsCjVEroftprNn4JHtDi."
  action :create
end

directory homeDir do
  owner "pentaho"
  group "users"
  mode "0700"
  action :create
end

# need to create home directory 

tmpFolder = Chef::Config[:file_cache_path]
kettleBits = "#{tmpFolder}/kettle.tar.gz"
kettleUrl = "http://sourceforge.net/projects/pentaho/files/Data%20Integration/4.3.0-stable/pdi-ce-4.3.0-stable.tar.gz/download"

log "Cache location #{tmpFolder}"

remote_file "#{tmpFolder}/kettle.tar.gz" do
  source "http://sourceforge.net/projects/pentaho/files/Data%20Integration/4.3.0-stable/pdi-ce-4.3.0-stable.tar.gz/download"
  #checksum node[:program][:checksum]  #  This parameter tells Chef not to download the remote file if the local target file matches the checksum. This is a SHA256 checksum.
  checksum "b91018e28299f769f959733809fb1fcb39cd3652"
  #action :nothing
  action :create_if_missing
  #notifies :run, "bash[install_program]", :immediately
end

=begin
# http://stackoverflow.com/questions/8530593/chef-install-and-update-programs-from-source
# see also the remote_request from RS Resources
http_request "HEAD #{kettleUrl}" do
  message ""
  url kettleUrl
  action :head
  if File.exists?(kettleBits)
    headers "If-Modified-Since" => File.mtime(kettleBits).httpdate
  end
  notifies :create, resources(:remote_file => kettleBits), :immediately
end
=end

directory "#{homeDir}/bin" do
  owner "pentaho"
  group "users"
  mode "0700"
  action :create
end

directory "#{homeDir}/logs" do
  owner "pentaho"
  group "users"
  mode "0700"
  action :create
end

#directory "#{homeDir}/repos" do
#  owner "pentaho"
#  group "users"
#  mode "0700"
#  action :create
#end

directory "#{homeDir}/tmp" do
  owner "pentaho"
  group "users"
  mode "0700"
  action :create
end


bash "configure_kettle" do
  user "root"
  cwd "#{homeDir}"
  code <<-EOH
  	chown -R pentaho:users #{homeDir}/bin/
  	echo 'export RS_SKETCHY='$RS_ATTACH_DIR >> #{homeDir}/setenv
  	tar -zxf #{tmpFolder}/kettle.tar.gz -C #{homeDir}/bin
  EOH
  #creates "/home/pentaho/bin"
  #(cd program-#{node[:program][:version]}/ && ./configure && make && make install)
  #action :nothing
end

bash "copy_repos" do
	user "pentaho"
	cwd "#{homeDir}"
	code <<-EOH
		cp -r #{cookbookDir}/files/default/repos/ . 
		chown -R pentaho:users #{homeDir}/repos/
	EOH
end

cron "noop" do
  hour "23"
  minute "5"
  user "pentaho"
  command "#{homeDir}/repos/sparkroom/sparkroom.sh > #{homeDir}/logs/sr_out.txt 2> #{homeDir}/logs/sr_err.txt"
end

=begin
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

depends           "cron"
cron "mirror_rubyforge" do
  command "rsync -av rsync://master.mirror.rubyforge.org/gems/ #{node[:gem_server][:rf_directory]}/gems && gem generate_index -d #{node[:gem_server][:rf_directory]}" 
  hour "2"
  minute "0"
end

=end

#user "testme" do
#  comment "TestMe User"
#  uid 1001
#  gid "users"
#  home "/home/testme"
#  shell "/bin/bash"
#end

#username = 'dev'

#ssh_keys = node[:ssh_access].map do |f|
#	File.read("/tmp/chef-solo/ssh_keys/#{f}")
#end

#template "/home/#{username}/.ssh/authorised_keys" do
#	source "authorized_keys.erb"
#	owner username
#	group 'users'
#	mode "0600"
#	variable :ssh_keys => ssh_keys
#end

rightscale_marker :end
