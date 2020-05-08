# -*- coding: utf-8 -*-
from selenium import webdriver
from scrapy.selector import Selector
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from shutil import which
from time import sleep
import sys
import os
#from db import Review
def change_page_number(num, url):
    urls_1 = url.split("&")
    urls_2 = urls_1[0].split("=")
    new_url = urls_2[0]+str("=")+str(num)+str("&")+urls_1[1]
    #print(new_url)
    return new_url

def get_game_genre_from_url(url):
    genre = str(url).split("#")[0].split("/")[-2].replace("%20", " ")
    return genre

def write_to_file(genre, url):
    with open(file='./all_url_folder'+'/'+genre+'/'+'steam_url.txt', mode='a', encoding='utf-8') as file:
        file.writelines(url)
        file.write('\n')
        

def get_game_data(final_resp_page):
    game_title = final_resp_page.xpath("//div[@class='apphub_AppName']/text()").get()
    all_review_cat = final_resp_page.xpath("//div[@class='user_reviews_summary_row'][2]/div[@class='summary column']/span/text()").get()
    release_date = final_resp_page.xpath("//div[@class='release_date']/div[@class='date']/text()").get()
    developer = final_resp_page.xpath("//div[@class='dev_row'][1]/div[@class='summary column']/a/text()").get()
    publisher = final_resp_page.xpath("//div[@class='dev_row'][2]/div[@class='summary column']/a/text()").get()

    print("\n".join([game_title, all_review_cat, release_date, developer, publisher]))
    print("*"*40)

def get_driver():
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--incognito")
    chrome_path = which("./chromedriver")
            
    driver = webdriver.Chrome(executable_path=chrome_path, options=chrome_options)
    driver.set_window_size(1920, 1080)
    return driver

def close_driver(driver):
    try:
        driver.close()
        return True
    except:
        print("********** Error while closing driver *********")
        return sys.exc_info()[0]

driver = get_driver()
driver.get("http://store.steampowered.com/tag/browse/#global_492/")
game_genre_all = driver.find_elements_by_xpath("//div[@class='tag_browse_tags']/div")
game_genre_list = []
for game_genre in game_genre_all:
    game_genre_list.append(str(f"https://store.steampowered.com/tags/en/{game_genre.text.replace(' ','%20')}/#p=0&tab=TopSellers"))

#all_game_url = []
# Action - 1879, Adventure - 1553, Casual - 1484, Indie - 2840, Massively Multiplayer - 149, 
# Racing - 179, RPG - 889, Simulation - 1071, Sports - 226, Strategy - 983, Free to Play - 35

# 1. Action
game_genre_list = [
    #"https://store.steampowered.com/tags/en/Indie/#p=0&tab=TopSellers",
    #"https://store.steampowered.com/tags/en/Action/#p=0&tab=TopSellers",
    #"https://store.steampowered.com/tags/en/Adventure/#p=0&tab=TopSellers",
    #"https://store.steampowered.com/tags/en/Casual/#p=0&tab=TopSellers",
    #"https://store.steampowered.com/tags/en/Simulation/#p=0&tab=TopSellers",
    #"https://store.steampowered.com/tags/en/Strategy/#p=0&tab=TopSellers",
    #"https://store.steampowered.com/tags/en/RPG/#p=0&tab=TopSellers",
    #"https://store.steampowered.com/genre/Free%20to%20Play/#p=0&tab=TopSellers",
    #"https://store.steampowered.com/tags/en/Sports/#p=0&tab=TopSellers",
    #"https://store.steampowered.com/tags/en/Massively%20Multiplayer/#p=0&tab=TopSellers",
    #"https://store.steampowered.com/tags/en/Racing/#p=0&tab=TopSellers",
    #"https://store.steampowered.com/genre/Early%20Access/#p=0&tab=TopSellers",
    "https://store.steampowered.com/tags/en/Singleplayer/#p=0&tab=TopSellers"
]
for game_genre_url in game_genre_list:
    genre_count = 1
    #Indie
    #page = 1130 #page = 2040 #page = 2110 #page = 2134
    # Action
    #page = 180 #page = 386 #page = 624 #page = 680 #page = 749 #page = 870 #page = 916 page = 1010
    #page = 1036 #page = 1270 #page = 1524 #page = 1640 final = 1880
    # Adventure
    # page = 0 #page = 742 #page = 751 #page = 786 #page = 950 #page = 1300 #page = 1332 
    # #page = 1343
    #Casual
    #page = 0 #page = 365 #page = 610 #page = 1350
    #Simulation
    #page = 0 #page = 53 #page = 94 #page = 290 #page = 478 #page = 703 #page = 723
    #Strategy
    # page = 0 #page = 250
    #RPG
    #page = 0 #page = 131 #page = 393 #page = 515 #page = 578
    #Free to Play
    #page = 0
    #Sports
    #page = 0 #page = 121
    #Massive Multi Player
    #page = 0
    #Racing
    #page = 130
    #Early Access
    #page = 0
    #Singleplayer
    page = 0
    #page = 685

    next_btn = True
    genre_name = get_game_genre_from_url(game_genre_url)
    try:
        #path = os.path.join(parent_dir, directory)
        #print(genre_count, '$'*20, genre_name, '$'*20)
        #os.mkdir('./all_url_folder'+'/'+genre_name, 0o777, parents=True, exist_ok=True)
        os.makedirs('./all_url_folder'+'/'+genre_name, exist_ok=True)
    except:
        print("--------URL FOLDER Error---------", sys.exc_info()[0])
    while next_btn:
        print(genre_name, page)
        game_genre_url = change_page_number(page, game_genre_url)
        driver.delete_all_cookies()
        driver.get(game_genre_url)
        driver.refresh()
        sleep(5)
        game_page_urls = WebDriverWait(driver, 5).until(EC.presence_of_all_elements_located((By.XPATH,"//div[@id='TopSellersRows']/a")))
        for game_page_url in game_page_urls:
            g_url = game_page_url.get_attribute('href')
            #all_game_url.append(g_url)
            #print(g_url)
            write_to_file(genre_name, g_url)
        if page % 10 == 0:
            close_driver(driver)
            sleep(10)
            driver = get_driver()
            driver.get(game_genre_url)
        try:
            driver.find_element_by_xpath("//span[@id='TopSellers_btn_next'][@class='pagebtn']")
        except:
            next_btn = False
        sleep(5)
        page = page + 1
    genre_count = genre_count + 1

#print(len(all_game_url))
close_driver(driver)