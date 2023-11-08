import requests

# API 엔드포인트 URL
url = "https://korea-webtoon-api.herokuapp.com/search"

# 검색할 키워드 입력
keyword = input("검색할 웹툰 키워드를 입력하세요: ")

# API 호출을 위한 파라미터 설정
params = {
    "keyword": keyword
}

# API 요청 보내기
response = requests.get(url, params=params)

# 응답 확인
if response.status_code == 200:
    data = response.json()
    totalWebtoonCount = data.get("totalWebtoonCount")
    webtoons = data.get("webtoons")

    if totalWebtoonCount > 0:
        print(f"검색 결과 (총 {totalWebtoonCount} 개의 웹툰)")
        for webtoon in webtoons:
            print(f"제목: {webtoon['title']}")
            print(f"작가: {webtoon['author']}")
            print(f"서비스: {webtoon['service']}")
            print(f"URL: {webtoon['url']}")
            print()

    else:
        print("검색 결과가 없습니다.")

else:
    print("API 요청에 실패했습니다. 상태 코드:", response.status_code)
