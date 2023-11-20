

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

class FirebaseSubTs:
    def __init__(self, collection_name):
        # Firebase 초기화
        cred = credentials.Certificate("C:\\Code\\fs_project\\algorithm_serv\\fsserv_acoount_key.json")
        firebase_admin.initialize_app(cred)
        self.db = firestore.client()

        # 컬렉션 이름 설정
        self.collection_name = collection_name

    def create_user_recommendations(self):
        docs = self.db.collection(self.collection_name).get()
        userdict = {}
        user_list_imgae = {}


        for doc in docs:
            doc_data = doc.to_dict()
            sublist = doc_data.get('sublist', {})
            
            # sublist에서 필요한 정보 추출
            title = sublist.get('title', '')
            platform = sublist.get('platform', '')

            # userdict에 title이 이미 있는지 확인하고 없으면 빈 리스트로 초기화
            if title not in userdict:
                userdict[title] = []

        user_list = list(userdict.keys())

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
                    print(f"검색 결과 (총 {totalWebtoonCount} 개의 웹툰)")
                    for webtoon in webtoons:
                        print(f"제목: {webtoon['title']}")
                        print(f"작가: {webtoon['author']}")
                        print(f"서비스: {webtoon['service']}")
                        print(f"URL: {webtoon['url']}")
                        print(f"이미지 URL: {webtoon['img']}")
                        url_webtoon =  webtoon['url']
                        print()
                else:
                    print("검색 결과가 없습니다.")
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
        return user_Recom_list, userdict


# 제공해야하는 것, 이미지, 플랫폼, 컨텐츠 확인 여부



# 예제 사용
firebase_sub_ts = FirebaseSubTs('sub_ts')
user_recommendations, user_sub = firebase_sub_ts.create_user_recommendations()
print(user_recommendations, user_sub)



















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