execute 'removed stopped containers' do
    cwd '/docker-compose/'
    command '/usr/bin/docker -a -q | xargs --no-run-if-empty /usr/bin/docker rm'
end
