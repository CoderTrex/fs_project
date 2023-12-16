# ----------------------------------------- #
# ------------- 중복 값 제거 코드----------- #
# ----------------------------------------- #

from pymongo import MongoClient

client = MongoClient('mongodb://localhost:27017/')
db = client['fsdb_naver']

genre_list = ['model_provocative_romance_genre', 'model_plain_romance_genre',
            'model_not_produced_genre', 'model_mass_produced_genre',
            'model_healing_daily_genre', 'model_action_genre']

for element in genre_list:
    collection = db[element]

    # 중복된 "title" 찾기
    pipeline = [
        {"$group": {"_id": {"title": "$title"}, "uniqueIds": {"$addToSet": "$_id"}, "count": {"$sum": 1}}},
        {"$match": {"count": {"$gt": 1}}}
    ]

    duplicates = list(collection.aggregate(pipeline))

    # 중복된 문서 삭제
    for duplicate in duplicates:
        duplicate_ids = duplicate["uniqueIds"][1:]  # 첫 번째 아이디를 제외한 나머지 아이디를 가져옴
        collection.delete_many({"_id": {"$in": duplicate_ids}})

# MongoDB 연결 해제
client.close()
