wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | yum-key add - 
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' 
sudo apt-get update 
sudo apt-get install jenkins