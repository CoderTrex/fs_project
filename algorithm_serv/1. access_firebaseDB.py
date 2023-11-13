# import firebase_admin
# from firebase_admin import credentials
# from firebase_admin import db
# from firebase_admin import Log


# # firebase_admin.initialize_app(cred)

# class Database:
#     DB_URL = "https://accounts.google.com/o/oauth2/auth"
#     CRED = credentials.Certificate("database/firebase/firebase_key.json")
    
#     def __init__(self):
        
#         self._client = None
#         self._db = None

#     def connect(self):
        
#         self._client = firebase_admin.initialize_app(self.CRED, {'databaseURL':self.DB_URL})
        
#         if (self._client is None):
#             Log.d(self, "could not connect to Firebase")
#             return False

#         Log.d(self, "connect to Firebase")
#         return True 
            
#     def insert(self):
#         pass
    
#     def update(self):
#         pass
    
#     def delete(self):
#         pass
    
#     def find(self):
#         pass



import firebase_admin
from firebase_admin import credentials, storage

# Firebase 서비스 계정 키 로드
cred = credentials.Certificate("C:\\Code\\fs_project\\algorithm_serv\\fsserv_acoount_key.json")
firebase_admin.initialize_app(cred, {'storageBucket': 'fsserv.appspot.com'})

# Firebase Storage의 루트 참조 가져오기
bucket = storage.bucket()

# Firebase Storage의 파일 리스트 가져오기
blobs = bucket.list_blobs()

# 파일 리스트 출력
for blob in blobs:
    print(f"File: {blob.name}")
