 -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.box_check_update = false

  config.vm.define "nfsserver" do|nfsserver|
      nfsserver.vm.hostname = "nfsserver"
      nfsserver.vm.network "private_network", ip: "192.168.56.100", virtualbox__intnet: "testnet"
      nfsserver.vm.provider "virtualbox" do |vb|
          vb.gui = false
          vb.memory = "1024"
      end
      nfsserver.vm.provision "shell", inline: <<-SHELL
          yum install nfs-utils -y
          systemctl enable firewalld --now
          firewall-cmd --add-service="nfs3" --add-service="nfs" --add-service="rpc-bind" --add-service="mountd" --permanent
          firewall-cmd --reload
          systemctl enable nfs --now
          mkdir -p /srv/share/upload
          chown -R nfsnobody:nfsnobody /srv/share
          chmod 0777 /srv/share/upload
          echo "/srv/share 192.168.56.101/32(rw,sync,root_squash)" >> /etc/exports
          exportfs -r
          echo "Otus nfs-server-test file" >> /srv/share/upload/testfile
      SHELL
  end


  config.vm.define "nfsclient" do|nfsclient|
      nfsclient.vm.hostname = "nfsclient"
      nfsclient.vm.network "private_network", ip: "192.168.56.101", virtualbox__intnet: "testnet"
      nfsclient.vm.provider "virtualbox" do |vb|
          vb.gui = false
          vb.memory = "1024"
      end
      nfsclient.vm.provision "shell", inline: <<-SHELL
          yum install nfs-utils -y
          systemctl enable firewalld --now
          echo "192.168.56.100:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab
          systemctl daemon-reload
          systemctl restart remote-fs.target
          cat /mnt/upload/testfile
      SHELL
  end

end
