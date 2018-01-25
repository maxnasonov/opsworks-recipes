ENV['AWS_REGION'] = node['prototype']['aws_region']
node.set_unless[:prototype][:instance_id] = `ec2metadata --instance-id`.chomp
node.save

%w{aws-sdk s3encrypt}.each do |g|
  chef_gem g do
    action :install
    compile_time true
  end
end

# Require necessary gems and libraries
require 'aws-sdk'
require 's3encrypt'

directory "/opt/mellon" do
  recursive true
end

ruby_block 'download-mellon-files' do 
  block do
    node['prototype']['mellon_files'].each do |mellon_file|
      if mellon_file == "FederationMetadata.xml"
        S3encrypt.getfile("/opt/mellon/#{mellon_file}", mellon_file, node['prototype']['s3_bucket'], node['prototype']['encryption_context'])
      else
        S3encrypt.getfile("/opt/mellon/adfs.#{mellon_file.split('.')[-1]}", mellon_file, node['prototype']['s3_bucket'], node['prototype']['encryption_context'])
      end
    end
  end
end

include_recipe 'python'

# Work around pip install's snimissingwarning
python_pip 'pip' do
  version '8.1.2'
  action :upgrade
end

config = node['beaver']['configuration']
config.store('transport', 'sqs')
config.store('sqs_aws_queue', 'logstash-input')
config.store('queue_timeout', '180')
config.store('logstash_version', '1')
config.store('sincedb_path', '/etc/beaver/since.db')
node.default['beaver']['configuration'] = config
node.default['beaver']['files'] = []
node.default['beaver']['version'] = '36.2.1'
node.default['beaver']['user'] = 'root'
node.default['beaver']['group'] = 'root'
include_recipe "beaver"

if node['platform'] == 'ubuntu' && node['platform_version'].to_f >= 12.04
  chef_gem 'chef-rewind'
  require 'chef/rewind'

  rewind :template => '/etc/init/beaver.conf' do
    cookbook_name 'prototype'
    owner 'root'
    group 'root'
    variables node['beaver']
    notifies :restart, 'service[beaver]'
    path '/lib/systemd/system/beaver.service'
    source 'beaver.service.erb'
    mode '0644'
  end

  rewind :service => 'beaver' do
    provider Chef::Provider::Service::Systemd
  end
end

# Follow all logs in /var/log except some useless logs, and chef ones which are handled separately (see below).
beaver_tail "system_logs" do
  path "/var/log/*log"
  type "syslog"
  format "json"
  tags [
    "syslog",
    "prototype",
    node['prototype']['name']
  ]
  exclude "(dpkg|alternatives|lastlog|chef|beaver)"
  add_field_env [
    "instanceID", "INSTANCE_ID",
    "rm_type", "RM_TYPE",
    "prototype_name", "PROTOTYPE_NAME"
  ]
end
