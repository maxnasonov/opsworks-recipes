directory '/etc/sensu' do
  owner 'root'
  group 'root'
  mode  '00755'
end

directory '/etc/sensu/conf.d' do
  owner 'root'
  group 'root'
  mode  '00755'
end

template '/etc/sensu/conf.d/client.json' do
  source 'client.json.erb'
  owner 'root'
  group 'root'
  mode 00644
end
