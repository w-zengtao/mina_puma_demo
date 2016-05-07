puts 'using staging'

set :domain, 'staging_server_ip'
set :user, 'deploy'
set :deploy_to, '/opt/rails_staging'
set :repository, 'git@git.coding.net:soizt/mina_puma_deploy.git'
set :branch, 'staging'
set :rails_env, 'staging'