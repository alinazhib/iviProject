from robot.api.deco import keyword

from typing import List, Optional, Tuple, Union

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys

from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.remote.webelement import WebElement

import time
import re

class TestLibrary(object):
    ROBOT_LIBRARY_SCOPE = 'Global'

    def open_browser(self):
        self.driver = webdriver.Chrome()

    @keyword("Go To Google And Search ivi")
    def go_to_google_and_search_ivi(self):
        """Открывает браузер, переходит в Google и ищет ivi"""
        self.open_browser()

        driver = self.driver

        driver.maximize_window()
        driver.get('https://www.google.com/')
        assert 'Google' in driver.title

        search = driver.find_element_by_xpath('//input[@title="Поиск"]')
        search.send_keys('ivi')
        search.send_keys(Keys.RETURN)

        assert 'ivi - Поиск в Google' in driver.title
        assert 'ivi' in driver.page_source

    @keyword("Go To")
    def go_to(self, url, page_title):
        """Переходит по url и проверяет, что открылась ожидаемая страница"""

        driver = self.driver
        driver.get(url)

        assert page_title in driver.title
        assert url  in  driver.current_url

    @keyword("Go To Images And Сhoose Large")
    def go_to_images_and_choose_large(self):
        """Проверяет, что открыта страница с результатом поиска ivi,
        после чего переходит к картинкам и выбирает Большие"""
        driver = self.driver
        driver.find_element_by_xpath('//a[text()="Картинки"]').click()
        driver.find_element_by_xpath('//div[text()="Инструменты"]').click()

        time.sleep(1)

        driver.find_element_by_xpath('//div[text()="Размер"]').click()
        driver.find_element_by_xpath('//span[text()="Большой"]').click()

        print(driver.title)

        # assert 'ivi – Google Поиск' in driver.title

    @keyword("Click On Element")
    def click_on_element(self, element):
        """Нажимает на элемент"""
        element.click()

    @keyword("Find Element By Xpath And Click")
    def find_element_by_xpath_and_click(self, xpath):
        """Находит элемент по xpath и нажимает его"""
        self.driver.find_element_by_xpath(xpath).click()

    @keyword("Get WebElements By Class Name")
    def get_webelements_by_class_name(self, class_name):
        """Возвращает список элементов, найденных по class_name"""
        return self.driver.find_elements_by_class_name(class_name)

    @keyword("Get WebElements By Xpath")
    def get_webelements_by_xpath(self, xpath):
        """Возвращает список элементов, найденных по xpath"""
        return self.driver.find_elements_by_xpath(xpath)

    @keyword("Get WebElement Attribute By Class Name")
    def get_webelement_attribute_by_class_name(self, class_name, attribute):
        """Возвращает атрибут элемента"""
        element = self.driver.find_element_by_class_name(class_name)
        return element.get_attribute(attribute)

    @keyword("Get WebElement Attribute By Xpath")
    def get_webelement_attribute_by_xpath(self, xpath, attribute):
        """Возвращает атрибут элемента"""
        element = self.driver.find_element_by_xpath(xpath)
        return element.get_attribute(attribute)

    @keyword("Get WebElement Attribute")
    def get_webelement_attribute(self, element, attribute: str) -> str:
        """Возвращает атрибут элемента"""
        return element.get_attribute(attribute)

    @keyword("Get Webelement Text")
    def get_webelement_text(self, xpath) -> str:
        """Возвращает текст элемента"""
        return self.driver.find_element_by_xpath(xpath).text

    @keyword("Return Rate")
    def get_rate(self, rate):
        list_rate = re.findall(r'[^Рейтинг:\s]', rate)
        return ''.join(list_rate)

    @keyword("Close Browser")
    def close_browser(self):
        """Закрывает браузер"""
        self.driver.close()