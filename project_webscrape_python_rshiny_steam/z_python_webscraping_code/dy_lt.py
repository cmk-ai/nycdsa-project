from selenium import webdriver
from scrapy.selector import Selector
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from shutil import which
from time import sleep
from itertools import islice
import os
import functools
import operator
import sys
import csv
import re

def os_data_clean(os_lst):
    try:
        if len(os_lst) > 1:
            return [os.strip() for os in os_lst if len(os) > 1]
        else:
            return os_lst
    except Exception as e:
        print("ERROR: os_data_clean", str(e))
    

# def memory_clean(mem_lst):
#     print(mem_lst)
#     try:
#         if len(mem_lst) > 1:
#             inter_lst = [mem.strip() for mem in mem_lst]
#             inter_lst = [re.sub('[^A-Za-z0-9 ]+', '', x) for x in inter_lst]
#             inter_lst = [x for x in inter_lst if x!= '']
#             print(inter_lst)
#             return [ str(inter.split(' ')[0]+' '+inter.split(' ')[1])  for inter in inter_lst if len(inter) > 1]
#         else:
#             return mem_lst
#     except Exception as e:
#         print("ERROR: memory_clean", str(e))


# def storage_clean(stg_lst):
#     try:
#         if len(stg_lst) > 1:
#             inter_lst = [stg.strip() for stg in stg_lst]
#             inter_lst = [re.sub('[^A-Za-z0-9 ]+', '', x) for x in inter_lst]
#             inter_lst = [x for x in inter_lst if x!= '']
#             print(inter_lst)
#             return [ str(inter.split(' ')[0]+' '+inter.split(' ')[1]) for inter in inter_lst if len(inter) > 1]
#         else:
#             return stg_lst
#     except Exception as e:
#         print("ERROR: storage_clean", str(e))
    

# def harddrive_clean(hrd_lst):
#     print(hrd_lst)
#     try:
#         if len(hrd_lst) > 1:
#             inter_lst = [hrd.strip() for hrd in hrd_lst]
#             inter_lst = [re.sub('[^A-Za-z0-9 ]+', '', x) for x in inter_lst]
#             inter_lst = [x for x in inter_lst if x!= '']
#             print(inter_lst)
#             return [ str(inter.split(' ')[0]+' '+inter.split(' ')[1]) for inter in inter_lst if len(inter) > 1]
#         else:
#             return hrd_lst
#     except Exception as e:
#         print("ERROR: harddrive_clean", str(e))

# def get_all_price(price_lst):
#     print('price_lst',price_lst)
#     try:
#         if len(price_lst) == 0:
#             return None
#         fin_list = []
#         for price in price_lst:
#             price = re.sub('[^A-Za-z0-9 ]+', '', price)
#             try:
#                 fin_list.append( int(price) )
#             except:
#                 continue
#         print('fin_list',fin_list)
#         return str(fin_list[0])
#     except Exception as e:
#         print("ERROR: get_all_price", sys.exc_info()[0], e)

def memory_storage_harddrive_clean(sys_lst):
    inter_lst = [stg.strip() for stg in sys_lst]
    inter_lst = [re.sub('[^A-Za-z0-9 ]+', '', x) for x in inter_lst]
    inter_lst = [x for x in inter_lst if x!= '']
    return inter_lst

def rm_brkt(num_str):
    if num_str is not None:
        return num_str.replace('(', '').replace(')','')
    else:
        return num_str

def rm_comma(num_str):
    if num_str is not None:
        return num_str.replace(',','')
    else:
        return num_str

def keep_alpha_numeric(str_special):
    if str_special is not None:
        return re.sub('[^A-Za-z0-9 ]+', '', str_special)
    else:
        return str_special

def get_if_subscription(subscription_string):
    if subscription_string is not None:
        if 'subscription' in str(subscription_string).lower():
            return 'subscription'
        else:
            return subscription_string
    else:
        return subscription_string

def get_if_violance_bad(violance_bad_string):
    if violance_bad_string is not None:
        if ('violence' in str(violance_bad_string).lower()) or 'bad language' in str(violance_bad_string).lower():
            return 'violence/bad_language'
        else:
            return violance_bad_string
    else:
        return violance_bad_string

def remove_extra_os_resourse(os_list, resourse_list):
    if len(os_list) >= 1:
        try:
            if (len(os_list) == len(resourse_list)):
                return resourse_list
            elif (len(os_list) == 1):
                return [resourse_list[0]]
            elif (len(os_list) == 2):
                return [resourse_list[0], resourse_list[2]]
            elif (len(os_list) == 3):
                return [resourse_list[0], resourse_list[2], resourse_list[4]]
            else:
                return resourse_list
        except:
            return resourse_list
    else:
        return resourse_list
 
def get_simple_os_name(big_os_list):
    try:
        if len(big_os_list) >= 1:
            os_list = []
            for os in big_os_list:
                if 'Windows' in os:
                    os_list.append('windows')
                elif ('X' in os or 'mac' in os or 'Mac' in os):
                    os_list.append('mac')
                elif ('Ubuntu' in os or 'linux' in os or 'Linux' in os or 'Steam' in os):
                    os_list.append('linux')
                else:
                    os_list.append('windows')
            return os_list        
        else:
            return big_os_list
    except Exception as e:
        print("ERROR: get_simple_os_name", str(e))

def write_header_to_file(row):
    path = "./all_csv_folder/"+global_genre_name+"/steam.csv"
    with open(file=path, mode='a', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(row)
def write_to_file(row):
    path = "./all_csv_folder/"+global_genre_name+"/steam.csv"
    with open(file=path, mode='a', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(row)

def get_game_data(final_resp_page):
    # final_resp_page.xpath("").get()
    game_title = final_resp_page.xpath("//div[@class='apphub_AppName']/text()").get()
    all_review_cat = final_resp_page.xpath("//div[@class='user_reviews_summary_row']//div[text()='All Reviews:']/parent::div//span/text()").get()
    release_date = final_resp_page.xpath("//div[@class='release_date']/div[@class='date']/text()").get()
    game_developer = final_resp_page.xpath("//div[@class='dev_row']//div[text()='Developer:']/parent::div//a/text()").get()
    game_publisher = final_resp_page.xpath("//div[@class='dev_row']//div[text()='Publisher:']/parent::div//a/text()").get()
    player_type = final_resp_page.xpath("//a[@class='name'][1]/text()").get()
    has_violence_bad = final_resp_page.xpath("//div[@class='game_rating_descriptors']//p[@class='descriptorText']/text()").get()
    price_original_bf_discount = final_resp_page.xpath("//div[@class='game_area_purchase_game']//div[@class='discount_original_price']/text()").get()
    discount_percentage = final_resp_page.xpath("//div[@class='game_area_purchase_game']//div[@class='discount_pct']/text()").get()
    price_discount = final_resp_page.xpath("//div[@class='game_area_purchase_game']//div[@class='discount_final_price']/text()").get()
    price_original = final_resp_page.xpath("//div[@class='game_purchase_price price']/text()").get()
    price_subscription = final_resp_page.xpath("//div[@class='game_area_purchase_game_dropdown_selection']/span/text()").get()
    genre_list = final_resp_page.xpath("//div[@class='details_block']//a[contains(@href,'genre')]/text()").getall()
    os_list = final_resp_page.xpath("//div[@class='sysreq_contents']//div[contains(@class,'game_area_sys_req')]//li//strong[text()='OS:']/parent::li/text()").getall()
    win_mac_linux_memory = final_resp_page.xpath("//div[@class='sysreq_contents']//div[contains(@class,'game_area_sys_req')]//li//strong[text()='Memory:']/parent::li/text()").getall()
    win_mac_linux_storage = final_resp_page.xpath("//div[@class='sysreq_contents']//div[contains(@class,'game_area_sys_req')]//li//strong[text()='Storage:']/parent::li/text()").getall()
    win_mac_linux_harddrive = final_resp_page.xpath("//div[@class='sysreq_contents']//div[contains(@class,'game_area_sys_req')]//li//strong[text()='Hard Drive:']/parent::li/text()").getall()
    vr_supported = final_resp_page.xpath("//div[@class='block_title vrsupport']/text()").get()
    purchase_type_all = final_resp_page.xpath("//label[@for='purchase_type_all']/span/text()").get()
    purchase_type_steam = final_resp_page.xpath("//label[@for='purchase_type_steam']/span/text()").get()
    purchase_type_other = final_resp_page.xpath("//label[@for='purchase_type_non_steam']/span/text()").get()
    review_all = final_resp_page.xpath("//label[@for='review_type_all']/span/text()").get()
    review_positive = final_resp_page.xpath("//label[@for='review_type_positive']/span/text()").get()
    review_negative = final_resp_page.xpath("//label[@for='review_type_negative']/span/text()").get()

    if len(os_list) == 0:
        os_list = final_resp_page.xpath("//div[@class='sysreq_tabs']//div[contains(@class,'sysreq_tab')]/text()").getall()
        
    game_title = keep_alpha_numeric(game_title)
    has_violence_bad = get_if_violance_bad(has_violence_bad)
    price_original_bf_discount = keep_alpha_numeric(price_original_bf_discount)
    price_discount = keep_alpha_numeric(price_discount)
    #price_original = get_all_price(price_original)
    price_original = keep_alpha_numeric(price_original)
    price_subscription = get_if_subscription(price_subscription)
    os_list = os_data_clean(os_list)
    os_list = get_simple_os_name(os_list)
    os_list = list(set(os_list))
    win_mac_linux_memory = memory_storage_harddrive_clean(win_mac_linux_memory)
    win_mac_linux_storage = memory_storage_harddrive_clean(win_mac_linux_storage)
    win_mac_linux_harddrive = memory_storage_harddrive_clean(win_mac_linux_harddrive)
    win_mac_linux_memory = remove_extra_os_resourse(os_list,win_mac_linux_memory)
    win_mac_linux_storage = remove_extra_os_resourse(os_list,win_mac_linux_storage)
    win_mac_linux_harddrive = remove_extra_os_resourse(os_list,win_mac_linux_harddrive)
    
    purchase_type_all = rm_comma(rm_brkt(purchase_type_all))
    purchase_type_steam = rm_comma(rm_brkt(purchase_type_steam))
    purchase_type_other = rm_comma(rm_brkt(purchase_type_other))
    review_all = rm_comma(rm_brkt(review_all))
    review_positive = rm_comma(rm_brkt(review_positive))
    review_negative = rm_comma(rm_brkt(review_negative))

    # final_str = ("Game Title: "+str(game_title).strip()+"\n"
    #             "All Review Cat: "+str(all_review_cat).strip()+"\n"
    #             "Release Date: "+str(release_date).strip()+"\n"
    #             "Game Developer: "+str(game_developer).strip()+"\n"
    #             "Game Publisher: "+str(game_publisher).strip()+"\n"
    #             "Player Type: "+str(player_type).strip()+"\n"
    #             "Has Violence Bad Language: "+str(has_violence_bad).strip()+"\n"
    #             "Price Original Bf Discount : "+str(price_original_bf_discount).strip()+"\n"
    #             "Discount Percentage: "+str(discount_percentage).strip()+"\n"
    #             "Price Discount: "+str(price_discount).strip()+"\n"
    #             "Price Original: "+str(price_original).strip()+"\n"
    #             "Price Subscription: "+str(price_subscription).strip()+"\n"
    #             "Genre List: "+str(genre_list).strip()+"\n"
    #             "OS List: "+str(os_list).strip()+"\n"
    #             "Memory: "+str(win_mac_linux_memory).strip()+"\n"
    #             "Storage: "+str(win_mac_linux_storage).strip()+"\n"
    #             "Hard Drive: "+str(win_mac_linux_harddrive).strip()+"\n"
    #             "VR Support: "+str(vr_supported).strip()+"\n"
    #             "Purchase All: "+str(purchase_type_all).strip()+"\n"
    #             "Purchase Steam: "+str(purchase_type_steam).strip()+"\n"
    #             "Purchase Other: "+str(purchase_type_other).strip()+"\n"
    #             "Review All: "+str(review_all).strip()+"\n"
    #             "Review Positive: "+str(review_positive).strip()+"\n"
    #             "Review Negative: "+str(review_negative).strip()+"\n")
                
    # print(final_str)
    # print("#"*20)
    game_detail_list = [
        game_title, all_review_cat, release_date, game_developer, game_publisher, 
        player_type, has_violence_bad, price_original_bf_discount, discount_percentage, price_discount, 
        price_original, price_subscription, genre_list, os_list, win_mac_linux_memory, win_mac_linux_storage, 
        win_mac_linux_harddrive, vr_supported, purchase_type_all, purchase_type_steam, purchase_type_other,
        review_all, review_positive, review_negative
        ]
    game_detail_list = [str(game_detail).strip() for game_detail in game_detail_list]
    return game_detail_list
    #write_to_file(game_detail_list)
    #print("\n".join([game_title, all_review_cat, release_date, developer, publisher]))

def read_url_from_file():
    url_list = []
    path = "./all_url_folder/"+global_genre_name
    for root, _ , files in os.walk(path):
        for file in files:
            path =  os.path.join(root, file)
            #print(path)
            if 'DS_Store' in path:
                continue
            with open(file=os.path.join(root, file), mode="r", encoding='utf-8') as auto:
                url_list.append(auto.read().splitlines())
    url_list = functools.reduce(operator.iconcat, url_list, [])
    return url_list

def read_one_url_from_file(line_no):
    path = "./all_url_folder/"+global_genre_name+"/steam_url.txt"
    with open(path) as f:
        for line in islice(f, line_no, None):
            return line

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

def get_game_name(url):
    game_name = url.split("/")[-2]
    return game_name
# list of genre
#["Indie", "Action", "Adventure", "Casual", "Simulation",
# "Strategy", "RPG", "Free", "Sports", "Massively Multiplayer",
#"Racing", "Early Access"]
global_genre_name = "Action"
# After changing 'Genre' make sure to comment 'write_header_to_file' on second time

header_list = ["Game_Title","All_Review_Cat","Release_Date","Game_Developer","Game_Publisher",
"Player_Type","Has_Violence","Price_Original_Before_Discount",
"Discount_Percentage","Price_Discount","Price_Original","price_subscription","Genre_List",
"OS_List","Memory","Storage","Hard_Drive","VR_Support","Purchase_All",
"Purchase_Steam","Purchase_Other","Review_All","Review_Positive","Review_Negative"]
# url_list = [
#     "https://store.steampowered.com/app/346110/ARK_Survival_Evolved/",
#     "https://store.steampowered.com/app/239140/Dying_Light/",
#     "https://store.steampowered.com/app/620980/Beat_Saber/",
#     "https://store.steampowered.com/app/1256380/FPS_Infinite/",
#     "https://store.steampowered.com/app/306130/The_Elder_Scrolls_Online/"
# ]
try:
    path = "./all_csv_folder/"+global_genre_name
    os.makedirs(path, exist_ok=True)
except:
    print("--------URL FOLDER Error---------", sys.exc_info()[0])
#write_header_to_file(header_list)
url_list_len = len( read_url_from_file() )
driver = get_driver()
#line = 0 #line = 1482 #line = 1692 #line = 1904 #line = 2072 #line = 2124 #line = 2463 
# #line = 2481 #line = 2538 #line = 2861 #line = 3154 #line = 3304 #line = 3452 #line = 3558
#line = 3991 #line = 4059 #line = 4193 #line = 4306 #line = 4750 #line = 5181 #line = 5593
#line = 6006 #line = 6380 #line = 6747 #line = 7130 #line = 7642 #line = 7975 #line = 8391
#line = 8673
#line = 8768
#line = 9291
#line = 9714
#line = 10244
line = 0
#line = 28251
game_detail_row = ''
while line < url_list_len:
    url = read_one_url_from_file(line)
    driver.get(url)
    #url = "https://store.steampowered.com/app/1072420/DRAGON_QUEST_BUILDERS_2/"
    #url = "https://store.steampowered.com/app/588650/Dead_Cells/"
    print(global_genre_name, line, get_game_name(url))
    sleep(5)
    try:
        driver.find_element_by_xpath("//select[@id='ageDay']").send_keys("25")
        driver.find_element_by_xpath("//select[@id='ageMonth']").send_keys("June")
        driver.find_element_by_xpath("//select[@id='ageYear']").send_keys("1980")
        driver.find_element_by_xpath("//a[@class='btnv6_blue_hoverfade btn_medium']").click()
        sleep(5)
        game_detail_row=get_game_data(Selector(text=driver.page_source))
    except:
        try:
            game_detail_row=get_game_data(Selector(text=driver.page_source))
        except:
            print("--------Error---------", sys.exc_info()[0])
    write_to_file(game_detail_row)
    if line % 10 == 0:
        close_driver(driver)
        sleep(5)
        driver = get_driver()       
    line = line + 1
close_driver(driver)