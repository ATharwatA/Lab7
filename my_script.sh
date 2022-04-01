#!/bin/bash
sudo yum update
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
sudo cp /home/ec2-user/index.php /var/www/html
