require 'json'
require 'fileutils'

# read servers definitions
servers = File.read('./servers.json')
servers = JSON.parse(servers)
vb = servers["virtualbox"]

Vagrant.configure("2") do |config|
  
  config.vm.box = vb["box"]
  config.vm.box_url = vb['box_url']
  config.vm.network "forwarded_port", guest: 5000, host: 5001
  config.vm.network "forwarded_port", guest: 3000, host: 3001
  config.vm.define "newslynx" do |machine|
    machine.vm.provider :virtualbox do |v|  
      if vb["ram"]
        v.memory = vb["ram"]
      else
        v.memory = 8096
      end
      if vb["cpu"]
        v.cpus = vb["cpu"]
      else
        v.cpus = 4
      end

      # include a mounted drive for postgres
      if vb["pg_mnt"]
        d = vb["pg_mnt"]
        v.customize [
          "createhd", 
          "--filename", d["path"], 
          "--size", d["size"]
        ]
        v.customize [
          "storageattach", :id, 
          "--storagectl", d["storagectl"],
          "--port", d["port"], 
          "--device", d["device"], 
          "--type", d["type"], 
          "--medium", d["path"]
        ]
      end
    end

    machine.vm.provision "ansible" do |ansible|
      ansible.extra_vars = { ansible_ssh_user: "vagrant", hostname: "newslynx"}
      ansible.playbook = "provisioning/main.yaml"
      ansible.verbose = "vvvv"
      ansible.extra_vars = {
        pg_mnt_path: "/dev/sdb"
      }
    end
  end
end