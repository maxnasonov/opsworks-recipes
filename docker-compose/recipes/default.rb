if node[:platform] == 'ubuntu'
  apt_repository "docker" do
    retries 3
    uri "https://download.docker.com/linux/ubuntu"
    distribution node['lsb']['codename']
    components ["stable"]
    keyserver "keyserver.ubuntu.com"
    key "9DC858229FC7DD38854AE2D88D81803C0EBFCD88"
  end
end
package 'Install Docker' do
  case node[:platform]
  when 'redhat', 'centos', 'amazon'
    package_name 'docker'
  when 'ubuntu', 'debian'
    package_name 'docker-ce'
    version "18.06.1~ce~3-0~ubuntu"
    #version '1.6.2~dfsg1-1ubuntu4~14.04.1'
  end
end

service 'Docker' do
  service_name 'docker'
  supports restart: true, reload: true
  action %w(enable start)
end

package 'python-pip'

python_pip 'pip' do
  action :upgrade
end

python_pip 'pip-upgrade' do
  package_name 'pip'
  action :upgrade
end

#python_pip 'setuptools' do
#  action :upgrade
#end
#
python_pip 'zipp' do
  version '1.1.1'
end

python_pip 'pyrsistent' do
  version '0.16.1'
end

python_pip 'docker'

python_pip 'docker-compose' do
  action :upgrade
end

include_recipe 'docker-compose::cron'
