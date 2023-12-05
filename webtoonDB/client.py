import requests
import json

def set_content_api(email, title):
    url = "http://127.0.0.1:5000/api_set_content"
    params = {'email': email, 'title': title}
    
    try:
        response = requests.get(url, params=params)
        response.raise_for_status()  # HTTP 오류가 발생하면 예외를 던집니다.
        result = response.json()
        return result
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")
        return None

def del_content_api(email, title):
    url = "http://127.0.0.1:5000/api_del_content"
    params = {'email': email, 'title': title}
    
    try:
        response = requests.get(url, params=params)
        response.raise_for_status()  # HTTP 오류가 발생하면 예외를 던집니다.

        result = response.json()
        return result
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")
        return None

def get_recommendations_from_api(userid):
    url = "http://127.0.0.1:5000/get_recommendations"
    headers = {'Content-Type': 'application/json'}
    data = {'email': userid}
    
    try:
        response = requests.get(url, headers=headers, data=json.dumps(data))
        response.raise_for_status()  # HTTP 오류가 발생하면 예외를 던집니다.
        result = response.json()
        return result
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")
        return None



if __name__ == '__main__':
    Genre_Plain_Rommance = ["오늘은 나랑 만나", "앞집나리", "성스러운 작가생활", "작전명 순정", "아홉수 우리들",
                            "내향남녀", "유사연애", "잔인한 축제", "공복의 저녁식사", "운빨로맨스", "옆반의 인어",
                            "인간의 자격", "도와줘우주", "파리의 우리동네", "화이트멜로우", "인간졸업", 
                            "오직, 밝은 미래", "세기말 풋사과 보습학원", "빛나는 나나나나", "오로지 너를 이기고 싶어"]
    Genre_Mass_Produce = ["마도 전생기", "일타강사 백사부", "망나니 소교주로 환생했다", "절대검감",
                            "천하제일 대사형", "마도귀환록", "천화서고 대공자", "사상최강", "황제의 검",
                            "해골협객", "무한 레벨업 in 무림", "재벌집 막내아들", "왕게임", "말년용사",
                            "신입사원 강 회장", "아카데미 플레이어를 죽였다", "66666년 만에 환생한 흑마법사"
                            ]
    email_PR = "plain_romance@naver.com"
    email_MP = "mass_produce@naver.com"

    # # -------------------------------------------------------- ##
    # # -------------------------------------------------------- ##
    # # ------ 작품명을 받아서 해당 정보를 firestore에 업데이트 --- ##
    # # -------------------------------------------------------- ##
    # # -------------------------------------------------------- ##
    for title in Genre_Plain_Rommance:
        result = set_content_api(email_PR, title)
        if result:
            print("API Response: OKAY")
        else:
            print("Failed to get recommendations from API.")

    for title in Genre_Mass_Produce:
        result = set_content_api(email_MP, title)
        if result:
            print("API Response: OKAY")
        else:
            print("Failed to get recommendations from API.")

    # # -------------------------------------------------------- ##
    # # -------------------------------------------------------- ##
    # # ------ 이메일로 접근 이후 해당 작품에 대한 추천 제공 ------ ##
    # # -------------------------------------------------------- ##
    # # -------------------------------------------------------- ##
    
    
    # result_PR = get_recommendations_from_api(email_PR)
    # if result_PR:
    #     print("API Response: OKAY")
    #     print(result_PR)
    # else:
    #     print("Failed to get recommendations from API.")

    # result_MP = get_recommendations_from_api(email_MP)
    # if result_MP:
    #     print("API Response: OKAY")
    #     print(result_MP)
    # else:
    #     print("Failed to get recommendations from API.")

    # result3 = del_content_api(email, title_to_search)
    # if result3:
    #     print("API Response: OKAY")
    # else:
    #     print("Failed to get recommendations from API.")