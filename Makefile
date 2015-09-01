
# COMMON #

update:
	# update newslynx-core and newslynx-app
	vagrant provision --provision-with update

logs:
	# tail the logs of a process.
	vagrant ssh -c 'sudo tail -f /opt/newslynx/logs/$(l).log'

destroy:
	# destroy the current box
	vagrant destroy


# VIRTUALBOX # 

init_vb:
	vagrant --version
	vagrant up --provider=virtualbox --no-provision
	vagrant provision --provision-with main


# AWS #

init_aws:
	vagrant --version
	vagrant up --provider=aws --no-provision
	vagrant provision --provision-with main
