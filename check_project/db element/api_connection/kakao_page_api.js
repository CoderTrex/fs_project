const mongoose = require('mongoose');
const axios = require('axios');

const days = {
  0: 'mon',
  1: 'tue',
  2: 'wed',
  3: 'thu',
  4: 'fri',
  5: 'sat',
  6: 'sun',
}

// MongoDB에 한 번 연결
mongoose.connect('mongodb://localhost:27017/fsdb_kakaopage', { useNewUrlParser: true, useUnifiedTopology: true });
const db = mongoose.connection;

db.on('error', console.error.bind(console, 'MongoDB 연결 오류:'));

db.once('open', () => {
  console.log('MongoDB에 연결되었습니다.');
  
  // 루프를 사용하여 요일별로 컬렉션을 생성
  for (let i = 0; i < 7; i++) {
    const collectionName = days[i];
    
    const DayModel = mongoose.model(collectionName, new mongoose.Schema({
      webtoonId: Number, // webtoonId 필드 추가
      page: Number, // 페이지 번호
      service: String, // 웹툰 공급자 (naver, kakao, kakaoPage)
      title: String,
      url: String,
      updateDay: String, // 웹툰 업데이트 구분
      img: String,
      author: String,
      service: String,
    }));
    
    // API 요청
    const baseURL = 'https://korea-webtoon-api.herokuproject.com';
    const params = {
      page: 0, // 페이지 번호
      perPage: 100, // 한 페이지 결과 수
      service: 'kakaoPage', // 웹툰 공급자 (naver, kakao, kakaoPage)
      updateDay: days[i], // 해당 요일에 대한 웹툰 업데이트 구분
    };
    
    axios.get(baseURL, { params })
    .then(response => {
      const webtoonData = response.data;

      // 웹툰 정보를 MongoDB에 저장
      const savePromises = webtoonData.webtoons.map(webtoonInfo => {
        // 중복 데이터 확인 및 업데이트
        const query = { webtoonId: webtoonInfo.webtoonId };
          const update = { $set: webtoonInfo };
          
          return DayModel.findOneAndUpdate(query, update, { upsert: true, new: true }).exec();
        });
        
        Promise.all(savePromises)
        .then(savedWebtoons => {
          console.log('데이터가 MongoDB에 저장되었습니다:', savedWebtoons);
        })
        .catch(err => {
            console.error('데이터 저장 중 에러 발생:', err);
          });
        })
        .catch(error => {
          console.error('API 요청 중 에러 발생:', error);
        });
      }
  }
);