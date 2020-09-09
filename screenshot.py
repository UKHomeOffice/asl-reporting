from selenium import webdriver

browser = webdriver.Firefox()
browser.get('http://www.google.com/')
browser.save_screenshot('screenie.png')
