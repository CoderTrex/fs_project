const axios = require('axios');

const apiUrl = 'https://korea-webtoon-api.herokuproject.com';

const requestParams = {
  page: 1,        // 페이지 번호
  perPage: 10,    // 한 페이지 결과 수
  service: 'kakao', // 웹툰 공급자
  updateDay: 'sun', // 웹툰 업데이트 구분 (일요일 업데이트)
};

axios.get(apiUrl, { params: requestParams })
  .then(response => {
    const data = response.data;
    
    console.log(`Total Webtoon Count: ${data.totalWebtoonCount}`);
    console.log(`Naver Webtoon Count: ${data.naverWebtoonCount}`);
    console.log(`Kakao Webtoon Count: ${data.kakaoWebtoonCount}`);
    console.log(`Last Update: ${data.lastUpdate}`);
    
    if (data.webtoons && data.webtoons.length > 0) {
      console.log('\nWebtoons:');
      data.webtoons.forEach(webtoon => {
        console.log('---');
        console.log(`Title: ${webtoon.title}`);
        console.log(`Author: ${webtoon.author}`);
        console.log(`URL: ${webtoon.url}`);
        console.log(`Image: ${webtoon.img}`);
        console.log(`Service: ${webtoon.service}`);
        console.log(`Update Days: ${webtoon.updateDays.join(', ')}`);
        console.log(`Search Keyword: ${webtoon.searchKeyword}`);
        console.log(`Additional Info:`);
        console.log(`  - New: ${webtoon.additional.new}`);
        console.log(`  - Rest: ${webtoon.additional.rest}`);
        console.log(`  - Up: ${webtoon.additional.up}`);
        console.log(`  - Adult: ${webtoon.additional.adult}`);
      });
    }
  })
  .catch(error => {
    console.error('Error:', error);
  });
