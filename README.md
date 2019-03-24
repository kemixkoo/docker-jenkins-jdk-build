# Jenkins with JDK, Git, SVN, Maven, Ant, Gradle Image

Based on [jenkins/jenkins](https://hub.docker.com/r/jenkins/jenkins/)

# Basic Usage
```
docker run -d -p 8180:8080 -p 51000:50000 \
    kemixkoo/jenkins-jdk-build
```
Then, can access Jenkins via http://localhost:8180

Find the admin password via:
```
docker logs <running-container-id>
```

------

# Custom Jenkins Home
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /path/to/jenkins/home:/var/jenkins_home \
    kemixkoo/jenkins-jdk-build
```

when do `docker logs`, found the errors:

```
touch: cannot touch '/var/jenkins_home/copy_reference_file.log': Permission denied
Can not write to /var/jenkins_home/copy_reference_file.log. Wrong volume permissions?

```
means, no rights for volume path `/path/to/jenkins/home`, you need use `chmod` or `chown` to set the rights for user `jenkins`.


------

# Support Docker-in-Docker (DinD)
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(which docker):/usr/bin/docker \
    kemixkoo/jenkins-jdk-build
```

See another documentation [Jenkins Docker-in-Docker](http://container-solutions.com/running-docker-in-jenkins-in-docker/)


## Hello world Demo for DinD

- Create new jobs named (e.g. “docker-hello-world”) with “Freestyle project”.
- On the configuration page, do “Add build step” for “Execute shell”.
- In the command box, type “sudo docker run --rm hello-world”.
- Save job and do “Build Now”.
- Check the result in "Console Output" to ok or not.

------

# Share Date Time and Zone
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    kemixkoo/jenkins-jdk-build
```

# Custom Time Zone for Jenkins
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -e JAVA_OPTS="-Duser.timezone=Asia/Shanghai" \
    -e TZ="Asia/Shanghai" \
    kemixkoo/jenkins-jdk-build
```

------

# Share my ssh for Git
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /path/to/my/ssh:/var/jenkins_home/.ssh \
    kemixkoo/jenkins-jdk-build
```
Use same ssh key for git to update.

------

# Custom JDK version
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /path/to/jdk:/opt/jdk \
    kemixkoo/jenkins-jdk-build
```

------

# Custom Maven version
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /path/to/maven:/opt/maven \
    kemixkoo/jenkins-jdk-build
```

## Share my M2 for Maven
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /path/to/my/m2:/var/jenkins_home/.m2 \
    kemixkoo/jenkins-jdk-build
```

------

# Custom Ant version
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /path/to/ant:/opt/ant \
    kemixkoo/jenkins-jdk-build
```

------

# Custom Gradle version
```
docker run -d -p 8180:8080 -p 51000:50000 \
    -v /path/to/gradle:/opt/gradle \
    kemixkoo/jenkins-jdk-build
```

------


# Building
```
docker build -t kemixkoo/jenkins-jdk-build .
```
