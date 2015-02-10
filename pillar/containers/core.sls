ldapauth:
  build:
    - file: salt://ldap/Dockerfile
    - file: salt://ldap/db.ldif
  image: panoptix/ldap:core
  ip:
   - 10.1.1.1
  ports:
    - 127.0.0.1:1389:389
       
gitblit:
  build:
    - file: salt://git/Dockerfile
    - file: salt://git/gitblit.properties
    - file: salt://git/jenkins.groovy    
  image: panoptix/gitblit:core
  ports:
    - 127.0.0.1:8443:443
    - 127.0.0.1:9418:9418
  links:
    - 10.1.1.1:ldapauth
    - 10.1.1.7:jenkins  
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
    - 10.1.1.5:gitblit      
  ip:
   - 10.1.1.6
#  expose:
#   - 10.1.254.1
     
jenkins:
  image: panoptix/jenkins
  links:
    - 10.1.1.5:gitblit
    - 10.1.1.6:saltmaster
  ip:
    - 10.1.1.7
     
     