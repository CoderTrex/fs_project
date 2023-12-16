from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup
import pymongo
from pymongo import MongoClient
import time

# Selenium 설정
options = Options()
options.headless = True  # 브라우저를 띄우지 않고 실행할 경우

driver = webdriver.Chrome(options=options)
try:
    driver.get(
        'https://comic.naver.com/webtoon?tab=finish')

    # 페이지가 로딩될 때까지 기다리기 (예: 5초)
    driver.implicitly_wait(5)
    time.sleep(5)

    total_li_list = []

    # # 스크롤을 끝까지 내리기
    while True:
        # 현재 찾은 li 요소의 개수
        current_li_count = len(driver.find_elements(By.CSS_SELECTOR, 'div.component_wrap ul > li'))

        # 스크롤을 끝까지 내리기
        action = driver.find_element(By.TAG_NAME, 'body')
        action.send_keys(Keys.END)
        for i in range(15):
            action.send_keys(Keys.ARROW_UP)

        # 새로운 li 요소들이 로딩될 때까지 기다리기
        time.sleep(5)  # 페이지가 로딩되는 동안 대기

        # 새로운 li 요소들 가져오기
        li_elements = driver.find_elements(By.CSS_SELECTOR, 'div.component_wrap ul > li')
        # print(li_elements)
        total_li_list += li_elements
        # 새로운 li 요소가 더 이상 로딩되지 않으면 반복 종료
        
        if len(li_elements) == current_li_count:
            break

    driver.execute_script('window.scrollTo(0, 0)')

    soup = BeautifulSoup(driver.page_source, 'html.parser')
    db_genre = []
    # MongoDB 연결
    client = MongoClient('localhost', 27017)
    db = client['fsdb_naver']  # 여기에는 사용할 데이터베이스의 이름을 입력하세요
    collection = db['end']  # 여기에는 사용할 컬렉션의 이름을 입력하세요

    # 위에서 사용한 코드를 그대로 가져와서 MongoDB에 데이터 넣기
    for index in range(1, 1000):
        title_selector = f'div.component_wrap ul > li:nth-child({index}) > div > a > span > span'
        title_span = soup.select_one(title_selector)
        
        if title_span is None:
            break
        if title_span:
            genre_data = {'index': index, 'title': title_span.text}

            # 기존 문서가 있는지 확인
            existing_document = collection.find_one({'index': index})
    
            if existing_document:
                # 이미 존재하는 문서가 있다면 업데이트
                collection.update_one({'index': index}, {'$set': {'title': title_span.text}})
                print(f"문서 {index}가 이미 존재하며 업데이트되었습니다.")
            else:
                # 존재하지 않는 경우에는 새로운 문서 삽입
                collection.insert_one(genre_data)
                print(f"새로운 문서 {index}가 삽입되었습니다.")

except Exception as e:
    # 예외가 발생하면 이 블록이 실행됩니다.
    # 예외에 대한 메시지를 출력하거나 필요에 따라 다른 처리를 할 수 있습니다.
    print(f"An exception occurred: {e}")


client.close()  # MongoDB 연결 종료
driver.quit()