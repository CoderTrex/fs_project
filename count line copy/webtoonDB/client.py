import requests
import json


def get_content_api(email):
    url = "http://localhost:5000/api_get_content"
    param = {'email': email}
    try:
        response = requests.get(url, params=param)
        response.raise_for_status()
        result = response.json()
        # result = response
        return result
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")

def get_today_content_api(email):
    url = "http://localhost:5000/api_get_today_content"
    param = {'email': email}
    try:
        response = requests.get(url, params=param)
        response.raise_for_status()
        result1, result2 = response.json()
        # result = response
        return result1, result2
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")

def set_content_api(email, title):
    url = "http://localhost:5000/api_set_content"
    params = {'email': email, 'title': title}
    
    try:
        requests.get(url, params=params)
        # response = requests.get(url, params=params)
        # response.raise_for_status()  # HTTP 오류가 발생하면 예외를 던집니다.
        # result = response.json()
        # return result
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")
        return None

def del_content_api(email, title):
    url = "http://localhost:5000/api_del_content"
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
    url = "http://localhost:5000/api_set_recommendations"
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
                            "인간의 자격", "파리의 우리동네", "화이트멜로우", "인간졸업", 
                            "오직, 밝은 미래", "세기말 풋사과 보습학원", "오로지 너를 이기고 싶어"]
    # Genre_Plain_Rommance = ["인소의 법칙"]
    
    # Genre_Plain_Rommance = ["재혼황후", "전남편의 미친개를 길들였다", "성스러운 그대 이르시길"]
    Genre_Mass_Produce = ["일타강사 백사부", "망나니 소교주로 환생했다", "절대검감",
                            "천하제일 대사형", "마도귀환록", "천화서고 대공자", "사상최강", "황제의 검",
                            "신의 탑", "재벌집 막내아들", "왕게임", "말년용사",
                            "참교육", "66666년 만에 환생한 흑마법사"
                            ]
    
    # Genre_PVR_Romance = ["내가 죽기로 결심한 것은", "노답소녀", "중간에서 만나", "[드라마원작] 알고있지만", "여름여자 하보이",
    #                      "울어 봐, 빌어도 좋고", "버림받은 왕녀의 은밀한 침실", "남편을 죽여줘요", "포 더 퀸덤", "나랑 해요",
    #                      "팔이피플", "자매전쟁", "성스러운 작가생활", "죽었던 너와 다시 시작하기", "이츠마인", "어쩌다보니 천생연분"], 
    Genre_PVR_Romance = [
                         "[드라마원작] 알고있지만", "여름여자 하보이",
                         "울어 봐, 빌어도 좋고", "버림받은 왕녀의 은밀한 침실", "남편을 죽여줘요", "포 더 퀸덤", "나랑 해요",
                         "팔이피플", "자매전쟁", "성스러운 작가생활", "죽었던 너와 다시 시작하기", "이츠마인", "어쩌다보니 천생연분"], 
    
    # Genre_Action = ["화산귀환", "광마회귀", "나노마신", "무림서부", "헥토파스칼", "무진", "캐슬", "광장", "[드라마원작] 사냥개들",
    #                     "금붕어", "인형의 기사", "더 복서", "격투기특성화사립고교 극지고", "크라임 퍼즐", "민간인 통제구역 - 일급기밀",
    #                     "강철을 먹는 플레이어", "진주", "킬러 배드로", "비질란테", "제왕", "브레이커 : 이터널 포스", "심연의 하늘 시즌 1~3",
    #                     "묵회", "혈투", "한림체육관", "테러맨", "체탐자"]
    
    
    
    # email_PR = "romance_lover@gmail.com"
    # email_AC = "action_lover@gmail.com"
    email_MA = "mass_lover@gmail.com"
    # email_PVR = "provocation_lover@gmail.com"
    
    
    # email_MP = "mass_produce@naver.com"
    # email_MP = "jsilvercastle@gmail.com"
    # email_MP = "video_test@gmail.com"



    # # -------------------------------------------------------- ##
    # # -------------------------------------------------------- ##
    # # ------ 이메일을 통해서 해당 유저의 subscrible 목록 갱신 --- ##
    # # -------------------------------------------------------- ##
    # # -------------------------------------------------------- ##
    # result_today, result_not_today = get_content_api(email_PR)
    # print("today: {}\n\n\n\n\n\n".format(result_today), 
    #         "not today: {}\n\n\n\n\n\n".format(result_not_today))
    # result = get_content_api(email_MP)

    # result2 = get_today_content_api(email_PR)
    # print(result2)
    # result2 = get_today_content_api(email_MP)
    # print(result2)


    # # -------------------------------------------------------- ##
    # # -------------------------------------------------------- ##
    # # ------ 작품명을 받아서 해당 정보를 firestore에 업데이트 --- ##
    # # -------------------------------------------------------- ##
    # # -------------------------------------------------------- ##
    # for title in Genre_Mass_Produce:
    #     result = set_content_api(email_MA, title)
    #     if result:
    #         print("API Response: OKAY")
    #     else:
    #         print("Failed to get recommendations from API.")
    
    # for title in Genre_Action:
    #     result = set_content_api(email_AC, title)
    #     if result:
    #         print("API Response: OKAY")
    #     else:
    #         print("Failed to get recommendations from API.")
    # for title in Genre_Plain_Rommance:
    #     result = set_content_api(email_PR, title)
    #     if result:
    #         print("API Response: OKAY")
    #     else:
    #         print("Failed to get recommendations from API.")

    # for title in Genre_Mass_Produce:
    #     set_content_api(email_MP, title)
        # result = set_content_api(email_MP, title)
        # if result:
        #     print("API Response: OKAY")
        # else:
        #     print("Failed to get recommendations from API.")

    # # -------------------------------------------------------- ##
    # # -------------------------------------------------------- ##
    # # ------ 이메일로 접근 이후 해당 작품에 대한 추천 제공 ------ ##
    # # -------------------------------------------------------- ##
    # # -------------------------------------------------------- ##
    
    
    # result_PR = get_recommendations_from_api(email_PVR)
    # if result_PR:
    #     print("API Response: OKAY")
    #     print(result_PR)
    # else:
    #     print("Failed to get recommendations from API.")

    result_MP = get_recommendations_from_api(email_MA)
    if result_MP:
        print("API Response: OKAY")
        print(result_MP)
    else:
        print("Failed to get recommendations from API.")

    # result3 = del_content_api(email_PR, title_to_del)
    # if result3:
    #     print("API Response: OKAY")
    # else:
    #     print("Failed to get recommendations from API.")