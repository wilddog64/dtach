file_cache_path  = Chef::Config['file_cache_path']
dtach_git_repo   = node['dtach']['git']['repo']
app_name         = node['dtach']['git']['app']
app_path         = ::File.join(file_cache_path, app_name)
app_install_root = node['dtach']['install']['root']
git app_name do
  repository dtach_git_repo
  destination app_path
  action :sync
  notifies :run, 'execute[build-dtach]', :immediately
  notifies :run, 'execute[copy-dtach]', :immediately
end

execute 'build-dtach' do
  cwd app_path
  command <<-EOF
  ./configure
  make
  EOF
  action :nothing
end

execute 'copy-dtach' do
  cwd app_path
  command <<-EOF
  cp dtach #{app_install_root}
  EOF
  action :nothing
end

include_recipe 'minitest-handler'
