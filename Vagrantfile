Vagrant.configure(2) do |config|
  config.vm.box = 'centos/7'

  config.vm.network(
    'forwarded_port',
    guest: 80,
    host: 8080,
    host_ip: '127.0.0.1'
  )

  config.vm.provider 'virtualbox' do |vb|
    vb.gui    = false
    vb.memory = 1_024
  end

  config.vm.synced_folder '..', '/usr/local/src'

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'playbook.yml'
  end
end

# vim: ft=ruby:sw=2:et
