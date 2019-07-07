from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.chrome.options import Options

import json
import pypinyin
import time

# 设置
chrome_options = Options()
chrome_options.add_argument('window-size=1920x1080')
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument('blink-settings=imagesEnabled=false')
chrome_options.add_argument('--headless')

# 机场三字码
def airport_info(departure, arrival):
    with open('airports.json', 'r', encoding='utf-8') as f:
        airports = json.load(f)

    departures = []
    arrivals = []
    for airport in airports:
        if airport['city'].lower() == ''.join(pypinyin.lazy_pinyin(departure)):
            departures.append(airport)
        if airport['city'].lower() == ''.join(pypinyin.lazy_pinyin(arrival)):
            arrivals.append(airport)

    if len(departures)>1:
        departures.reverse()
    if len(arrivals)>1:
        arrivals.reverse()

    return departures, arrivals

# 南方航空
def NANFANG(departure, arrival, date, adult, child, infant):
    url = 'https://b2c.csair.com/B2C40/newTrips/static/main/page/booking/index.html?'
    para = {
        't':'S',#单程
        'c1':departure,#出发城市
        'c2':arrival,#到达城市
        'd1':date,#出发日期
        'at':str(adult),#成人（≥12）1~9
        'ct':str(child),#儿童（2-11）0~2
        'it':str(infant)#婴儿（<2）0~1
    }

    for i in para:
        url += i+'='+para[i]+'&'

    driver = webdriver.Chrome(options=chrome_options)
    driver.get(url)
    try:
        element = WebDriverWait(driver, 2).until(
            EC.presence_of_element_located((By.CLASS_NAME, "zls-flight"))
        )
    except Exception:
        print('NANFANG Error')
        exit()
    
    lis = driver.find_elements_by_class_name("zls-flight-cell")
    flights = []
    for li in lis:
        temp = li.text.split()
        flights.append(['南方航空', temp[0], temp[3], temp[6], temp[-1]])
    
    return flights

# 厦门航空
def XIAMEN(departure, arrival, date, adult, child, infant):
    url = 'https://et.xiamenair.com/xiamenair/book/findFlights.action?'
    para = {
        'lang':'zh',#中文
        'tripType':'0',#单程
        'queryFlightInfo':departure+','+arrival+','+date #出发城市,到达城市,出发时间
    }

    for i in para:
        url += i+'='+para[i]+'&'

    driver = webdriver.Chrome(options=chrome_options)
    driver.get(url)

    try:
        element = WebDriverWait(driver, 2).until(
            EC.presence_of_element_located((By.CLASS_NAME, "form-mess"))
        )
    except Exception:
        print('XIAMEN Error')
        exit()

    divs = driver.find_elements_by_class_name("form-mess")
    flights = []
    for div in divs:
        temp = div.text.split()
        flights.append(['厦门航空', temp[0], temp[2], temp[4], temp[6]])

    return flights

# 海南航空
def HAINAN(departure, arrival, date, adult, child, infant):
    url = 'http://new.hnair.com/hainanair/ibe/common/flightSearch.do'

    driver = webdriver.Chrome(options=chrome_options)
    driver.get(url)

    if departure == 'PEK':
        script = "arguments[0].value='CITY_BJS_CN'"
    else:
        script = "arguments[0].value='CITY_"+departure+"_CN'"
    element = driver.find_element_by_id('Search-OriginDestinationInformation-Origin-location')
    driver.execute_script(script, element)
    element = driver.find_element_by_id('Search-OriginDestinationInformation-Origin-location_input_location')
    driver.execute_script(script, element)

    if arrival == 'PEK':
        script = "arguments[0].value='CITY_BJS_CN'"
    else:
        script = "arguments[0].value='CITY_" + arrival + "_CN'"
    element = driver.find_element_by_id('Search-OriginDestinationInformation-Destination-location')
    driver.execute_script(script, element)
    element = driver.find_element_by_id('Search-OriginDestinationInformation-Destination-location_input_location')
    driver.execute_script(script, element)

    driver.find_element_by_name('Search/DateInformation/departDate_display').clear()
    driver.find_element_by_name('Search/DateInformation/departDate_display').send_keys(date)
    ActionChains(driver).move_by_offset(0, 0).click().perform()

    #默认经济舱Y 公务舱F
    element = driver.find_element_by_id('commitCabin')
    driver.execute_script("arguments[0].value='Y'", element)

    # 成人≥12
    script = "arguments[0].value='"+str(adult)+"'"
    element = driver.find_element_by_name('Search/Passengers/adults')
    driver.execute_script(script, element)
    # 儿童2~11
    script = "arguments[0].value='" + str(child) + "'"
    element = driver.find_element_by_name('Search/Passengers/children')
    driver.execute_script(script, element)
    # 军残
    element = driver.find_element_by_name('Search/Passengers/MilitaryDisabled')
    driver.execute_script("arguments[0].value='0'", element)
    # 警残
    element = driver.find_element_by_name('Search/Passengers/PoliceDisabled')
    driver.execute_script("arguments[0].value='0'", element)

    time.sleep(0.8)
    driver.find_element_by_css_selector("[class='button-red-short btn-confirm btn-vali']").click()
    
    try:
        element = WebDriverWait(driver, 2).until(
            EC.presence_of_element_located((By.CLASS_NAME, "route-item"))
        )
    except Exception:
        print('HAINAN Error')
        exit()

    divs = driver.find_elements_by_class_name('route-item')
    flights = []
    for div in divs:
        temp = div.text.split()
        flights.append(['海南航空', temp[0], temp[2][-5:], temp[4][-5:], temp[13]])
    
    return flights
        
# 东方航空
def DONGFANG(departure, arrival, date, adult, child, infant):
    url = 'http://www.ceair.com/booking/'

    temp = date.split('-')
    url = url+departure.lower()+'-'+arrival.lower()+'-'+temp[0][-2:]+temp[1]+temp[2]+'_CNY.html'

    print(url)
    driver = webdriver.Chrome(options=chrome_options)
    driver.get(url)

    try:
        element = WebDriverWait(driver, 2).until(
            EC.presence_of_element_located((By.CLASS_NAME, "flight"))
        )
    except Exception:
        print('DONGFANG Error')
        exit()

    divs = driver.find_elements_by_class_name('flight')
    flights = []
    for div in divs:
        temp = div.text.split()
        if ':' in temp[5]:
            flights.append(['东方航空', temp[2][:6], temp[5], temp[9], temp[16]])
        else:
            flights.append(['东方航空', temp[2][:6], temp[6], temp[10], temp[17]])
            
    return flights

# 携程旅行
def XIECHENG(departure, arrival, date, adult, child, infant):
    url = 'https://flights.ctrip.com/itinerary/oneway/'
    url = url + departure.lower() + '-' + arrival.lower() + '?date=' + date

    driver = webdriver.Chrome(options=chrome_options)
    driver.get(url)

    try:
        element = WebDriverWait(driver, 2).until(
            EC.presence_of_element_located((By.CLASS_NAME, "search_table_header"))
        )
    except Exception:
        print('XIECHENG Error')
        exit()

    # 移动到页面最底部
    for i in range(9):
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(0.8)

    divs = driver.find_elements_by_css_selector("[class='search_box search_box_tag search_box_light Label_Flight']")
    flights = []
    for div in divs:
        temp = div.text.split()
        flights.append(['携程旅行', temp[0], temp[3], temp[5], temp[9][:len(temp[9])-1]])
    
    return flights

# param error
# 中国国航
def GUOHANG(departure, arrival, date, adult, child, infant):
    url = 'http://et.airchina.com.cn/InternetBooking/AirLowFareSearchExternal.do?&'
    year, month, day = date.split('-')
    para = {
        'tripType':'OW',
        'searchType':'FARE',
        'flexibleSearch':'false',
        'directFlightsOnly':'false',
        'fareOptions':'1.FAR.X',
        'outboundOption.originLocationCode':departure,
        'outboundOption.destinationLocationCode':arrival,
        'outboundOption.departureDay':day,
        'outboundOption.departureMonth':month,
        'outboundOption.departureYear':year,
        'outboundOption.departureTime':'NA',
        'guestTypes%5B0%5D.type':'ADT',
        'guestTypes%5B0%5D.amount':'1',
        'guestTypes%5B1%5D.type':'CNN',
        'guestTypes%5B1%5D.amount':'0',
        'guestTypes%5B2%5D.type':'INF',
        'guestTypes%5B2%5D.amount':'0',
        'guestTypes%5B3%5D.type':'MWD',
        'guestTypes%5B3%5D.amount':'0',
        'guestTypes%5B4%5D.type':'PWD',
        'guestTypes%5B4%5D.amount':'0',
        'pos':'AIRCHINA_CN',
        'lang':'zh_CN',
    }

    for i in para:
        url += i+'='+para[i]+'&'

    driver = webdriver.Chrome(options=chrome_options)
    driver.get(url)
    try:
        element = WebDriverWait(driver, 2).until(
            EC.presence_of_element_located((By.ID, "AIR_SEARCH_RESULT_CONTEXT_ID0"))
        )
    except Exception:
        print('Error')
        exit()

    table = driver.find_element_by_class_name('resultWithFF5')
    tbodys = table.find_elements('tbody')
    for body in tbodys:
        print(body.text)

# 合并排序
def Merge(departure, arrival, date, adult, child, infant):
    flights = []
    flights.extend(NANFANG(departure, arrival, date, adult, child, infant))
    flights.extend(XIAMEN(departure, arrival, date, adult, child, infant))
    flights.extend(HAINAN(departure, arrival, date, adult, child, infant))
    flights.extend(DONGFANG(departure, arrival, date, adult, child, infant))
    flights.extend(XIECHENG(departure, arrival, date, adult, child, infant))
    for f in flights:
        if '￥' in f[-1] or '¥' in f[-1]:
            f[-1] = int(f[-1][1:])
        elif ',' in f[-1]:
            f[-1] = int(''.join(f[-1].split(',')))
    
    flights.sort(key=lambda x: x[-1])
    for f in flights:
        print(f)

# 测试
if __name__ == "__main__":
    departure = '福州'
    arrival = '北京'
    date = '2019-03-01'
    departure_info, arrival_info = airport_info(departure, arrival)
    Merge(departure_info[0]['iata'], arrival_info[0]['iata'], date, 1, 0, 0)