# Python 개발 환경 Docker 프로젝트

이 프로젝트는 Ubuntu 24.04 LTS 기반의 Docker 컨테이너를 사용해 빠르게 Python 개발 환경을 구축합니다. JupyterLab, 한국어 로케일, 나눔폰트/D2Coding 폰트, ffmpeg, OpenCV 등을 포함하며, Windows와의 볼륨 연결을 지원합니다.

## 특징
- **OS**: Ubuntu 24.04 LTS
- **Python**: 3.12 (pyenv로 설치)
- **로케일**: 한국어 (ko_KR.UTF-8)
- **폰트**: 나눔폰트, D2Coding
- **도구**: ffmpeg, OpenCV, JupyterLab
- **포트**: 8888 (JupyterLab)
- **볼륨**: Windows `%USERPROFILE%\workspace`와 `/root/workspace` 연결
- **토큰 비활성화**: JupyterLab에 누구나 접속 가능 (로컬용)

## 요구사항
- Docker
- Docker Compose

## 설치 및 실행

### 1. 저장소 클론
```bash
git clone https://github.com/epocheing/docker.git
cd https://github.com/epocheing/docker.git
```

### 2. 환경 설정
- Windows 사용자는 `%USERPROFILE%\workspace` 폴더를 미리 생성하세요. 이 폴더가 컨테이너의 `/root/workspace`와 동기화됩니다.

### 3. 컨테이너 빌드 및 실행
```bash
docker-compose up --build -d
```
- `--build`: 이미지를 새로 빌드합니다.
- `-d`: 백그라운드에서 실행합니다.

### 4. JupyterLab 접속
- 브라우저에서 `http://localhost:8888`로 접속하세요.
- 토큰이나 비밀번호 없이 바로 사용 가능합니다.

### 5. 컨테이너 중지
```bash
docker-compose down
```

## 주요 파일
- **`Dockerfile`**: 컨테이너 이미지 빌드 설정
- **`docker-compose.yml`**: 서비스 정의 및 런타임 설정

### Dockerfile 주요 내용
- Ubuntu 24.04 기반
- pyenv로 Python 3.12 설치
- 한국어 로케일 설정
- 나눔폰트와 D2Coding 폰트 설치
- ffmpeg, OpenCV, JupyterLab 설치

### docker-compose.yml 주요 설정
```yaml
services:
  dev-env:
    build: .
    ports:
      - "8888:8888"
    volumes:
      - "${USERPROFILE}/workspace:/root/workspace"
    command: >
      /bin/bash -c "source ~/.bashrc && jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''"
```

## 문제 해결
- **포트 충돌**: `8888` 포트가 이미 사용 중이라면, `docker ps`로 확인 후 중복 컨테이너를 중지하세요:
  ```bash
  docker stop <container-id>
  ```
- **빌드 오류**: 로그를 확인하세요:
  ```bash
  docker-compose logs
  ```

## 주의사항
- **보안**: 토큰과 비밀번호가 비활성화되어 있으므로, 로컬 환경에서만 사용하세요. 공용 네트워크에서는 보안을 위해 토큰 설정을 복원하는 것이 좋습니다.
- **데이터**: `/root/workspace`는 호스트의 `workspace` 폴더와 연결되므로, 중요한 파일은 백업하세요.
