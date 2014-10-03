
#Project structure

- hacking/
      work on the dependent images, build your own local images.
      build.sh (The Docker build of all the images)
      git.sh (a wrapper to easily clone all the images)
      
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
      



