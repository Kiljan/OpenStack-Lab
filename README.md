# OpenStack Kolla Deployment Lab

This lab is based on an Udemy course I completed on OpenStack. In this lab, I have used a different version of the software, which required extensive rewriting of the initial configuration.

## Key Configuration Changes:
1. **Kolla Deployment for OpenStack Victoria Version**:
   - Update the file: `/usr/local/share/kolla-ansible/ansible/roles/common/templates/conf/filter/01-rewrite-0.12.conf.j2` to ensure the correct format.
   - Modify: `/usr/local/share/kolla-ansible/ansible/roles/common/tasks/config.yml` to correctly format `fluentd_binary`.

2. **Running Vagrant**:
   - Initiate the Vagrant file to set up the base environment.
   - The Vagrant file also executes most of the base scripts from the repository.

## Deployment Instructions:
1. **Prepare the Environment**:
   - Due to numerous bugs and errors, the process is not fully automated.
   - After Vagrant prepares the base environment, log in to the deployment server.
   - Navigate to `/home/vagrant/kolla` (created by Vagrant) and run `run-kolla.sh`.

2. **Handling Errors**:
   - The script `run-kolla.sh` contains comments about common bugs. Please read them carefully.
   - If the script fails, run each command individually to identify and resolve issues.

## Conclusion:
Open-source projects evolve continuously. Using outdated versions without support and reasonable documentation can be challenging. Always ensure to update both, your machines and solutions, regularly.

