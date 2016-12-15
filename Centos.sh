#================================================
# Centos-7-x86_64-minimal
#================================================


#========================
# Miscellaneous packages
# Includes minimal runtime used for executing non GUI Java programs
#========================

yum update -y \
  && yum -y install \
    bzip2 \
    ca-certificates \
    java-1.8.0-openjdk-headless \
    sudo \
    unzip \
    wget \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
  && sed -i 's/securerandom\.source=file:\/dev\/random/securerandom\.source=file:\/dev\/urandom/' /usr/lib/jvm/jre-1.8.0-openjdk/lib/security/java.security

#==========
# Selenium
#==========
mkdir -p /opt/selenium \
  && wget --no-verbose https://selenium-release.storage.googleapis.com/3.0/selenium-server-standalone-3.0.1.jar -O /opt/selenium/selenium-server-standalone.jar

#========================================
# Add normal user with passwordless sudo
#========================================
sudo useradd seluser --shell /bin/bash --create-home \
  && sudo usermod -a -G wheel seluser \
  && echo '%wheel ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'seluser:secret' | chpasswd
  
#==============
# VNC and Xvfb
#==============

yum update -y \
  && yum -y install \
    Xvfb libXfont Xorg \
  && yum -y groupinstall "X Window System" "Desktop" "Fonts" "General Purpose Desktop"\
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
  


#============================================
# Google Chrome
#============================================
# can specify versions by CHROME_VERSION;
#  e.g. google-chrome-stable=53.0.2785.101-1
#       google-chrome-beta=53.0.2785.92-1
#       google-chrome-unstable=54.0.2840.14-1
#       latest (equivalent to google-chrome-stable)
#       google-chrome-beta  (pull latest beta)
#============================================  

cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome - \$basearch
baseurl=http://dl.google.com/linux/chrome/rpm/stable/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

yum update -y \
  && yum -y install google-chrome-stable \
  && rm -rf /etc/yum.repos.d/google-chrome.repo \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
  
#==================
# Chrome webdriver
#==================
wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/2.25/chromedriver_linux64.zip \
  && rm -rf /opt/selenium/chromedriver \
  && unzip /tmp/chromedriver_linux64.zip -d /opt/selenium \
  && rm -rf /tmp/chromedriver_linux64.zip \
  && chmod 755 /opt/selenium/chromedriver \
  && ln -fs /opt/selenium/chromedriver /usr/bin/chromedriver

chmod +x /opt/google/chrome/google-chrome
chown -R seluser:seluser /opt/selenium

#====================================
# Run Selenium Standalone
#====================================
su - seluser -c "nohup xvfb-run -n 99 --server-args=\"-screen 0 1280x1024x24 -ac +extension RANDR\" java -jar /opt/selenium/selenium-server-standalone.jar  -role hub &"

su - seluser -c "nohup xvfb-run -n 98 --server-args=\"-screen 0 1280x1024x24 -ac +extension RANDR\" java -Dwebdriver.chrome.driver=/opt/selenium/chromedriver -jar /opt/selenium/selenium-server-standalone.jar  -role node -hub http://localhost:4444/grid/register/ &"
