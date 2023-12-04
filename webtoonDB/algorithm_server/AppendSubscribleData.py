import pymongo
import time
# MongoDB 연결
client = pymongo.MongoClient("mongodb://localhost:27017")  # MongoDB의 주소와 포트에 맞게 수정

# 데이터베이스 선택
db_naver = client["fsdb_naver"]  
db_kakao = client["fsdb_kakao"]
db_kakopage = client["fsdb_kakaopage"]
platform_list = [db_naver, db_kakao, db_kakopage]
days_naver = ['mons', 'tues', 'weds', 'thus', 'fris', 'sats', 'suns', 'finisheds']
days = ['mons', 'tues', 'weds', 'thus', 'fris', 'sats', 'suns']

def get_info (name_title):
    result = {}
    for platform in platform_list:
        # 각 컬렉션의 문서에 대해 작업
        if (platform == db_naver):
            for day in days_naver:
                collection = platform[day] # 컬렉션 선택
                documents = collection.find() # 모든 문서 가져오기
                # 문서 출력 및 값 입력
                for document in documents:
                    if (name_title == document["title"]):
                        result = {
                            "url": document["url"],
                            "img": document["img"],
                            "author": document["author"],
                            "service": document["service"]
                        }
        else:
            for day in days:
                collection = platform[day] # 컬렉션 선택
                documents = collection.find() # 모든 문서 가져오기
                # 문서 출력 및 값 입력
                for document in documents:
                    if (name_title == document["title"]):
                        result = {
                            "url": document["url"],
                            "img": document["img"],
                            "author": document["author"],
                            "service": document["service"]
                        }
                    
    return result

result = get_info("곱게 키웠더니, 짐승")
print(result)
# 연결 닫기
client.close()