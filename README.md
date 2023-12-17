# 프로젝트명 README

## 소개
이 프로젝트는 [프로젝트명]에 관한 소스 코드 및 실행 파일들을 포함하고 있습니다. 각 폴더와 파일은 다음과 같은 역할을 수행합니다.

### 1. `check_project`
이 폴더는 레포지토리에 있는 파일들의 코드 수와 같은 정량적인 정보를 담은 파일입니다. 프로젝트의 규모와 성격을 빠르게 파악할 수 있도록 도움을 주는 결과물들이 여기에 있습니다.

### 2. `node_modules`
`node_modules` 폴더는 로컬 MongoDB에 웹툰 정보를 저장하는 실행 파일들이 위치한 곳입니다. 프로젝트를 실행하기 위해서는 `node_modules`를 통해 기본적인 설정을 진행해야 합니다. 이 폴더에는 프로젝트에 필요한 외부 라이브러리 및 모듈이 저장되어 있습니다.

### 3. `project`
`project` 폴더는 클라이언트 실행 폴더로, 해당 프로그램의 개발환경은 Windows 환경의 Visual Studio Code에서 개발되었습니다. 클라이언트 측의 소스 코드와 관련된 파일들이 이 폴더에 위치합니다.

### 4. `webtoonDB`
`webtoonDB` 폴더는 `node_modules`를 통해 쌓은 데이터 위에 추가적인 알고리즘 구현을 위한 웹툰 데이터베이스를 더 쌓는 코드가 있는 곳입니다. 이 폴더에는 데이터베이스를 구축하고 관리하는데 필요한 파일들이 모여 있습니다. 모든 db 쌓는 과정을 담은 폴더 중 하나입니다. 다만, `server.py` 파일은 해당 폴더 내에서 유일한 서버 실행 파일로, Flask를 이용하여 실행됩니다.

## 프로젝트 실행
프로젝트를 실행하기 위해서는 다음 단계를 따르세요:

1. `node_modules` 폴더에서 필요한 설정을 진행하세요.
2. `webtoonDB` 폴더에서 데이터베이스와 관련된 설정을 확인하고 필요한 알고리즘을 실행하세요. 요일별, 장르별, 모델별 DB가 클라이언트의 안에 구성이 되어야합니다.
    mongodb의 구조는 다음과 같습니다.
        <details>
          <summary><b>MONGODB DATABASE 구조</b></summary>
          <p align="center">
            <img src="https://github.com/CoderTrex/fs_project/assets/80687043/d2c1645e-edea-4b9e-b1e1-90391edf1dce" alt="MongoDB Database Structure">
          </p>
        </details>
        
        <details>
          <summary><b>MONGODB kakao db collection 구조</b></summary>
          <p align="center">
            <img src="https://github.com/CoderTrex/fs_project/assets/80687043/7eef8df6-10d9-4935-b0e3-cd24f0b8afcf" alt="MongoDB Kakao Collection Structure">
          </p>
        </details>
        
        <details>
          <summary><b>MONGODB kakao page db collection 구조</b></summary>
          <p align="center">
            <img src="https://github.com/CoderTrex/fs_project/assets/80687043/b15e38e2-74be-4f7e-a729-0d3eae99da8e" alt="MongoDB Kakao Page Collection Structure">
          </p>
        </details>
        
        <details>
          <summary><b>MONGODB naver db collection 구조</b></summary>
          <p align="center">
              <details>
          <summary><b>장르 예시</b></summary>
          <p align="center">
            <img src=![image](https://github.com/CoderTrex/fs_project/assets/80687043/55387771-83e1-4ae0-afd3-d6fd30891036)
 alt="Genre Example">
          </p>
        </details>
        
        <details>
          <summary><b>모델 예시</b></summary>
          <p align="center">
            <img src="https://github.com/CoderTrex/fs_project/assets/80687043/d7ceae30-22b4-43a2-aba5-d25a35f4f644" alt="Model Example">
          </p>
        </details>
        
        <details>
          <summary><b>요일 예시</b></summary>
          <p align="center">
            <img src="https://github.com/CoderTrex/fs_project/assets/80687043/49e39430-e51f-46e2-9d15-07985b7c3dae" alt="Day Example">
          </p>
        </details>
            
          </p>
        </details>


4. `project` 폴더에서 클라이언트 실행을 위한 환경을 구축하세요.

## 주의사항
- 프로젝트는 Windows 환경에서 Visual Studio Code를 사용하여 개발되었으므로, 다른 환경에서 실행 시 주의가 필요합니다.
- `server.py` 파일은 유일한 서버 실행 파일이므로, 해당 파일을 이용하여 서버를 실행하세요.

이제 프로젝트에 대한 간략한 소개와 실행 방법이 제공되었습니다. 추가적인 정보는 각 폴더와 파일에 대한 상세한 내용을 참고하세요.
