from selenium import webdriver
from selenium.webdriver.common.by import By
import time
# WebDriver 초기화
driver = webdriver.Chrome()

# # 웹 페이지 열기
# driver.get("https://webtoon.kakao.com/")
# time.sleep(5)
# /html/body/div[1]/div/main/div/div[1]/div[4]/div[3]/ul/li[5]/p
# # 클래스 이름으로 모든 요소 가져오기
# elements = driver.find_elements(By.CLASS_NAME, "whitespace-pre-wrap break-all break-words support-break-word s14-bold-grey05 px-4 !whitespace-nowrap")
# print(elements)

# 요소들을 순회하며 클릭

# for element in elements:
#     # 요소를 클릭하기 전에 상태를 확인하거나 다른 조건을 사용할 수 있습니다.
#     # 예를 들어, 클래스 이름에 따라 클릭 여부를 결정할 수 있습니다.
#     class_name = element.get_attribute("class")
    
#     if "s14-bold-white" in class_name:
#         # 클릭되었을 때의 동작
#         element.click()
#     elif "s14-bold-grey05" in class_name:
#         # 클릭되지 않았을 때의 동작
#         # 필요에 따라 다른 동작을 추가할 수 있습니다.
#         pass

# # 브라우저 닫기
# driver.quit()


from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# WebDriver 초기화
driver = webdriver.Chrome()

# 웹 페이지 열기
driver.get("https://webtoon.kakao.com/")
time.sleep(5)


# 4~11
# /html/body/div[1]/div/main/div/div[1]/div[4]/div[3]/ul/li[4]/p


for i in range(4, 12):
    # XPath를 사용하여 요소 찾기
    xpath = "/html/body/div[1]/div/main/div/div[1]/div[4]/div[3]/ul/li[{0}]/p".format(i)
    element = driver.find_element("xpath", xpath)
    element.click()
    
    # XPath를 사용하여 요소 찾기
    xpath = "/html/body/div[1]/div/main/div/div[1]/div[4]/div[1]/div/div/a/div[4]/picture/img"

    # 페이지 로드를 명시적으로 기다림
    wait = WebDriverWait(driver, 10)
    element = wait.until(EC.visibility_of_element_located((By.XPATH, xpath)))

    # img 태그에서 alt 속성 가져오기
    alt_value = element.get_attribute("alt")

    # 출력 또는 필요에 따라 사용
    print(alt_value)

# 브라우저 닫기
driver.quit()

    

time.sleep(5)
# 브라우저 닫기
driver.quit()
