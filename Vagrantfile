require 'json'
require 'fileutils'
require 'yaml'

# read in config.yaml
conf = YAML::load(File.open('./config.yaml'))

# read servers definitions
servers = YAML::load(File.open('./servers.yaml'))
vb_conf = servers["virtualbox"]
aws_conf = servers["aws"]

# secrets definitions
secrets = YAML::load(File.open('./secrets.yaml'))

Vagrant.configure("2") do |config|
  config.vm.box = vb_conf["box"]
  config.vm.box_url = vb_conf['box_url']
  config.vm.network "forwarded_port", guest: 5000, host: 5001
  config.vm.network "forwarded_port", guest: 80, host: 3001
  config.vm.network "forwarded_port", guest: 5432, host: 2345
  config.vm.define "newslynx" do |machine|
    machine.vm.provider :virtualbox do |v|  
      if vb_conf["ram"]
        v.memory = vb_conf["ram"]
      else
        v.memory = 8096
      end
      if vb_conf["cpu"]
        v.cpus = vb_conf["cpu"]
      else
        v.cpus = 4
      end

      # include a mounted drive for postgres
      if vb_conf["pg_mnt"]
        d = vb_conf["pg_mnt"]
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

    machine.vm.provider :aws do |aws, override|
      override.vm.box = "dummy"
      override.vm.synced_folder ".", "/vagrant", disabled: true
      aws.access_key_id = secrets['aws_access_key_id']
      aws.secret_access_key = secrets['aws_secret_access_key']
      aws.keypair_name = aws_conf['keypair_name']
      aws.region = aws_conf['region']
      aws.elastic_ip = true
      aws.ami = aws_conf['ami']
      aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => aws_conf['ebs_size'] }]
      aws.instance_type = aws_conf['instance_type']

      aws.tags = {
        'Name' => 'NewsLynx'
      }

      override.ssh.username = aws_conf['ssh_username']
      override.ssh.private_key_path = aws_conf['ssh_private_key_path']
    end

    machine.vm.provision "ansible" do |ansible|
      ansible.extra_vars = { ansible_ssh_user: "vagrant", hostname: "newslynx"}
      ansible.playbook = "provisioning/main.yaml"
      ansible.verbose = "vvvv"
      ansible.extra_vars = {
        pg_mnt_path: "/dev/sda1",
        conf: conf 
      }
    end
  end
end