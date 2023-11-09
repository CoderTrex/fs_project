import pymongo

# MongoDB 연결
client = pymongo.MongoClient("mongodb://localhost:27017")  # MongoDB의 주소와 포트에 맞게 수정

# 데이터베이스 선택
db = client["fsdb_naver"]  


days = ['mons', 'tues', 'weds', 'thus', 'fris', 'sats', 'suns']

# 컬렉션 선택
collection = db["fris"]  

# 모든 문서 가져오기
documents = collection.find()

# 문서 출력
for document in documents:
    print(document)

# 연결 닫기
client.close()


# □ 먼치킨
# □ 로맨스 
# □ 판타지​ 
# □ 스릴러/호러 
# □ 개그
# □ 일상물 
# □ SF 
# □ 무협 
# □ 스포츠 
# □ 시대물 
# □ BL/GL