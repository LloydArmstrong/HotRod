## HotRod

HotRod is an opinionated 'Platform' for analytics. It contains the building blocks and automation to enable running logging as a PaaS. 

It is under heavy development and should be handled with care.

### Bugs/Roadmap

HERE BE DRAGONS, HotRod is not ready for production use unless you know what you're doing, considered pre-Alpha. There are known security issues (static passwords, static SSL keys, badness), which can, will and should be fixed.
   
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

