# Getting Started

- Install docker-machine (see [https://docs.docker.com/machine/](https://docs.docker.com/machine/#installation))
  
- Install docker-compose (see [https://docs.docker.com/compose/](https://docs.docker.com/compose/#installation-and-set-up))

- Create a docker-machine based server

  ```
  ./bin/vbox_machine.sh create myhotrodserver Hotrod
  ```
  
  This will create a server with the default project named `Hotrod`. The project should be unique for each Hotrod instance.
  
- run `./hotrod init` and follow the prompts

# Do something custom

There is a special folder called `local`. Add you docker-compose files there to your hearts content. Look at the dc-elk.yml.orig.tpl file for examples. The labels, etc should be used too.


