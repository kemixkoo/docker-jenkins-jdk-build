FROM jenkins/jenkins

MAINTAINER Kemix Koo (kemix_koo@163.com)

# this is a non-interactive automated build - avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

#----------------------------------------------------------
USER root
RUN apt-get update \
          && apt-get install -y wget curl openssh-server nano sudo git subversion

# add jenkins user to sudo
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers


#-------------------------Install JDK---------------------------------
ENV java_version 1.8.0_162
ENV JAVA_HOME /opt/jdk

# download JDK8
ARG jdk_filename="jdk-8u162-linux-x64.tar.gz"
ARG jdk_filemd5="781e3779f0c134fb548bde8b8e715e90"
ARG jdk_url="http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/${jdk_filename}"
ARG jdk_tmp="/tmp/${jdk_filename}"

# download java, accepting the license agreement
RUN wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O ${jdk_tmp} ${jdk_url}
RUN echo "${jdk_filemd5} ${jdk_tmp}" | md5sum -c

RUN tar -zxf ${jdk_tmp}  -C /opt/ \
        && ln -s /opt/jdk${java_version} ${JAVA_HOME} \
        && rm ${jdk_tmp}
        
ENV PATH $JAVA_HOME/bin:$PATH
ENV CLASSPATH .:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar

# configure symbolic links for the java and javac executables
RUN update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 20000 \
        && update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 20000

#-------------------------Install Maven---------------------------------
ENV maven_version 3.5.2
ENV MAVEN_HOME /opt/maven

# download maven
ARG maven_filename="apache-maven-${maven_version}-bin.tar.gz"
ARG maven_filemd5="948110de4aab290033c23bf4894f7d9a"
ARG maven_url="http://archive.apache.org/dist/maven/maven-3/${maven_version}/binaries/${maven_filename}"
ARG maven_tmp="/tmp/${maven_filename}"

RUN wget --no-verbose -O ${maven_tmp}  ${maven_url}
RUN echo "${maven_filemd5} ${maven_tmp}" | md5sum -c

RUN tar xzf ${maven_tmp}  -C /opt/ \
        && ln -s /opt/apache-maven-${maven_version} ${MAVEN_HOME} \
        && ln -s ${MAVEN_HOME}/bin/mvn /usr/local/bin \
        && rm ${maven_tmp}

ENV PATH ${MAVEN_HOME}/bin:$PATH

#-------------------------Clean---------------------------------
RUN  apt-get clean \
          && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*

#----------------------------------------------------------
# add gitconfig
ADD .gitconfig /files/

USER jenkins

#----------------------Install Jenkins plugins------------------------------------
#ARG JENKINS_PATH=/usr/share/jenkins
#COPY plugins.txt $JENKINS_PATH/plugins.txt
#RUN /usr/local/bin/install-plugins.sh $(cat $JENKINS_PATH/plugins.txt | tr '\n' ' ')

