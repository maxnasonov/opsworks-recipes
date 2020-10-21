if node['antivirus']['enabled'] == 'true'
  cookbook_file "#{Chef::Config[:file_cache_path]}/antivirus_install.sh" do
    source 'antivirus_install.sh'
    mode "0755"
  end

  bash 'install_antivirus' do
  code <<-EOH
    AWS_ACCOUNT=049055303708 #{Chef::Config[:file_cache_path]}/antivirus_install.sh
  EOH
  not_if { ::File.exist?('/opt/CrowdStrike/falconctl') }
  end

  service 'falcon-sensor' do
    action [:start, :enable]
  end
else
  service 'falcon-sensor' do
    action [:stop, :disable]
    ignore_failure true
  end
end
