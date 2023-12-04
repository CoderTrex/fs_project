from flask import Flask, jsonify, request
import pymongo

class MyAPI:
    def __init__(self):
        self.app = Flask(__name__)
        self.client = pymongo.MongoClient("mongodb://localhost:27017")
        self.db_naver = self.client["fsdb_naver"]
        self.db_kakao = self.client["fsdb_kakao"]
        self.db_kakopage = self.client["fsdb_kakaopage"]
        self.platform_list = [self.db_naver, self.db_kakao, self.db_kakopage]
        self.days_naver = ['mons', 'tues', 'weds', 'thus', 'fris', 'sats', 'suns', 'finisheds']
        self.days = ['mons', 'tues', 'weds', 'thus', 'fris', 'sats', 'suns']

        # Flask 라우트 등록
        self.app.add_url_rule('/get_info', 'api_get_info', self.api_get_info, methods=['GET'])

    def get_info(self, name_title):
        result = {}
        for platform in self.platform_list:
            if platform == self.db_naver:
                for day in self.days_naver:
                    collection = platform[day]
                    documents = collection.find()
                    for document in documents:
                        if name_title == document["title"]:
                            result = {
                                "url": document["url"],
                                "img": document["img"],
                                "author": document["author"],
                                "service": document["service"]
                            }
            else:
                for day in self.days:
                    collection = platform[day]
                    documents = collection.find()
                    for document in documents:
                        if name_title == document["title"]:
                            result = {
                                "url": document["url"],
                                "img": document["img"],
                                "author": document["author"],
                                "service": document["service"]
                            }
        return result

    def api_get_info(self):
        name_title = request.args.get('title')
        result = self.get_info(name_title)
        return jsonify(result)

    def run(self):
        self.app.run(debug=True)

if __name__ == '__main__':
    my_api = MyAPI()
    my_api.run()