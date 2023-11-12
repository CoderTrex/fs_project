from flask import Flask, render_template, request
import pymongo
import threading

app = Flask(__name__)

# MongoDB 연결
client = pymongo.MongoClient("mongodb://localhost:27017")  # MongoDB의 주소와 포트에 맞게 수정

# 데이터베이스 선택
db = client["fsdb_naver"]  

days = ['mons', 'tues', 'weds', 'thus', 'fris', 'sats', 'suns']
Gerne = ['판타지', '먼치킨', '로멘스', '무협', '시대물', '일상물', '스릴러/호러', '개그', '스포츠', 'BL/GL']

def update_genre_in_background(webtoon_id, genre_value):
    for day in days:
        # 컬렉션 선택
        collection = db[day]

        # 변경된 값 업데이트
        collection.update_one(
            {"webtoonId": webtoon_id},  # 업데이트할 문서의 조건
            {"$set": {"genre": genre_value}}  # 업데이트할 필드와 값
        )

        print(f"Webtoon ID {webtoon_id}에 대해 '{genre_value}'로 장르를 설정했습니다.")

@app.route('/')
def index():
    return render_template('index.html', genres=Gerne)

@app.route('/update_genre', methods=['POST'])
def update_genre():
    webtoon_id = request.form['webtoon_id']
    genre_value = request.form['genre']

    # 백그라운드 스레드로 업데이트 실행
    background_thread = threading.Thread(target=update_genre_in_background, args=(webtoon_id, genre_value))
    background_thread.start()

    return "Success"

if __name__ == '__main__':
    app.run(debug=True)
