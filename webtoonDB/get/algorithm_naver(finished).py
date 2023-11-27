import pymongo
import time
# MongoDB 연결
client = pymongo.MongoClient("mongodb://localhost:27017")  # MongoDB의 주소와 포트에 맞게 수정

# 데이터베이스 선택
db = client["fsdb_naver"]  

days = ['mons', 'tues', 'weds', 'thus', 'fris', 'sats', 'suns']
Genre_list = ['PURE', 'FANTASY', 'ACTION', 'DAILY', 'THRILL', 'COMIC', 'HISTORICAL', 'DRAMA',
        'SENSIBILITY', 'SPORTS'"먼치킨", "학원로맨스", "로판", "게임판타지", "재회", "현실로맨스", "슈퍼스트링", "육아물", "역사물",
    "직업드라마", "괴담", "러블리", "해외작품", "음악", "느와르", "직진남",  "축구", "친구>연인", 
    "아포칼립스", "퓨전사극", "격투기", "범죄", "전남친", "소년왕도물", "다크히어로", "감염", "이세계", 
    "4차원", "서스펜스", "집착물", "짝사랑", "차원이동", "궁중로맨스", "레트로",  "블루스트링", "타임슬립", 
    "스포츠성장", "무해한", "농구", "청춘로멘스", "프리퀄", "이능력배틀물", "밀리터리", "선결혼후연애",  
    "다정남", "공감성수치", "성별반전", "회귀", "후회물", "사내연애", "고자극로맨스", "sf", "연상연하", 
    "하이퍼리얼리즘", "히어로", "동양풍판타지", "성장물", "계략여주", "재벌", "동물", "캠퍼스로맨스", 
    "동아리", "빙의", "폭스남", "오컬트", "연예계", "두뇌싸움", "복수극", "헌터물", "인플루언서", 
    "하이틴", "소꿉친구", "역하렘", "까칠남", "계약연애", "음식%26요리"]

collection = db['finisheds']

# 모든 문서 가져오기
documents = collection.find()

# 문서 출력 및 값 입력
for document in documents:
    _id = document["_id"]
    webtoon_id = document["webtoonId"]
    title = document["title"]
    img_url = document["img"]
    genre = document["genre"]
    
    append_genre_list = []
    
    for genre_element in Genre_list:
        genre_collection = db["Genre_{0}".format(genre_element)]
        genre_documents = genre_collection.find()
        for genre_document in genre_documents:
            genre_title = genre_document['title']
            if (title == genre_title):
                append_genre_list.append(genre_element)
                break

    # 변경된 값 업데이트
    collection.update_one(
        {"_id": _id},  # 업데이트할 문서의 조건
        {"$set": {"genre": append_genre_list}}  # 업데이트할 필드와 값
    )
    
# 연결 닫기
client.close()
