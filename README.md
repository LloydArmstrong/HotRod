## HotRod

HotRod is an opinionated 'Platform' for analytics. It contains the building blocks and automation to enable running logging as a PaaS. 

It is under heavy development and should be handled with care.

### Bugs/Roadmap

HERE BE DRAGONS, HotRod is not ready for production use unless you know what you're doing, considered pre-Alpha. There are known security issues (static passwords, static SSL keys, badness), which can, will and should be fixed.


Clone the sourcecode on a server running Docker:

    git clone https://github.com/panoptix-za/HotRod.git

If HotRod is set to run publicy there is some limited support to attempt an auto-bootstrap. Just issue:

    cd HotRod
    sudo ./hotrod.sh

If this fails set the environment variable HOTROD_URL to an appropriate value.

    export HOTROD_URL="https://192.168.0.1"
   
> Only https on port 443 is supported at this time.
 
### What is HotRod

- Opinionated Docker PaaS
- Idiomatic (docker, Consul, http)
  - consist of micro services (easy to iterate)
- CI/CD good to go
- Not a Heroku clone (never used it), its for infrastructure people
- Loosely coupled
- Go  (no dependencies, concurrent, same as Consul and Docker)    
- Turnkey (metrics, logging and orchestration out of the box)
- Modern (containers, web services, 
- DevOps pipeline OSS and in public

### HotRod/Toadie (Coming next)

    - /.../projects/... (Actual customer instances)
    - /.../teams/.../ (Functional groups - inherited by projects)
    - /.../.../formation/....
        - nodes per instance (shared log volumes, scaling characteristics, 
    - /.../.../containers/.../attributes (
 
### DevOps

- Use the 'shell' to spin up HotRod locally (fig up)

### Architecture

- External/Public Ports are published (preferably) using ambassadors, not binds to specific containers (SSL by default)

### Features

- Private registry for project images
- Rundeck access to ops functions (audited and secured)

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

