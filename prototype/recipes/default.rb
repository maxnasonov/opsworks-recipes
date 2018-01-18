ENV['AWS_REGION'] = node['prototype']['aws_region']

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

name = 'server'

# these should all default correctly.  listing out for example.
logstash_instance name do
  action            :create
end

# services are hard! Let's go LWRP'ing.   FIREBALL! FIREBALL! FIREBALL!
logstash_service name do
  action      [:enable]
end

#my_templates  = node['logstash']['instance_default']['config_templates']

#if my_templates.empty?
#  my_templates = {
#    'input_syslog' => 'config/input_syslog.conf.erb',
#    'output_stdout' => 'config/output_stdout.conf.erb',
#    'output_elasticsearch' => 'config/output_elasticsearch.conf.erb'
#  }
#end

logstash_config name do
#  templates my_templates
  action [:create]
  variables(
    elasticsearch_embedded: false,
    access_key_id: aws_creds["access_key_id"],
    secret_access_key: aws_creds["secret_access_key"]
  )
end

logstash_plugins 'contrib' do
  instance name
  action [:create]
end

logstash_pattern name do
  action [:create]
end

logstash_service name do
  action [:start]
end
