include_recipe 'prototype::default'

execute 'trigger td-agent restart' do
  command "/etc/init.d/td-agent restart"
end