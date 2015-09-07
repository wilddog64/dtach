file_cache_path = Chef::Config['file_cache_path']
dtach_git_repo  = node['dtach']['git']['repo']
app_name        = node['dtach']['git']['app']
app_path        = ::File.join(file_cache_path, app_name)
git app_name do
  repository dtach_git_repo
  destination app_path
  action :sync
  notifies :run, 'execute[build-dtach]', :immediately
end

execute 'build-dtach' do
  cwd app_path
  command <<-EOF
  ./configure
  make
  EOF
end
