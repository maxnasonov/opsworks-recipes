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

directory "#{Chef::Config['file_cache_path']}/mellon"

node['prototype']['mellon_files'].each do |mellon_file|
  if mellon_file == "FederationMetadata.xml"
    S3encrypt.getfile(mellon_file, "#{Chef::Config['file_cache_path']}/mellon/#{mellon_file}", node['prototype']['s3_bucket'], node['prototype']['encryption_context'])
  else
    S3encrypt.getfile(mellon_file, "#{Chef::Config['file_cache_path']}/mellon/adfs.#{mellon_file.split('.')[-1]}", node['prototype']['s3_bucket'], node['prototype']['encryption_context'])
  end
end

