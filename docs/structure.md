
#Project structure

- masters/
      pull_masters.sh

- project/
      fig based settings applied to containers for this project
      - basis/
        auth layers (CAS, nginx)
      - core/
        heart of hotrod (always included)
             - saltmaster for host minions (networking)
             - jenkins
             - LDAP (auth)
             - gitblit

- local/
      fig/salt based local builds, pick the role of your HotRod install
      - logger/
      
      
- runtime/
      runtime settings (to be pulled from Git)

- docs/

- hostops/
      tools necessarry to bootstrap the system, and install the base
      



