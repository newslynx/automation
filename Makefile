
# VIRTUALBOX # 

vb_init:

	make -s vb_stop
	vagrant up --provider=virtualbox

vb_stop:

	-vagrant destroy --force > /dev/null

vb_update:

	echo '' > /dev/null

vb_tail:
	# tail the logs of a process.
	vagrant ssh -c 'sudo tail -f /opt/newslynx/logs/$(p).log'


# AWS #

aws_init:

	-vagrant up --provider=aws

aws_stop:

	-vagrant destroy --provider=aws --force > /dev/null

aws_update:

	echo '' > /dev/null