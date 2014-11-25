base:
  '*':
     - system     
     - docker.packages
     - docker.pythonlibs
     - weave
     - weave.peers     
     - salt.minions

  'hotrodmaster-*':
     - weave.master
     - cluster.build
     - cluster.run
     
