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
    #version '1.6.2~dfsg1-1ubuntu4~14.04.1'
  end
end

service 'Docker' do
  service_name 'docker'
  supports restart: true, reload: true
  action %w(enable start)
end

package 'python-pip'

python_pip 'docker' do
  version '2.6.1'
end

python_pip 'docker-compose' do
  version '1.17.1'
end

include_recipe 'docker-compose::cron'
