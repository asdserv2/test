# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.box_check_update = false
  
  config.vm.define "systemd" do|systemd|
      systemd.vm.hostname = "systemd"
      systemd.vm.network "private_network", ip: "192.168.56.101", virtualbox__intnet: "testnet"
      systemd.vm.provider "virtualbox" do |vb|
          vb.gui = false
          vb.memory = "1024"
      end
      systemd.vm.provision "shell", inline: <<-SHELL
         touch /etc/sysconfig/watchdog
         echo 'WORD="ALERT"' >> /etc/sysconfig/watchdog
         echo 'LOG=/var/log/watchlog.log' >> /etc/sysconfig/watchdog
         touch /var/log/watchlog.log
         echo "Some text afjdhfskjhdf sdfsjhdf sdfjkshdf" >> /var/log/watchlog.log
         echo "dfsdfjo dfs dfjsdf sdf sdf sdf ALERT" >> /var/log/watchlog.log
         echo "sdf sdfsdfsd ALERT sdfsdfnsdj sdf sdf" >> /var/log/watchlog.log

         touch /opt/watchlog.sh
         chmod +x /opt/watchlog.sh
         echo '#!/bin/bash' > /opt/watchlog.sh; echo 'DATE=`date`' >> /opt/watchlog.sh
         echo 'WORD=$1' >> /opt/watchlog.sh
         echo 'LOG=$2' >> /opt/watchlog.sh
         echo 'if grep $WORD $LOG &> /dev/null' >> /opt/watchlog.sh
         echo 'then' >> /opt/watchlog.sh
         echo ' logger "$DATE: I found word, Master!"' >> /opt/watchlog.sh
         cat <<-EOF >> /opt/watchlog.sh
else
 exit 0
fi
EOF
         cat /opt/watchlog.sh

         touch /etc/systemd/system/watchlog.service
         cat <<-EOF > /etc/systemd/system/watchlog.service
[Unit]
Description=My watchlog service
[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchdog
EOF
         echo 'ExecStart=/opt/watchlog.sh $WORD $LOG' >> /etc/systemd/system/watchlog.service 
         cat /etc/systemd/system/watchlog.service
         touch /etc/systemd/system/watchlog.timer
         cat <<-EOF > /etc/systemd/system/watchlog.timer
[Unit]
Description=Run wtachlog 30 sec every

[Timer]
OnUnitActiveSec=30
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
EOF
         cat /etc/systemd/system/watchlog.timer
         systemctl daemon-reload
         systemctl start watchlog.timer
         systemctl start watchlog.service
      SHELL
  end

end
