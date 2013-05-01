# Cookbook Name:: rackbox
# Recipe:: passenger
#
# Setup passenger apps
#

case node['platform_family']
when "debian"
  package "libcurl4-openssl-dev"
when "rhel"
  package "libcurl-devel"
end

::Chef::Recipe.send(:include, Rackbox::Helpers)

Array(node["rackbox"]["apps"]["passenger"]).each_with_index do |app, index|
  default_port = node["rackbox"]["upstream_start_port"]["passenger"].to_i + index
  app_dir      = ::File.join(node["appbox"]["apps_dir"], app["appname"], 'current')

  setup_nginx_site(app, app_dir, default_port)
  setup_passenger_runit(app, app_dir, default_port)
end
