# NOTE: The following comands have a hardcoded path of `/opt/newslynx/` for the `home` variable found in `provisioning/vars/common.yaml`

# COMMON #

update:
	# update newslynx-core and newslynx-app
	VAGRANT_LOG=info vagrant provision --provision-with update

logs:
	# tail the logs of a process.
	vagrant ssh -c 'sudo tail -f /opt/newslynx/logs/$(l).log'

destroy:
	# destroy the current box
	VAGRANT_LOG=info vagrant destroy

reprovision:
	# reprovision the box
	VAGRANT_LOG=info vagrant provision --provision-with main

restart: 
	# reprovision the box
	VAGRANT_LOG=info vagrant provision --provision-with restart

stop: 
	# reprovision the box
	VAGRANT_LOG=info vagrant provision --provision-with stop

start: 
	# reprovision the box
	VAGRANT_LOG=info vagrant provision --provision-with start

# restore: 
# 	vagrant ssh -c 'sudo -u root bash /opt/newslynx/scripts/db-restore.sh $(date)'

# VIRTUALBOX # 

init_vb:
	vagrant --version
	vagrant up --provider=virtualbox --no-provision
	VAGRANT_LOG=info vagrant provision --provision-with main


# AWS #

init_aws:
	vagrant --version
	vagrant up --provider=aws --no-provision
	VAGRANT_LOG=info vagrant provision --provision-with main
