# firebase 라이브러리 import
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import db

from bson import ObjectId
from random import sample
import random
import json
from pymongo import MongoClient
import requests

# healing and Daily     webtoon prefer
healing_daily_genre = ['DAILY', 'COMIC', 'SENSIBILITY', '육아물', '음식%26요리', '4차원', '레트로', '무해한', '공감성수치', '동물']
healing_daily_genre_len = 473

# provocative romance   webtoon prefer 
provocative_romance_genre = ['PURE', 'DRAMA', '학원로맨스', '로판', '재회', '러블리', '계약연애', '퓨전사극', '전남친', '역하렘', '집착물', '궁중로맨스', '선결혼후연애', '성별반전', '후회물', '고자극로맨스', '계략여주', '재벌', '폭스남', '연애계', '인플루언서']
provocative_romance_genre_len = 1285

# plain romance         webtoon prefer
plain_romance_genre = ['PURE', 'DRAMA', '학원로맨스', '로판', '재회', '러블리', '직진남', '친구>연인', '하이틴', '까칠남', '동아리', '소꿉친구', '짝사랑', '청춘로맨스', '다정남', '사내연애', '연상연하', '캠퍼스로맨스']
plain_romance_genre_len = 1275

# action                webtoon prefer
action_genre = ['HISTORICAL', '슈퍼스트링', '느와르', '격투기', '범죄', '밀리터리', 'sf', '히어로', '동양풍판타지', '복수극']
action_genre_len = 210

# mass-produced         webtoon prefer
mass_produced_genre = ['HISTORICAL', '먼치킨', '게임판타지', '아포칼립스', '소년왕도물', '다크히어로', '이세계', '차원이동', '블루스트링', '타임슬립', '이능력배틀물', '회귀', '성장물', '헌터물']
mass_produced_genre_len = 316


# not mass-produced     webtoon prefer
not_mass_produced_genre = ['THRILL', 'SPORTS', '역사물', '직업드라마', '괴담', '해외작품', '음악', '축구', '감염', '서스펜스', '스포츠성장', '농구', '프리퀄', '하이퍼리얼리즘', '빙의', '오컬트',  '두뇌싸움']
not_mass_produced_genre_len = 466

Genre_list = [
                'PURE', 'FANTASY', 'ACTION', 'DAILY', 'THRILL', 'COMIC', 'HISTORICAL', 'DRAMA',
                'SENSIBILITY', 'SPORTS', "먼치킨", "학원로맨스", "로판", "재회", "슈퍼스트링", "육아물", 
                "역사물", "게임판타지", "직업드라마", "괴담", "러블리", "해외작품", "계약연애", "음식%26요리"
                "음악", "느와르", "직진남",  "축구", "친구>연인", "아포칼립스", "퓨전사극", "격투기", "범죄", 
                "전남친", "소년왕도물", "다크히어로", "감염", "이세계", "하이틴", "소꿉친구", "역하렘", "까칠남", 
                "4차원", "서스펜스", "집착물", "짝사랑", "차원이동", "궁중로맨스", "레트로",  "블루스트링", "타임슬립",
                "스포츠성장", "무해한", "농구", "청춘로멘스", "프리퀄", "이능력배틀물", "밀리터리", "선결혼후연애",  
                "다정남", "공감성수치", "성별반전", "회귀", "후회물", "사내연애", "고자극로맨스", "sf", "연상연하", 
                "하이퍼리얼리즘", "히어로", "동양풍판타지", "성장물", "계략여주", "재벌", "동물", "캠퍼스로맨스", 
                "동아리", "빙의", "폭스남", "오컬트", "연예계", "두뇌싸움", "복수극", "헌터물", "인플루언서", 
            ]

# 모델 리스트
models = {
    'healing_daily_genre': healing_daily_genre,
    'provocative_romance_genre': provocative_romance_genre,
    'plain_romance_genre': plain_romance_genre,
    'action_genre': action_genre,
    'mass_produced_genre': mass_produced_genre,
    'not_produced_genre': not_mass_produced_genre
}


from google.cloud import firestore
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore



class Firebase_User_Base_INFO:
    def __init__(self, userid):
        # Firebase database 인증 및 앱 초기화
        cred = credentials.Certificate("C:\\Code\\fs_project\\webtoonDB\\algorithm_server\\chatting_account_key.json")
        firebase_admin.initialize_app(cred, {
            'projectId': "chatting-test-863cb"
        })
        db = firestore.client()
        # 'databaseURL': "https://chatting-test-863cb-default-rtdb.asia-southeast1.firebasedatabase.app"
        # 컬렉션 이름 설정
        self.collection_name = userid
        self.db = db.collection(self.collection_name)

    def create_user_base_recommendations(self):
        user_subscrible_list = []
        documents = self.db.get()
        for _title in documents:
            title = _title
            print(title)
            if (title not in user_subscrible_list and title is not None):
                user_subscrible_list.append(title)    
        user_Recom_list = {genre: 0 for genre in Genre_list}
        # # MongoDB 연결
        client = MongoClient('localhost', 27017)
        db = client['fsdb_naver']
        for title in user_subscrible_list:
            for genre_index in range(len(Genre_list)):
                collections = db['Genre_{0}'.format(Genre_list[genre_index])]
                for collection in collections.find():
                    if (collection.get('title', '') == title):
                        user_Recom_list[collection.get('genre', '')] += 1
        client.close()
        return user_Recom_list

class ModelPreferenceCalculator:
    def __init__(self, user_recommendations_weight, models, mongodb_client):
        self.user_recommendations_weight = user_recommendations_weight
        self.models = models
        self.model_scores = {}
        self.mongodb_client = mongodb_client
        self.selected_model = None

    def calculate_model_preferences(self):
        for model_name, model_genre in self.models.items():
            # 기존에 없는 키에 대해 기본값 0을 사용하도록 get 메서드 활용
            score = sum(self.user_recommendations_weight.get(genre, 0) for genre in model_genre)
            self.model_scores[model_name] = score

    def get_selected_model(self):
        # 가장 높은 선호도를 가진 모델 선택
        self.selected_model = max(self.model_scores, key=self.model_scores.get)
        return self.selected_model

    def get_random_recommended_works(self, collection_name, num_works=100):
        collection = self.mongodb_client['fsdb_naver'][collection_name]
        total_document = collection.count_documents({})
        
        if total_document <= 0 or num_works <= 0:
            print("ERROR: Wrong range in Search Random Recommendation Contents")
            return []
        
        random_indices = random.sample(range(total_document), min(num_works, total_document))
        random_documents = list(collection.find().limit(num_works).skip(random_indices[0]))
        
        return random_documents

    def save_results_to_json(self, filename):
        def custom_encoder(obj):
            if isinstance(obj, ObjectId):
                return str(obj)
            raise TypeError(f"Object of type {obj.__class__.__name__} is not JSON serializable")

        results = {
            "SelectedModel": self.get_selected_model(),
            "RandomRecommendedWorks": self.get_random_recommended_works(f'model_{self.selected_model}', num_works=100)
        }

        with open(filename, 'w') as json_file:
            json.dump(results, json_file, indent=2, default=custom_encoder)
    

mongodb_client = MongoClient('localhost', 27017)

from flask import Flask, request, jsonify

app = Flask(__name__)

def convert_to_json_serializable(obj):
    if isinstance(obj, ObjectId):
        return str(obj)
    raise TypeError(f"Object of type {obj.__class__.__name__} is not JSON serializable")

# 기존 코드를 Flask API로 변환
@app.route('/get_recommendations', methods=['GET'])
def get_recommendations():
    try:
        # 사용자 ID 받기
        user_id = request.json.get('userid')

        # Firebase_User_Base_INFO 인스턴스 생성
        user = Firebase_User_Base_INFO(user_id)
            
        user_recommendations_weight = user.create_user_base_recommendations()
        # ModelPreferenceCalculator 인스턴스 생성
        model_preference_calculator = ModelPreferenceCalculator(user_recommendations_weight, models, mongodb_client)
        model_preference_calculator.calculate_model_preferences()
        selected_model = model_preference_calculator.get_selected_model()
        random_recommended_works = model_preference_calculator.get_random_recommended_works(f'model_{selected_model}', num_works=100)

        # 결과를 JSON 형식으로 반환
        result = {
            "SelectedModel": (selected_model),
            "RandomRecommendedWorks": random_recommended_works
        }
            # JSON 직렬화 시도
        try:
            json_result = json.dumps(result, default=convert_to_json_serializable, ensure_ascii=False)
        except Exception as e:
            print(f"Error: {e}")
        return jsonify(json_result)

    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == '__main__':
    app.run(debug=True)