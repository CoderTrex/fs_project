import pymongo
import requests # api request


# MongoDB 연결
client = pymongo.MongoClient("mongodb://localhost:27017")  

# healing and Daily     webtoon prefer
healing_daily_genre = ['DAILY', 'COMIC', 'SENSIBILITY', '육아물', '음식%26요리', '4차원', '레트로', '무해한', '공감성수치', '동물']
# provocative romance   webtoon prefer
provocative_romance_genre = ['PURE', 'DRAMA', '학원로맨스', '로판', '재회', '러블리', '계약연애', '퓨전사극', '전남친', '역하렘', '집착물', '궁중로맨스', '선결혼후연애', '성별반전', '후회물', '고자극로맨스', '계략여주', '재벌', '폭스남', '연애계', '인플루언서']
# plain romance         webtoon prefer
plain_romance_genre = ['PURE', 'DRAMA', '학원로맨스', '로판', '재회', '러블리', '직진남', '친구>연인', '하이틴', '까칠남', '동아리', '소꿉친구', '짝사랑', '청춘로맨스', '다정남', '사내연애', '연상연하', '캠퍼스로맨스']
# action                webtoon prefer
action_genre = ['HISTORICAL', '슈퍼스트링', '느와르', '격투기', '범죄', '밀리터리', 'sf', '히어로', '동양풍판타지', '복수극']
# mass-produced         webtoon prefer
mass_produced_genre = ['HISTORICAL', '먼치킨', '게임판타지', '아포칼립스', '소년왕도물', '다크히어로', '이세계', '차원이동', '블루스트링', '타임슬립', '이능력배틀물', '회귀', '성장물', '헌터물']
# not mass-produced     webtoon prefer
not_mass_produced_genre = ['THRILL', 'SPORTS', '역사물', '직업드라마', '괴담', '해외작품', '음악', '축구', '감염', '서스펜스', '스포츠성장', '농구', '프리퀄', '하이퍼리얼리즘', '빙의', '오컬트',  '두뇌싸움']

Genre_model_list = [healing_daily_genre, provocative_romance_genre,
                    plain_romance_genre, action_genre,
                    mass_produced_genre, not_mass_produced_genre]

Genre_model_list_name = ['healing_daily_genre', 'provocative_romance_genre', 
                    'plain_romance_genre', 'action_genre', 
                    'mass_produced_genre', 'not_produced_genre']

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

# API 엔드포인트 URL
api_Search_url = "https://korea-webtoon-api.herokuapp.com/search"

# 데이터베이스 선택
db = client["fsdb_naver"]
for model_name, model_genre in zip(Genre_model_list_name, Genre_model_list):
    model_collection = db["model_{0}".format(model_name)]  # 해당 모델 컬렉션 생성

    # 장르 전체 요소 안에서
    for genre_ele in Genre_list:
        if genre_ele in model_genre:
            genre_collection = db["Genre_{0}".format(genre_ele)]
            documents = genre_collection.find()
            for document in documents:
                title = document["title"]
                param = {
                    "keyword" : title
                }
                response = requests.get(api_Search_url, params=param)
                if (response.status_code == 200):
                    data = response.json()
                    totalWebtoonCount = data.get("totalWebtoonCount")
                    webtoons = data.get("webtoons")
                    if (totalWebtoonCount > 0):
                        print(f"연결 및 접속 양호. 검색 결과 (총 {totalWebtoonCount} 개의 웹툰이 검색되었습니다.)")
                        for webtoon in webtoons:
                            url = webtoon["url"]
                            img = webtoon["img"]
                            author = webtoon["author"]
                            service = webtoon["service"]
                            additional = webtoon["additional"]
                        model_collection.insert_one({"title": title, "genre": genre_ele, 
                                                    "url" : url, "author" : author, 
                                                    "service" : service, "additional" : additional})
                    else:
                        print("ERROR: 해당 웹툰의 검색 결과가 없습니다.")
                else:
                    print("API 요청에 실패했습니다. 상태 코드:", response.status_code)