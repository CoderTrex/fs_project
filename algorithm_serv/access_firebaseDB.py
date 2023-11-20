

# firebase 라이브러리 import
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# mongoDB 라이브러리 import
from pymongo import MongoClient

# api request
import requests

# API 엔드포인트 URL
api_Search_url = "https://korea-webtoon-api.herokuapp.com/search"


Genre_list = ['PURE', 'FANTASY', 'ACTION', 'DAILY', 'THRILL', 'COMIC', 'HISTORICAL', 'DRAMA',
                'SENSIBILITY', 'SPORTS']

class Firebase_User_Base_INFO:
    def __init__(self, collection_name):
        # Firebase 초기화
        cred = credentials.Certificate("C:\\Code\\fs_project\\algorithm_serv\\fsserv_acoount_key.json")
        firebase_admin.initialize_app(cred)
        self.db = firestore.client()

        # 컬렉션 이름 설정
        self.collection_name = collection_name

    def create_user_base_recommendations(self):
        docs = self.db.collection(self.collection_name).get()
        userdict = {}

        for doc in docs:
            doc_data = doc.to_dict()
            sublist = doc_data.get('sublist', {})
            
            # sublist에서 필요한 정보 추출
            title = sublist.get('title', '')

            # userdict에 title이 이미 있는지 확인하고 없으면 빈 리스트로 초기화
            if title not in userdict:
                userdict[title] = []

        user_list = list(userdict.keys())
        user_sub_list = {}  # 빈 딕셔너리를 생성
        for webtoon_name in user_list:
            user_sub_list[str(webtoon_name)] = []
        # print(user_sub_list)

        for keyword in user_list:
            # API 호출을 위한 파라미터 설정
            params = {
                "keyword": keyword
            }
            response = requests.get(api_Search_url, params=params)
            # 응답 확인
            if response.status_code == 200:
                data = response.json()
                totalWebtoonCount = data.get("totalWebtoonCount")
                webtoons = data.get("webtoons")
                if totalWebtoonCount > 0:
                    print(f"연결 및 접속 양호. 검색 결과 (총 {totalWebtoonCount} 개의 웹툰이 검색되었습니다.)")
                    for webtoon in webtoons:
                        user_sub_list[webtoon['title']].append(webtoon['author'])
                        user_sub_list[webtoon['title']].append(webtoon['url'])
                        user_sub_list[webtoon['title']].append(webtoon['service'])
                        user_sub_list[webtoon['title']].append(webtoon['img'])
                else:
                    print("ERROR: 해당 웹툰의 검색 결과가 없습니다.")
            else:
                print("API 요청에 실패했습니다. 상태 코드:", response.status_code)
    
        user_Recom_list = {genre: 0 for genre in Genre_list}
        # MongoDB 연결
        client = MongoClient('localhost', 27017)
        db = client['fsdb_naver']
        for user in user_list:
            for genre_index in range(len(Genre_list)):
                collections = db['Genre_{0}'.format(Genre_list[genre_index])]
                for collection in collections.find():
                    if (collection.get('title', '') == user):
                        user_Recom_list[collection.get('genre', '')] += 1
        client.close()
        return user_Recom_list, user_sub_list


# 제공해야하는 것:  썸네일 이미지, 웹툰 플랫폼, 웹툰 제공 위치, 작가, 컨텐츠 사용자 구독 여부

user = Firebase_User_Base_INFO('sub_ts')
user_recommendations_weight, user_sub_info = user.create_user_base_recommendations()
print("user interesting table               : ", user_recommendations_weight)
print("\n\n\n")
print("user subscrible content basic INFO   : ",user_sub_info)





# 1. 접속한 유저 확인
# 2. 유저에 대한 subscribe 목록확인
# 3. subscribe 목록에 대해서 추천 목록 설정

# import firebase_admin
# from firebase_admin import credentials
# from firebase_admin import firestore
# from pymongo import MongoClient

# Genre_list = ['PURE', 'FANTASY', 'ACTION', 'DAILY', 'THRILL', 'COMIC', 'HISTORICAL', 'DRAMA',
#               'SENSIBILITY', 'SPORTS']

# # MongoDB 연결
# client = MongoClient('localhost', 27017)
# db_mongo = client['fsdb_naver']

# # Firestore에서 유저 목록 가져오기
# docs = db_firestore.collection('users').get()
# for doc in docs:
#     user_data = doc.to_dict()

#     # 유저의 subscribe 목록 확인
#     subscribe_list = user_data.get('subscribe', [])

#     # 각 subscribe에 대해 MongoDB에서 데이터 추출
#     for genre in subscribe_list:
#         genre_collection = db_mongo['Genre_{0}'.format(genre)]
#         for document in genre_collection.find():
#             print("Genre: {} Title: {}".format(genre, document.get('title')))



# 데이터 베이스 접근 방식 #

# # Firebase 서비스 계정 키 로드
# cred = credentials.Certificate("C:\\Code\\fs_project\\algorithm_serv\\fsserv_acoount_key.json")
# firebase_admin.initialize_app(cred, {'storageBucket': 'fsserv.appspot.com'})

# # Firebase Storage의 루트 참조 가져오기
# bucket = storage.bucket()

# # Firebase Storage의 파일 리스트 가져오기
# blobs = bucket.list_blobs()

# # 파일 리스트 출력
# for blob in blobs:
#     print(f"File: {blob.name}")