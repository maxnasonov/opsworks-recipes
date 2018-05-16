include_recipe 'prototype::default'

ruby_block 'Trigger td-agent restart' do
  block {}
  notifies :restart, 'service[td-agent]', :immediately    
end