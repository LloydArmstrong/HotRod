ldapauth:
  build:
    - file: salt://ldap/Dockerfile
    - file: salt://ldap/db.ldif
  image: panoptix/ldap:core
  ip:
   - 10.1.1.1
  ports:
    - 127.0.0.1:389:389
       
git:
  build:
    - dir: salt://git
  image: panoptix/gitolite:core
  ports:
    - 127.0.0.1:8080:80
    - 127.0.0.1:8022:22
  ip:
   - 10.1.1.5
       
saltmaster:
  build:
    - file: salt://coresaltmaster/Dockerfile
    - file: salt://coresaltmaster/hotrod-master.conf
    - file: salt://coresaltmaster/remote_pillar.conf
    - file: salt://coresaltmaster/remote_states.conf
    - dir: salt://local    
  image: panoptix/saltmaster:core
  ports:
    - 127.0.0.1:4505:4505
    - 127.0.0.1:4506:4506 
  links:
    - 10.1.1.5:git      
  ip:
   - 10.1.1.6
