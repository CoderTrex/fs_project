
# firebase 라이브러리 import
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import db


# mongoDB 라이브러리 import
from pymongo import MongoClient

# api request
import requests

# API 엔드포인트 URL
api_Search_url = "https://korea-webtoon-api.herokuapp.com/search"

Genre_list = [
                'PURE', 'FANTASY', 'ACTION', 'DAILY', 'THRILL', 'COMIC', 'HISTORICAL', 'DRAMA',
                'SENSIBILITY', 'SPORTS', "먼치킨", "학원로맨스", "로판", "재회", "슈퍼스트링", "육아물", 
                "역사물", "게임판타지", "직업드라마", "괴담", "러블리", "해외작품", "계약연애", 
                "음악", "느와르", "직진남",  "축구", "친구>연인", "아포칼립스", "퓨전사극", "격투기", "범죄", "음식%26요리"
                "전남친", "소년왕도물", "다크히어로", "감염", "이세계", "하이틴", "소꿉친구", "역하렘", "까칠남", 
                "4차원", "서스펜스", "집착물", "짝사랑", "차원이동", "궁중로맨스", "레트로",  "블루스트링", "타임슬립",
                "스포츠성장", "무해한", "농구", "청춘로멘스", "프리퀄", "이능력배틀물", "밀리터리", "선결혼후연애",  
                "다정남", "공감성수치", "성별반전", "회귀", "후회물", "사내연애", "고자극로맨스", "sf", "연상연하", 
                "하이퍼리얼리즘", "히어로", "동양풍판타지", "성장물", "계략여주", "재벌", "동물", "캠퍼스로맨스", 
                "동아리", "빙의", "폭스남", "오컬트", "연예계", "두뇌싸움", "복수극", "헌터물", "인플루언서", 
        ]

class Firebase_User_Base_INFO:
    def __init__(self, collection_name):
        # Firebase database 인증 및 앱 초기화
        cred = credentials.Certificate("C:\\Code\\fs_project\\webtoonDB\\algorithm_serv\\chatting_acoount_key.json")
        firebase_admin.initialize_app(cred, {
            'databaseURL': "https://chatting-test-863cb-default-rtdb.asia-southeast1.firebasedatabase.app"
        })
        # 컬렉션 이름 설정
        self.collection_name = collection_name
        self.db = db.reference(self.collection_name)

    def create_user_base_recommendations(self):
        ref = self.db
        docs = ref.get()
        userdict = {}

        for uid, user_data in docs.items():
            u_sublist = user_data.get('sublist', [])
            for index, title in enumerate(u_sublist):
                if (title not in userdict and title is not None):
                    userdict[title] = []

        user_list = list(userdict.keys())
        user_sub_list = {}  # 빈 딕셔너리를 생성
        for webtoon_name in user_list:
            user_sub_list[str(webtoon_name)] = []

        for keyword in user_list:
            # API 호출을 위한 파라미터 설정
            params = {
                "keyword": keyword
            }
            response = requests.get(api_Search_url, params=params)
            # 응답 확인
            if response.status_code == 200:
                data = response.json()
                totalWebtoonCount = data.get("totalWebtoonCount")
                webtoons = data.get("webtoons")
                if totalWebtoonCount > 0:
                    print(f"연결 및 접속 양호. 검색 결과 (총 {totalWebtoonCount} 개의 웹툰이 검색되었습니다.)")
                    for webtoon in webtoons:
                        user_sub_list[webtoon['title']].append(webtoon['author'])
                        user_sub_list[webtoon['title']].append(webtoon['url'])
                        user_sub_list[webtoon['title']].append(webtoon['service'])
                        user_sub_list[webtoon['title']].append(webtoon['img'])
                else:
                    print("ERROR: 해당 웹툰의 검색 결과가 없습니다.")
            else:
                print("API 요청에 실패했습니다. 상태 코드:", response.status_code)
    
        user_Recom_list = {genre: 0 for genre in Genre_list}
        # MongoDB 연결
        client = MongoClient('localhost', 27017)
        db = client['fsdb_naver']
        for user in user_list:
            for genre_index in range(len(Genre_list)):
                collections = db['Genre_{0}'.format(Genre_list[genre_index])]
                for collection in collections.find():
                    if (collection.get('title', '') == user):
                        user_Recom_list[collection.get('genre', '')] += 1
        client.close()
        return user_Recom_list, user_sub_list

# 제공해야하는 것:  썸네일 이미지, 웹툰 플랫폼, 웹툰 제공 위치, 작가, 컨텐츠 사용자 구독 여부
user = Firebase_User_Base_INFO('usersub')
user_recommendations_weight, user_sub_info = user.create_user_base_recommendations()

# 신의 탑
# 0 "FANTASY"
# 1 "먼치킨"
# 2 "소년왕도물"

# 화산 귀환
# 0 "HISTORICAL"
# 1 "먼치킨"
# 2 "이세계"

# 전지적 독자 시점
# 0 "FANTASY"
# 1 "먼치킨"
# 2 "게임판타지"
# 3 "아포칼립스"

# --------------------------------------------------------------- #
# ----------------- 해당 과정까지 진행완료된 목록 ----------------- #
# --- user_recommendations_weight(유저가 좋아하는 목록의 가중치) -- #
# --------------- user_sub_info(유저가 구독한 목록)--------------- #
# --------------------------------------------------------------- #

# print("user interesting table               : ", user_recommendations_weight)
# print("\n\n\n")
# print("user subscrible content basic INFO   : ",user_sub_info)


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

# 모델 리스트
models = {
    'healing_daily': healing_daily_genre,
    'provocative_romance': provocative_romance_genre,
    'plain_romance': plain_romance_genre,
    'action': action_genre,
    'mass_produced': mass_produced_genre,
    'not_produced': not_mass_produced_genre
}

# 모델별 선호도 계산
model_scores = {}
for model_name, model_genre in models.items():
    # 기존에 없는 키에 대해 기본값 0을 사용하도록 get 메서드 활용
    score = sum(user_recommendations_weight.get(genre, 0) for genre in model_genre)
    model_scores[model_name] = score

# 가장 높은 선호도를 가진 모델 선택
selected_model = max(model_scores, key=model_scores.get)

# 각 모델의 선호도 출력
for model, score in model_scores.items():
    print(f"{model}: {score}")

print(f"The recommended model for the user is: {selected_model}")