execute 'clean untagged images' do
    cwd '/docker-compose/'
    command '/usr/bin/docker images --quiet --filter=dangling=true | xargs --no-run-if-empty /usr/bin/docker rmi'
end
