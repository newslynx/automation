
tail:
	# tail the logs of a process.
	vagrant ssh -c 'sudo tail -f /opt/newslynx/logs/$(p).log'

dev:

	ansible-playbook --tags dev \
	    -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory \
	    --private-key="~/.vagrant.d/insecure_private_key" \
	    -e "ansible_ssh_user=vagrant hostname=newslynx" provisioning/main.yaml
