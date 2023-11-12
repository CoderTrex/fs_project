import pymongo

# MongoDB 연결
client = pymongo.MongoClient("mongodb://localhost:27017")  # MongoDB의 주소와 포트에 맞게 수정

# 데이터베이스 선택
db = client["fsdb_naver"]  

days = ['mons', 'tues', 'weds', 'thus', 'fris', 'sats', 'suns']
Genre = ['판타지', '먼치킨', '로멘스', '무협', '시대물', '일상물', '스릴러/호러', '개그', '스포츠', 'BL/GL']

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

        
        # if ()  // 만약 장르값이 있다면 넘어감
        if "genre" in document and document["genre"]:
            # print(f"장르가 이미 결정된 문서 {_id}입니다. 넘어갑니다.")
            print(f"Title: {title} Genre : {genre}")
            continue
            
        print("\n")
        # 사용자로부터 값을 입력 받기
        genre_value = input(
f"""Enter the genre for Webtoon name {title}:
0. 판타지​
1. 먼치킨
2. 로맨스
3. 무협
4. 시대물
5. 학원물
6. 스릴러/호러
7. 개그/일상물
8. 스포츠
9. BL/GL
: """)

        # 변경된 값 업데이트
        collection.update_one(
            {"_id": _id},  # 업데이트할 문서의 조건
            {"$set": {"genre": Genre[int(genre_value)]}}  # 업데이트할 필드와 값
        )

        print(f"장르가 비어있는 문서 {_id}에 대해 '{Genre[int(genre_value)]}'로 장르를 설정했습니다.")

# 연결 닫기
client.close()



# □ 먼치킨 
# □ 로맨스 
# □ 판타지​ 
# □ 스릴러/호러 
# □ 개그
# □ 일상물 
# □ 무협 
# □ 스포츠 
# □ 시대물 
# □ BL/GL