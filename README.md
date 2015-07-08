## HotRod

HotRod is an opinionated 'Platform' for analytics. It contains the building blocks and automation to enable running logging as a PaaS. 

It is under heavy development, please contact support@panoptix.co.za for assistance.

### Getting Started

- Install docker-machine (see [https://docs.docker.com/machine/](https://docs.docker.com/machine/#installation))
  
- Install docker-compose (see [https://docs.docker.com/compose/](https://docs.docker.com/compose/#installation-and-set-up))

- Create a docker-machine based server

  ```
  ./bin/vbox_machine.sh create myhotrodserver Hotrod
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
