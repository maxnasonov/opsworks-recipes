directory '/docker-compose' do
  owner 'root'
  group 'root'
  mode  '00755'
end

template '/docker-compose/docker-compose.yml' do
  source 'docker-compose.yml.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables ({
    :my_layer = search("aws_opsworks_layer").first
  })
end

include_recipe 'docker-compose::pull'
include_recipe 'docker-compose::stop'
include_recipe 'docker-compose::rm'
include_recipe 'docker-compose::up'
