#================================================
# Centos-7-x86_64-minimal
#================================================


#========================
# Miscellaneous packages
# Includes minimal runtime used for executing non GUI Java programs
#========================
yum update -y

#==========
# Selenium
# https://www.seleniumhq.org/download/
#==========
seleniumlastrelease=`curl --silent 'https://www.seleniumhq.org/download/' | grep -o -E 'Download version <a href=".*+">.*+</a>' | grep -o -E 'https://[^"]*'`

rm -rf /opt/selenium/selenium-server-standalone.jar \
  && wget --no-verbose $seleniumlastrelease -O /opt/selenium/selenium-server-standalone.jar

#============================================
# Google Chrome
#============================================


yum update -y \
  && yum -y remove google-chrome-stable \
  && yum -y install google-chrome-stable \
  && rm -rf /etc/yum.repos.d/google-chrome.repo \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
  
#==================
# Chrome webdriver
# http://chromedriver.chromium.org/downloads
#==================
chromedriverlastrelease=`curl --silent 'https://chromedriver.storage.googleapis.com/LATEST_RELEASE'`
wget --no-verbose -O /tmp/chromedriver_linux64.zip "https://chromedriver.storage.googleapis.com/$chromedriverlastrelease/chromedriver_linux64.zip" \
  && rm -rf /opt/selenium/chromedriver \
  && unzip /tmp/chromedriver_linux64.zip -d /opt/selenium \
  && rm -rf /tmp/chromedriver_linux64.zip \
  && chmod 755 /opt/selenium/chromedriver \
  && ln -fs /opt/selenium/chromedriver /usr/bin/chromedriver
  
#==================
# Chrome crx
#==================
rm -rf /opt/selenium/ModHeader.crx
wget --no-verbose -O /opt/selenium/ModHeader.crx "https://raw.githubusercontent.com/speed/newcrawler-plugin-urlfetch-chrome/master/crx/ModHeader.crx"\
    && chmod 755 /opt/selenium/ModHeader.crx

chmod +x /opt/google/chrome/google-chrome
chown -R seluser:seluser /opt/selenium

#====================================
# Run Selenium Standalone
#====================================
#su - seluser -c "nohup xvfb-run -n 99 --server-args=\"-screen 0 1024x768x8 -ac +extension RANDR\" java -jar /opt/selenium/selenium-server-standalone.jar  -role hub &"

#http://127.0.0.1:5555/wd/hub
#su - seluser -c "nohup xvfb-run -n 98 --server-args=\"-screen 0 1024x768x8 -ac +extension RANDR\" java -Dwebdriver.chrome.driver=/opt/selenium/chromedriver -jar /opt/selenium/selenium-server-standalone.jar  -role node -hub http://localhost:4444/grid/register/ &"

#http://127.0.0.1:4444/wd/hub
su - seluser -c "(xvfb-run -n 99 --server-args=\"-screen 0 1024x768x8 -ac +extension RANDR\" java -jar /opt/selenium/selenium-server-standalone.jar > /dev/null &)"

