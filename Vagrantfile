require 'fileutils'
require 'yaml'

# newslynx configurations
conf = YAML::load(File.open('./config.yaml'))

# machine configurations
machines = YAML::load(File.open('./machines.yaml'))
vb_conf = machines["virtualbox"]
aws_conf = machines["aws"]

# secrets configurations
secrets = YAML::load(File.open('./secrets.yaml'))

# vagrant
Vagrant.configure("2") do |config|

  # box type
  config.vm.box = vb_conf["box"]
  config.vm.box_url = vb_conf['box_url']

  # network settings
  config.vm.network "forwarded_port", guest: 5000, host: 5001
  config.vm.network "forwarded_port", guest: 80, host: 3001
  config.vm.network "forwarded_port", guest: 5432, host: 5433

  # box settings
  config.vm.define "newslynx" do |machine|

    # virtualbox
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

    # aws
    machine.vm.provider :aws do |aws, override|
      override.vm.box = "dummy"
      override.vm.synced_folder ".", "/vagrant", disabled: true
      # aws.security_groups = [ 'vagrant' ]
      aws.access_key_id = secrets['aws_access_key_id']
      aws.secret_access_key = secrets['aws_secret_access_key']
      aws.keypair_name = secrets['keypair_name']
      aws.region = aws_conf['region']
      aws.elastic_ip = aws_conf['elastic_ip']
      aws.ami = aws_conf['ami']
      aws.block_device_mapping = [
        { 
          'DeviceName' => '/dev/xvda', 
          'Ebs.VolumeSize' => aws_conf['root_volume_size'] 
        },
        { 
          'DeviceName' => '/dev/xvdb', 
          'Ebs.VolumeSize' => aws_conf['db_volume_size'] 
        }
      ]
      aws.instance_type = aws_conf['instance_type']
      aws.tags = {
        'Name' => 'NewsLynx'
      }
      override.ssh.username = aws_conf['ssh_username']
      override.ssh.private_key_path = secrets['ssh_private_key_path']
    end

    # provisioning
    machine.vm.provision "main", type: "ansible" do |ansible|
      ansible.extra_vars = { ansible_ssh_user: "vagrant", hostname: "newslynx"}
      ansible.playbook = "provisioning/main.yaml"
      ansible.verbose = "vvvv"
      ansible.extra_vars = {
        pg_mnt_path: "/dev/xvdb",
        conf: conf,
        secrets: secrets
      }
    end

    # update
    machine.vm.provision "update", type: "ansible" do |ansible|
      ansible.extra_vars = { ansible_ssh_user: "vagrant", hostname: "newslynx"}
      ansible.playbook = "provisioning/update.yaml"
      ansible.verbose = "vvvv"
      ansible.extra_vars = {
        pg_mnt_path: "/dev/xvdb",
        conf: conf,
        secrets: secrets
      }
    end

    # restart
    machine.vm.provision "restart", type: "ansible" do |ansible|
      ansible.extra_vars = { ansible_ssh_user: "vagrant", hostname: "newslynx"}
      ansible.playbook = "provisioning/restart.yaml"
      ansible.verbose = "vvvv"
      ansible.extra_vars = {
        pg_mnt_path: "/dev/xvdb",
        conf: conf,
        secrets: secrets

      }
    end

    # stop
    machine.vm.provision "stop", type: "ansible" do |ansible|
      ansible.extra_vars = { ansible_ssh_user: "vagrant", hostname: "newslynx"}
      ansible.playbook = "provisioning/stop.yaml"
      ansible.verbose = "vvvv"
      ansible.extra_vars = {
        pg_mnt_path: "/dev/xvdb",
        conf: conf,
        secrets: secrets

      }
    end

    # start
    machine.vm.provision "start", type: "ansible" do |ansible|
      ansible.extra_vars = { ansible_ssh_user: "vagrant", hostname: "newslynx"}
      ansible.playbook = "provisioning/start.yaml"
      ansible.verbose = "vvvv"
      ansible.extra_vars = {
        pg_mnt_path: "/dev/xvdb",
        conf: conf,
        secrets: secrets

      }
    end
  end
end