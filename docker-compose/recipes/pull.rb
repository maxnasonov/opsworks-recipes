execute 'pull containers images' do
    cwd '/docker-compose/'
    command 'docker-compose pull'
end
