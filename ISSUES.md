- When set the custom "jenkins_home" via volume without existed, maybe will have the following errors:
```
touch: cannot touch '/var/jenkins_home/copy_reference_file.log': Permission denied
Can not write to /var/jenkins_home/copy_reference_file.log. Wrong volume permissions? 
```
Resolution: 
```
drwxr-xr-x  4 root root 4.0K Feb 12 14:58 jenkins_home
```
Change the rights for folder, need change the owner via "sudo chown -R xxx:xxx jenkins_home"
Then, docker rm the old container, and start new one.

--------

- When do git update, if have the following errors:
```
Please make sure you have the correct access rights and the repository exists.
```
Resolution:
```
Because missing the "known_hosts" for ~/.ssh. 
```
and need the 4 files:
- config
- id_rsa / id_dsa (with right, 600)
- id_rsa.pub / id_dsa.pub
- known_hosts

If Github, the 'config' file better like this:
```
    Host github.com
    Hostname ssh.github.com
    Port 443
    identityfile ~/.ssh/id_rsa
```
