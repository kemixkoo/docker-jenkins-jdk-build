FROM jenkins/jenkins

MAINTAINER Kemix Koo (kemix_koo@163.com)

# this is a non-interactive automated build - avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive
#set for nano
ENV TERM xterm

#set time zone
#ENV TZ "Asia/Shanghai"
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG cur_user="jenkins"

#----------------------------------------------------------
USER root

RUN apt-get update \
          && apt-get install -y sudo nano wget curl unzip \
                ca-certificates openssl openssh-server \
                git subversion

# add jenkins user to sudo
RUN echo "${cur_user} ALL=NOPASSWD: ALL" >> /etc/sudoers

ARG usr_bin="/usr/local/bin"

#-------------------------Install JDK---------------------------------
# http://www.oracle.com/technetwork/java/javase/downloads/index.html
ENV JAVA_VERSION 1.8.0_162
ENV JAVA_HOME /opt/jdk

# download JDK8
ARG jdk_filename="jdk-8u162-linux-x64.tar.gz"
ARG jdk_filemd5="781e3779f0c134fb548bde8b8e715e90"
ARG jdk_url="http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/${jdk_filename}"
ARG jdk_tmp="/tmp/${jdk_filename}"

# download java, accepting the license agreement
RUN set -o errexit -o nounset \
        && wget -nv --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O ${jdk_tmp} ${jdk_url} \
        && echo "${jdk_filemd5} ${jdk_tmp}" | md5sum -c \
        && tar -zxf ${jdk_tmp}  -C /opt/ \
        && ln -s /opt/jdk${JAVA_VERSION} ${JAVA_HOME}
        
ENV PATH $JAVA_HOME/bin:$PATH
ENV CLASSPATH .:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar

# configure symbolic links for the java and javac executables
RUN update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 20000 \
        && update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 20000

#-------------------------Install Maven---------------------------------
# http://maven.apache.org/download.cgi
ENV MAVEN_VERSION 3.5.2
ENV MAVEN_HOME /opt/maven

# download maven
ARG maven_filename="apache-maven-${MAVEN_VERSION}-bin.tar.gz"
ARG maven_filemd5="948110de4aab290033c23bf4894f7d9a"
ARG maven_url="http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${maven_filename}"
ARG maven_tmp="/tmp/${maven_filename}"

RUN set -o errexit -o nounset \
        && wget -nv -O ${maven_tmp}  ${maven_url} \
        && echo "${maven_filemd5} ${maven_tmp}" | md5sum -c \
        && tar xzf ${maven_tmp}  -C /opt/ \
        && ln -s /opt/apache-maven-${MAVEN_VERSION} ${MAVEN_HOME} \
        && ln -s ${MAVEN_HOME}/bin/mvn ${usr_bin}

ENV PATH ${MAVEN_HOME}/bin:$PATH

#-------------------------Install Ant---------------------------------
# http://ant.apache.org/bindownload.cgi
ENV ANT_VERSION 1.10.2
ENV ANT_HOME /opt/ant

# download ant
ARG ant_filename="apache-ant-${ANT_VERSION}-bin.tar.gz"
ARG ant_filemd5="51b89be8b73812230d2ee12ea58442fd"
ARG ant_url="http://mirrors.shu.edu.cn/apache/ant/binaries/${ant_filename}"
ARG ant_tmp="/tmp/${ant_filename}"

RUN set -o errexit -o nounset \
        && wget -nv -O ${ant_tmp}  ${ant_url} \
        && echo "${ant_filemd5} ${ant_tmp}" | md5sum -c \
        && tar xzf ${ant_tmp}  -C /opt/ \
        && ln -s /opt/apache-ant-${ANT_VERSION} ${ANT_HOME} \
        && ln -s ${ANT_HOME}/bin/ant ${usr_bin}
        
ENV PATH ${ANT_HOME}/bin:$PATH

#-------------------------Install Gradle---------------------------------
# https://gradle.org/releases/
ENV GRADLE_VERSION 4.5.1
ENV GRADLE_HOME /opt/gradle

# download gradle
ARG gradle_filename="gradle-${GRADLE_VERSION}-bin.zip"
ARG gradle_filesha256="3e2ea0d8b96605b7c528768f646e0975bd9822f06df1f04a64fd279b1a17805e"
ARG gradle_url="https://services.gradle.org/distributions/${gradle_filename}"
ARG gradle_tmp="/tmp/${gradle_filename}"

RUN set -o errexit -o nounset \
        && wget -nv -O ${gradle_tmp}  ${gradle_url} \
        && echo "${gradle_filesha256} ${gradle_tmp}" | sha256sum -c \
        && unzip -q ${gradle_tmp} -d  /opt/ \
        && ln -s /opt/gradle-${GRADLE_VERSION} ${GRADLE_HOME} \
        && ln -s ${GRADLE_HOME}/bin/gradle ${usr_bin}
        
ENV PATH ${GRADLE_HOME}/bin:$PATH

#-------------------------Clean---------------------------------
RUN  apt-get clean \
          && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*

#----------------------------------------------------------
# add my files
ARG my_files="/my-files"
ADD .gitconfig ${my_files}
RUN chmod 755 -R ${my_files} \
        && chown ${cur_user}:${cur_user} -R ${my_files}


# add my shell for git
ADD gitx.sh ${usr_bin}
RUN mv ${usr_bin}/gitx.sh ${usr_bin}/gitx \
        && chmod +x ${usr_bin}/gitx


USER ${cur_user}

#----------------------Install Jenkins plugins------------------------------------
#ARG JENKINS_PATH=/usr/share/jenkins
#COPY plugins.txt $JENKINS_PATH/plugins.txt
#RUN ${usr_bin}/install-plugins.sh $(cat $JENKINS_PATH/plugins.txt | tr '\n' ' ')

