directory '/etc/sensu' do
  owner 'root'
  group 'root'
  mode  '00755'
end

template '/etc/sensu/client.json' do
  source 'client.json.erb'
  owner 'root'
  group 'root'
  mode 00644
end
