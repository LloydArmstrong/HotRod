ldapauth:
  build:
    - file: salt://ldap/Dockerfile
    - file: salt://ldap/db.ldif
  image: panoptix/ldap:core
  ip:
   - 10.1.1.1
    
gitblit:
  build:
    - file: salt://git/Dockerfile
    - file: salt://git/gitblit.properties
    - file: salt://git/jenkins.groovy    
  image: panoptix/gitblit:core
  ports:
    - 127.0.0.1:8443:443
  links:
    - ldapauth:ldapauth
    - jenkins:jenkins  
  ip:
   - 10.1.1.5
   - 172.16.0.200
       
saltmaster:
  build:
    - file: salt://coresaltmaster/Dockerfile
    - file: salt://coresaltmaster/hotrod-master.conf
    - file: salt://coresaltmaster/remote_pillar.conf
    - file: salt://coresaltmaster/remote_states.conf
    - dir: salt://local    
  image: panoptix/saltmaster:core
  links:
    - gitblit:gitblit      
  ip:
   - 10.1.1.6
   - 172.16.0.254
     
jenkins:
  image: panoptix/jenkins
  links:
    - gitblit:gitblit
    - saltmaster:saltmaster
  ip:
    - 10.1.1.7
     
     