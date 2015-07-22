newslynx-automation
===================

An ansible playbook + Vagrant image for automating a full install with `newslynx-core` and `newslynx-app`.

## Getting Started

You'll need to first install [`virtualbox`](https://www.virtualbox.org/wiki/Downloads), [`vagrant`](https://www.vagrantup.com/), and [`ansible`](http://docs.ansible.com/).

Rename `config.sample.yaml` to `config.yaml` and fill out the necessary information.

Next, you can provision a VM on newslynx by running:

```
vagrant up
``` 

This will execute the ansible playbook located in [`provisioning/main.yaml`](provisioning/main.yaml). This will take about 20-30 minutes to download all the dependencies and configure the machine.  Once it is finished you should be able to access the Newslynx API on your local machine on port 5001.  The app will be running at [http://localhost:3001](http://localhost:5001).  If something goes wrong with the deployment (which you should see in the logs), you can log into the VM using the following command:

```
vagrant ssh
```

All of the software is installed as root, so you'll need to first:

```
sudo su
```

And then:
```
cd /opt/newslynx/
````

To navigate to where the applications are located.  

The check the logs of running processes, type:
```
tail -n 100 logs/app.log
```
