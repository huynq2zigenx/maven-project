#!/bin/bash
set -e

# Create ansible directory if it does not exist
mkdir -p /var/jenkins_home/ansible

# Create play.yml if it doesn't exist
if [ ! -f /var/jenkins_home/ansible/play.yml ]; then
    cat > /var/jenkins_home/ansible/play.yml << 'EOF'
---
- hosts: test1
  tasks:
    - name: Echo a message
      shell: echo Hello world! > /tmp/ansible-file
EOF
fi

# Make sure permissions are correct
chown -R jenkins:jenkins /var/jenkins_home/ansible

# Ensure SSH key has correct permissions if it exists
if [ -f /var/jenkins_home/ansible/remote-key ]; then
    chmod 400 /var/jenkins_home/ansible/remote-key
    chown jenkins:jenkins /var/jenkins_home/ansible/remote-key
fi

# Start Jenkins - find the actual location of tini and use it
if [ -f "/usr/local/bin/tini" ]; then
    exec /usr/local/bin/tini -- /usr/local/bin/jenkins.sh "$@"
elif [ -f "/sbin/tini" ]; then
    exec /sbin/tini -- /usr/local/bin/jenkins.sh "$@"
else
    # Fallback if tini is not found
    exec /usr/local/bin/jenkins.sh "$@"
fi
