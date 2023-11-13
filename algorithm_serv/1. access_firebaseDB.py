import firebase_admin
from firebase_admin import credentials, storage


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


import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore


cred = credentials.Certificate("C:\\Code\\fs_project\\algorithm_serv\\fsserv_acoount_key.json")
firebase_admin.initialize_app(cred)

db = firestore.client()
print(db)   

docs = db.collection('users').get()
for doc in docs:
    print(doc.to_dict())

1. 접속한 유저 확인
2. 유저에 대한 subscribe 목록확인
3. subscribe 목록에 대해서 추천 목록 설정
