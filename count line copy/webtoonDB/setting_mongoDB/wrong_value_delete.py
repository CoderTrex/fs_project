# ----------------------------------------- #
# ----------- 잘못된 값 제거 코드----------- #
# ----------------------------------------- #

from pymongo import MongoClient

# MongoDB 연결 정보

database_name = "fsdb_naver"

# MongoDB 클라이언트 생성
client = MongoClient('localhost', 27017)

# 데이터베이스 및 컬렉션 선택
db = client[database_name]

Genre_model_list_name = ['healing_daily_genre', 'provocative_romance_genre', 
                    'plain_romance_genre', 'action_genre', 
                    'mass_produced_genre', 'not_produced_genre']
for name in Genre_model_list_name:
    collection = db["model_{}".format(name)]  # 'model_{}'에는 적절한 값이 들어가야 합니다.
    # 삭제할 문서의 조건
    delete_condition = {
        "url": {"$exists": False},
        "author": {"$exists": False}
    }

    # 조건에 맞는 문서 삭제
    result = collection.delete_many(delete_condition)

    # 삭제된 문서의 개수 출력
    print(f"Deleted {result.deleted_count} documents.")