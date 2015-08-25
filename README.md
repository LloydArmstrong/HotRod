## HotRod

[![Build status](https://badge.buildkite.com/752b577f704f463f76358ac3633c483d1e788aab00963d87e0.svg)](https://buildkite.com/panoptix/hotrod-oss)

HotRod is an opinionated 'Platform' for analytics. It contains the building blocks and automation to enable running logging as a PaaS.

It is under heavy development, please contact support@panoptix.co.za for assistance.

### Getting Started

- Install docker-machine (see [https://docs.docker.com/machine/](https://docs.docker.com/machine/#installation))

- Install docker-compose (see [https://docs.docker.com/compose/](https://docs.docker.com/compose/install/#install-compose))

- Install Panoptix Mini Templates

  ```
  git clone https://github.com/panoptix-za/mini-templates.git
  cp mini-templates/mini.py /usr/local/bin
  ```

- Install HotRod

  ```
  git clone https://github.com/panoptix-za/HotRod.git
  cd HotRod
  ```

- Create a docker-machine based server

  Replace `my_api_token` and `ams3` as appropriate below.

  ```
  export DIGITALOCEAN_ACCESS_TOKEN=my_api_token
  export DIGITALOCEAN_REGION=ams3
  ./bin/do_machine.sh create myhotrodserver Hotrod
  ```

  To view your machine run:

  ```
  docker-machine ls
  ```

  This will create a server with the default project named `Hotrod`. The project should be unique for each Hotrod instance.

- run `./hotrod init` and follow the prompts

### Do something custom

There is a special folder called `local`. Add you docker-compose files there to your hearts content. Look at the dc-elk.yml.orig.tpl file for examples. The labels, etc should be used too.

### Features

 - If you place 'once' in the name of the dc-*.yml file (Docker Compose) then it will only be executed once.

### Components

- Docker
- Weave
- Elasticsearch
- Rsyslog
- Kibana

### License

The MIT License (MIT)

Copyright (c) Panoptix CC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
