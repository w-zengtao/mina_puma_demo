#!/usr/bin/env puma
# edit this file depends on rails env

environment 'production'
threads 2, 64
workers 8

app_name = "ichemical_rails5"
application_path = "/data/rails"
directory "#{application_path}/current"

pidfile "#{application_path}/shared/tmp/pids/puma.pid"
state_path "#{application_path}/shared/tmp/sockets/puma.state"
stdout_redirect "#{application_path}/shared/log/puma.stdout.log", "#{application_path}/shared/log/puma.stderr.log"
bind "unix://#{application_path}/shared/tmp/sockets/#{app_name}.sock"
activate_control_app "unix://#{application_path}/shared/tmp/sockets/pumactl.sock"

daemonize true
on_restart do
  puts 'On restart...'
end
preload_app!
