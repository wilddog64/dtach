# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'
$LOAD_PATH.unshift( File.expand_path( File.join( File.dirname( __FILE__ ), 'bin' ) ) )
require 'aws'

aws_config = Aws.new( '~/.aws', 'mgmt' )
script_dir = File.join( File.dirname(__FILE__), 'bin' )
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = 'dtach-berkshelf'

  # Set the version of chef to install using the vagrant-omnibus plugin
  # NOTE: You will need to install the vagrant-omnibus plugin:
  #
  #   $ vagrant plugin install vagrant-omnibus
  #
  if Vagrant.has_plugin?("vagrant-omnibus")
    config.omnibus.chef_version = 'latest'
  end

  # Every Vagrant virtual environment requires a box to build off of.
  # If this value is a shorthand to a box in Vagrant Cloud then
  # config.vm.box_url doesn't need to be specified.
  config.vm.box = 'dummy'

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  # if vagrant-berkshelf plugin is installed, then provide some configuration values here
  if Vagrant.has_plugin?( 'vagrant-berkshelf' )
    config.berkshelf.berksfile_path = './Berksfile'
    config.berkshelf.enabled        = true
  end

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.ssh.pty = true
  combined_text = File.join(script_dir, 'combined.txt')
  if Vagrant.has_plugin?( 'vagrant-aws' )
    config.vm.box     = 'dummy'
    config.vm.provider :aws do | aws, override |
      aws.access_key_id             = aws_config.aws_access_key_id
      aws.secret_access_key         = aws_config.aws_secret_access_key
      aws.region                    = aws_config.region
      aws.keypair_name              = 'dblOps'
      aws.instance_type             = 'm3.large'
      aws.iam_instance_profile_name = 'mgmt'
      aws.ami                       = 'ami-a2a12eca'    # amzn
      aws.tags                      = { 'Name' => 'test-dbl_java', }
      aws.security_groups           = [ 'production_management' ]
      user_data                     = File.read( combined_text )
      aws.user_data = user_data
      override.ssh.pty              = true
      override.ssh.private_key_path = File.expand_path( '~/.ssh/dblOps.pem' )
      override.ssh.username         = 'ec2-user'
    end
  end

  config.vm.provision :chef_zero do |chef|
    chef.json = {
    }

    chef.run_list = [
      'recipe[dtach::default]'
    ]
  end
end
