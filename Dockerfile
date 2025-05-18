FROM jenkins/jenkins

# Switch to root to install packages
USER root

# Update and install required packages
RUN apt-get update && apt-get install -y vim python3-pip python3-venv iputils-ping

# Add Docker's official GPG key:
    RUN apt-get update && apt-get install ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc
 
# Add the repository to Apt sources:
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
 
RUN apt-get update && apt-get install docker-ce docker-compose-plugin -y

# Create ansible directory with proper permissions
RUN mkdir -p /var/jenkins_home/ansible && \
    chown jenkins:jenkins /var/jenkins_home/ansible

# Create play.yml directly in the image
RUN echo '---\n- hosts: test1\n  tasks:\n    - name: Echo a message\n      shell: echo Hello world! > /tmp/ansible-file' > /var/jenkins_home/ansible/play.yml && \
    chown jenkins:jenkins /var/jenkins_home/ansible/play.yml

# Copy SSH key
COPY --chown=jenkins:jenkins remote-key /var/jenkins_home/ansible/remote-key
RUN chmod 400 /var/jenkins_home/ansible/remote-key

# Set up Ansible environment
ENV ANSIBLE_VENV=/ansible_venv
RUN mkdir -p $ANSIBLE_VENV && \
    chown jenkins:jenkins $ANSIBLE_VENV

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch back to jenkins user
USER jenkins

# Create and activate virtual environment, then install ansible
RUN python3 -m venv $ANSIBLE_VENV && \
    $ANSIBLE_VENV/bin/pip3 install ansible

# Ensure the Ansible binary is accessible
ENV PATH=$PATH:$ANSIBLE_VENV/bin

# Switch back to root to set the entrypoint
USER root
ENTRYPOINT ["/entrypoint.sh"]
