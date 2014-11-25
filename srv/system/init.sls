community_swap_file:
  cmd.run:
    - name: |
        [ -f /.swapfile ] || dd if=/dev/zero of=/.swapfile bs=1M count=2048
        chmod 0600 /.swapfile
        mkswap /.swapfile
        echo '/.swapfile      none      swap     sw       0       0' >> /etc/fstab
        swapon -a
    - unless: file /.swapfile 2>&1 | grep -q "Linux/i386 swap"
    
gen_ssh_keys:
  cmd.run:
    - name: |
        ssh-keygen -t dsa -f ~/.ssh/id_rsa -N ""
    - unless: ls ~/.ssh/id_rsa
        
show_ssh_keys:
  cmd.run:
    - name: |
        echo ""
        echo "public key:"
        cat ~/.ssh/id_rsa.pub   
    - onlyif: ls ~/.ssh/id_rsa.pub
        
add_host_gitblit:
  cmd.run:
    - name: |
        echo "10.1.254.200 gitblit" >> /etc/hosts
    - unless: cat /etc/hosts | grep 10.1.254.200