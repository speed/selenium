# Selenium Chrome


#### Ubuntu
```
# Ubuntu-16.04-x86_64
# Selenium Server 3.0.1
# Google Chrome 55.0.2883.87
# Chrome Driver 2.25
# Open JDK 1.8.0
```

```
wget --no-check-certificate --no-verbose https://raw.githubusercontent.com/speed/selenium/master/Ubuntu.sh \
  && sh Ubuntu.sh
```

#### Centos

```
# Centos-7-x86_64-minimal
# Selenium Server 3.0.1
# Google Chrome 55.0.2883.87
# Chrome Driver 2.25
# Open JDK 1.8.0
```

```
wget --no-check-certificate --no-verbose https://raw.githubusercontent.com/speed/selenium/master/Centos.sh \
  && sh Centos.sh
```


#### Docker chrome
https://github.com/SeleniumHQ/docker-selenium

Chrome plugin
mkdir -p /opt/selenium  \
 && wget --no-verbose -O /opt/selenium/ModHeader.crx https://raw.githubusercontent.com/speed/newcrawler-plugin-urlfetch-chrome/master/crx/ModHeader.crx\
    && chmod 755 /opt/selenium/ModHeader.crx

Chrome
``` bash
$ docker run -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome:3.11.0-antimony
#OR
$ docker run -d -p 4444:4444 --shm-size=2g selenium/standalone-chrome:3.11.0-antimony
```
Firefox
``` bash
$ docker run -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-firefox:3.11.0-antimony
#OR
$ docker run -d -p 4444:4444 --shm-size 2g selenium/standalone-firefox:3.11.0-antimony
```
