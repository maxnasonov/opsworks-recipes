execute 'remove containers' do
    cwd '/docker-compose/'
    command 'docker-compose rm --force'
end
