

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


# firebase 라이브러리 import
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
# mongoDB 라이브러리 import
from pymongo import MongoClient


Genre_list = ['PURE', 'FANTASY', 'ACTION', 'DAILY', 'THRILL', 'COMIC', 'HISTORICAL', 'DRAMA',
        'SENSIBILITY', 'SPORTS'] 

cred = credentials.Certificate("C:\\Code\\fs_project\\algorithm_serv\\fsserv_acoount_key.json")
firebase_admin.initialize_app(cred)

db = firestore.client()
print(db)   

docs = db.collection('sub_ts').get()
userdict = {}  # 빈 딕셔너리 생성

for doc in docs:
    doc_data = doc.to_dict()
    sublist = doc_data.get('sublist', {})
    
    # sublist에서 필요한 정보 추출
    title = sublist.get('title', '')
    platform = sublist.get('platform', '')
    sub_id = doc_data.get('id', '')

    # userdict에 title이 이미 있는지 확인하고 없으면 빈 리스트로 초기화
    if title not in userdict:
        userdict[title] = []

    # 값을 추가
    userdict[title].append(platform)

print(userdict)


# 1. 접속한 유저 확인
# 2. 유저에 대한 subscribe 목록확인
# 3. subscribe 목록에 대해서 추천 목록 설정





# client = MongoClient('localhost', 27017)
# db = client['fsdb_naver']  # 사용할 데이터베이스의 이름 입력
# for genre_index in range(len(Genre_list)):
#     collections = db['Genre_{0}'.format(Genre_list[genre_index])]  # 사용할 컬렉션 이름 입력
#     for collection in collections.find():
#         print("Genre: {} title : {}".format(Genre_list[genre_index], collection))





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
