package 'Install Docker' do
  case node[:platform]
  when 'redhat', 'centos'
    package_name 'docker'
  when 'ubuntu', 'debian'
    package_name 'docker.io'
  end
end

service 'Docker' do
  case node[:platform]
  when 'redhat', 'centos'
    service_name 'docker'
  when 'ubuntu', 'debian'
    service_name 'docker.io'
  end
end

package 'python-pip'

python_pip 'docker-compose'

include_recipe 'docker-compose::cron'
include_recipe 'docker-compose::login'
