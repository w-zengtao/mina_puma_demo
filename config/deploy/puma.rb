require 'mina/bundler'
require 'mina/rails'

namespace :puma do
  set :web_server, :puma
  set_default :puma_env,       -> { fetch(:rails_env, 'production') }
  set_default :puma_config,    -> { "#{deploy_to}/#{shared_path}/config/puma.rb" }
  set_default :puma_socket,    -> { "#{deploy_to}/#{shared_path}/tmp/sockets/puma.sock" }
  set_default :puma_state,     -> { "#{deploy_to}/#{shared_path}/tmp/sockets/puma.state" }
  set_default :puma_pid,       -> { "#{deploy_to}/#{shared_path}/tmp/pids/puma.pid" }
  set_default :puma_cmd,       -> { "#{cmd_prefix} puma" }
  set_default :pumactl_cmd,    -> { "#{cmd_prefix} pumactl" }
  set_default :pumactl_socket, -> { "#{deploy_to}/#{shared_path}/tmp/sockets/pumactl.sock" }

  desc 'Start puma'
  task start: :environment do
    queue! %{
      if [ -e '#{pumactl_socket}' ]; then
        echo 'Puma is already running';
      else
        if [ -e '#{puma_config}' ]; then
          cd #{deploy_to}/#{current_path} && #{puma_cmd} -q -d -e #{puma_env} -C #{puma_config}
        else
          echo 'no puma.rb file in #{deploy_to}/#{shared_path}/config/puma.rb'
        fi
      fi
    }
  end

  desc 'Stop puma'
  task stop: :environment do
    queue! %{
      if [ -e '#{pumactl_socket}' ]; then
        cd #{deploy_to}/#{current_path} && #{pumactl_cmd} -S #{puma_state} stop
        rm -f #{pumactl_socket}
      else
        echo 'Puma is not running';
      fi
    }
  end

  desc 'Restart puma'
  task restart: :environment do
    invoke :'puma:stop'
    invoke :'puma:start'
  end

  desc 'Restart puma (phased restart)'
  task phased_restart: :environment do
    queue! %{
      if [ -e '#{pumactl_socket}' ]; then
        cd #{deploy_to}/#{current_path} && #{pumactl_cmd} -S #{puma_state} --pidfile #{puma_pid} phased-restart
      else
        echo 'Puma is not running';
      fi
    }
  end

end
