## HotRod

HotRod is an opinionated 'Platform' for analytics. It contains the building blocks and automation to enable running logging as a PaaS. 

It is under heavy development and should be handled with care.

### Bugs/Roadmap

HERE BE DRAGONS, HotRod is not ready for production use unless you know what you're doing, considered pre-Alpha. There are known security issues (static passwords, static SSL keys, badness), which can, will and should be fixed.


### Getting Started

- Install saltstack (version 2014.7.x, you need salt-ssh)
- Customise the docs/default.yml file and place it in the project root folder.
- run ./mini.py
- Ensure salt has ssh access set up (involves setting up salt/roster file)
- run ./init.sh
- run ./bin/bootstrap.sh
- run ./bin/cloud_highstate.sh
 
### What is HotRod?

HotRod is an easy way to get an analytics platform (Elasticsearch, Kibana, Logstash) running in a modern fashion. It works with Docker and Weave.

### Architecture Components

- Saltstack
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
