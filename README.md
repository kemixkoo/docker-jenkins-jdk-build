# Jenkins with JDK, Git, SVN, Maven Image

Based on [jenkins/jenkins](https://hub.docker.com/r/jenkins/jenkins/)

# Basic Usage
```
docker run -d -p 8180:8080 -p 51000:50000 \
    kemixkoo/jenkins-jdk
```
Then, can access Jenkins via http://localhost:8180

Find the admin password via:
```
docker logs <running-container-id>
```

# Custom Maven Home for special version
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /path/to/maven:/opt/maven \
    kemixkoo/jenkins-jdk
```

# Custom JDK Home for special version
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /path/to/jdk:/opt/jdk \
    kemixkoo/jenkins-jdk
```

# Custom Jenkins Home
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /path/to/jenkins_home:/var/jenkins_home \
    kemixkoo/jenkins-jdk
```

# Support Docker-in-Docker (DinD)
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(which docker):/usr/bin/docker \
    kemixkoo/jenkins-jdk
```

See another documentation [Jenkins Docker-in-Docker](http://container-solutions.com/running-docker-in-jenkins-in-docker/)


## Hello world Demo for DinD

- Create new jobs named (e.g. “docker-hello-world”) with “Freestyle project”.
- On the configuration page, do “Add build step” for “Execute shell”.
- In the command box, type “sudo docker run --rm hello-world”.
- Save job and do “Build Now”.
- Check the result in "Console Output" to ok or not.

# Custom Time Zone for Container with Jenkins
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /etc/localtime:/etc/localtime:ro \
    -e JAVA_OPTS="-Duser.timezone=Asia/Shanghai" \
    -e TZ="Asia/Shanghai" \
    kemixkoo/jenkins-jdk
```

# Support ssh for Git
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /path/to/my/ssh:/var/jenkins_home/.ssh \
    kemixkoo/jenkins-jdk
```
Use same ssh key for git to update.


# Building
```
docker build -t kemixkoo/jenkins-jdk .
```
