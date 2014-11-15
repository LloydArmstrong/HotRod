ldapauth:
  build:
    - file: salt://local/ldap/Dockerfile
    - file: salt://local/ldap/db.ldif
  image: panoptix/ldap:core
  ip:
   - 10.1.1.1
    
gitblit:
  build:
    - file: salt://local/git/Dockerfile
    - file: salt://local/git/gitblit.properties
    - file: salt://local/git/jenkins.groovy    
  image: panoptix/gitblit:core
  ports:
    - 127.0.0.1:8443:443
  links:
    - ldapauth:ldapauth    
  ip:
   - 10.1.1.5
   - 172.16.0.200
       
saltmaster:
  build:
    - file: salt://local/coresaltmaster/Dockerfile
    - file: salt://local/coresaltmaster/hotrod-master.conf
    - file: salt://local/coresaltmaster/remote_pillar.conf
    - file: salt://local/coresaltmaster/remote_states.conf
    - dir: salt://local    
  image: panoptix/saltmaster:core
  links:
    - gitblit:gitblit      
  ip:
   - 10.1.1.6
   - 172.16.0.254
     