newslynx-automation
===================

An Ansible Playbook + Vagrantfile for automating a `newslynx-core` and `newslynx-app` install.

## Getting Started

You'll need to first install [`virtualbox`](https://www.virtualbox.org/wiki/Downloads), [`vagrant`](https://www.vagrantup.com/), and [`ansible`](http://docs.ansible.com/). Next, you should rename [`config.yaml.sample`](config.yaml.sample) to `config.yaml` and fill it out according to your preferences.  For more information on how this file is structured, refer to the [configuration docs](http://newslynx.readthedocs.org/en/latest/config.html).

Once this is done, you should be able to provision a VM of `newslynx` with the following command:

```
vagrant up
``` 

This will execute the ansible-playbook located in [`provisioning/main.yaml`](provisioning/main.yaml). This will take about 20-30 minutes to download all the dependencies and configure the machine.  Once it is finished you should be able to access the Newslynx API on your local machine on port `5001`:

```
curl http://localhost:5001/api/v1/me\?apikey=<your-apikey>
```

The app will be running at [http://localhost:3001](http://localhost:3001).  You'll be able to login with the `super_user_email` and `super_user_password` that you set in in `config.yaml`.

For more information on what to do next, please refer to our [getting started docs](http://newslynx.readthedocs.org/en/latest/getting-started.html).

## Debugging 

If something goes wrong with the deployment (which you should see in the logs), you can log into the VM using the following command:

```
vagrant ssh
```

All of the applications are installed as root, so you'll need to first:

```
sudo su
```

And then:

```
cd /opt/newslynx/
```

To check the logs of running processes, type:

```
tail -n 100 logs/app.log
```

If you should like to re-run the ansible playbook without fully destroying the Virtual Machine, run:

```
vagrant provision
```

If you have any problems with this process, please report an issue to our [opportunity tracker](https://github.com/newslynx/opportunities/issues).


## How does this work ?

`ansible` is a very fancy framework for running shell commands.  Each of the files located in [`provisioning/`](provisioning/), with the exclusion of `main.yaml`, represents an ansible "role" or a particular dependency that `newslynx` requires. These roles are fulfilled by running each of the commands listed in their respective files. Some "roles" - like [`newslynx-app`](provisioning/newslynx-app.yaml) and [`newslynx-core`](provisioning/newslynx-core.yaml) - rely on on other "roles".  These are "included" at the top of each respective file.  Most roles also require certain configuration variables which are set in [`provisioning/vars/`](provisioning/vars/).  Some of these roles also require their own configuration files.  To generate these, we create "templates" which we populate with the configuration variables.  These files are stored in [`provisioning/templates/`](provisioning/templates).

When you run `vagrant up`, the following steps are executed:

1. A virtual machine is provisioned. The specs of this machine are included in [`servers.json`](servers.json).
2. The ansible ["playbook"](provisioning/main.yaml), or list of all of newslynx's required roles, is executed on the Virtual Machine.
3. If all goes well, `newslynx-core` and `newslynx-app` will start up within the Virtual Machine on Ports 5000 and 3000, respectively. These will be forwarded to your local machine on ports 3001 and 5001. 

## Colophon

- Ubuntu 14.0.4 (The operating system.)
- Python 2.7.6 (The langauge `newslynx-core` is written in.)
- Node 0.12 (The language `newslynx-app` is writtern in.)
- Postgres 9.3 (`newslynx-core`'s primary datastore.)
- Redis 2.8.4 (`newslynx-core`'s caching layer and task queue.)
- Supervisor (`newslynx-core`'s dameon manager.)
- Forever (`newslynx-app`s daemon manager.)
- Nginx (The proxy server that sits in front of `newslynx-app` and the rest of the world.)

