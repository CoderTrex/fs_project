import pymongo
import time
# MongoDB 연결
client = pymongo.MongoClient("mongodb://localhost:27017")  # MongoDB의 주소와 포트에 맞게 수정

# 데이터베이스 선택
db = client["fsdb_naver"]  

days = ['mons', 'tues', 'weds', 'thus', 'fris', 'sats', 'suns']
Genre_list = ['PURE', 'FANTASY', 'ACTION', 'DAILY', 'THRILL', 'COMIC', 'HISTORICAL', 'DRAMA',
        'SENSIBILITY', 'SPORTS', "먼치킨", "학원로맨스", "로판", "재회", "현실로맨스", "슈퍼스트링", 
        "육아물", "역사물", "게임판타지", "직업드라마", "괴담", "범죄", "러블리", "해외작품", "음악",
        "느와르", "직진남", "아포칼립스", "퓨전사극", "격투기", "범죄", "전남친", "소년왕도물", 
        "다크히어로", "감염", "이세계", "4차원", "서스펜스", "집착물", "짝사랑", "차원이동", "궁중로맨스", 
        "레트로"]


# 각 컬렉션의 문서에 대해 작업
for day in days:
    # 컬렉션 선택
    collection = db[day]

    # 모든 문서 가져오기
    documents = collection.find()

    # 문서 출력 및 값 입력
    for document in documents:
        _id = document["_id"]
        webtoon_id = document["webtoonId"]
        title = document["title"]
        img_url = document["img"]
        genre = document["genre"]

        # # 만약 장르값이 있다면 넘어감
        # if "genre" in document and document["genre"]:
        #     print(f"장르가 이미 결정된 문서 {title}입니다. 넘어갑니다.")
        #     # print(f"Title: {title} Genre : {genre}")
        #     continue
        # else:
        #     print(f"장르가 입력되지 않은 문서 {title}입니다. 넘어갑니다.")
        
        append_genre_list = []
        
        for genre_element in Genre_list:
            genre_collection = db["Genre_{0}".format(genre_element)]
            genre_documents = genre_collection.find()
            for genre_document in genre_documents:
                genre_title = genre_document['title']
                if (title == genre_title):
                    append_genre_list.append(genre_element)
                    break

        # print(title, append_genre_list)
        # 변경된 값 업데이트
        collection.update_one(
            {"_id": _id},  # 업데이트할 문서의 조건
            {"$set": {"genre": append_genre_list}}  # 업데이트할 필드와 값
        )
        
        # time.sleep(5)

        # print(f"장르가 비어있는 문서 {_id}에 대해 '{append_genre_list}'로 장르를 설정했습니다.") 

# 연결 닫기
client.close()
