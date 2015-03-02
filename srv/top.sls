base:
  '*':
     - system     
     - docker.packages
     - docker.pythonlibs
     - hotrod     
     - weave
     - weave.peers     
     - salt.minions

  'hotrodmaster-*':
     - weave.master
