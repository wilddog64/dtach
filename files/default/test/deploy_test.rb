require 'minitest/spec'
require 'minitest-chef-handler/resources'

describe_recipe 'deploy' do
  it 'should sync dtach git repo to chef file_cache_path' do
    file_cache_path  = Chef::Config['file_cache_path']
    app_name         = node['dtach']['git']['app']
    app_path         = ::File.join(file_cache_path, app_name)
    directory(app_path).must_exist.with(:user, 'root').and(:group, 'root').and(:mode, '0755')
  end

  it 'builds dtach binary' do
    file_cache_path = Chef::Config['file_cache_path']
    app_name        = node['dtach']['git']['app']
    app_path        = ::File.join(file_cache_path, app_name)
    dtach_binary    = ::File.join(app_path, 'dtach')
    file(dtach_binary).must_exist.with(:mode, '0755').and(:group, 'root').and(:user, 'root')
  end
end
