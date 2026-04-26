# Docker-AIO-builder-Image

Ubuntu 기반의 올인원 빌드용 Docker 이미지입니다. 여러 언어와 패키지 매니저가 필요한 CI, 로컬 빌드, 임시 개발 컨테이너 환경에서 바로 사용할 수 있도록 기본 빌드 도구와 런타임 설치 과정을 포함합니다.

## 포함 구성

- Base image: `ubuntu:latest`
- APT 기본 도구: `curl`, `git`, `gnupg`, `unzip`, `xz-utils`, `build-essential`, `pkg-config`
- 언어/빌드 도구: `cargo`, `golang`, `python3`, `python3-dev`
- Android 빌드 도구:
  - `openjdk-17-jdk`
  - Android SDK Command-line Tools (`sdkmanager`)
  - `platform-tools`
  - `build-tools;35.0.0`
  - `platforms;android-35`
- Flutter 빌드 도구:
  - Flutter SDK (`stable` 브랜치)
  - Dart SDK (Flutter 포함)
- 추가 런타임 설치:
  - `uv`
  - `uv python install --default`
  - `Volta`
  - 최신 `node`
  - `bun`
- `rustup`
- Android 환경 변수:
  - `ANDROID_SDK_ROOT=/opt/android-sdk`
  - `ANDROID_HOME=/opt/android-sdk`
- Flutter 환경 변수:
  - `FLUTTER_HOME=/opt/flutter`
- 기본 작업 디렉터리: `/workspace`

## 이미지 빌드

기본 미러는 `https://mirror.xeon.kr`입니다.

```bash
docker build -t docker-aio-builder-image .
```

다른 Ubuntu 미러를 사용하려면 `MIRROR` build arg를 지정합니다.

```bash
docker build \
  --build-arg MIRROR=https://archive.ubuntu.com \
  -t docker-aio-builder-image .
```

## 컨테이너 실행

현재 프로젝트를 `/workspace`에 마운트해서 실행합니다.

```bash
docker run --rm -it \
  -v "$PWD:/workspace" \
  docker-aio-builder-image
```

Windows PowerShell에서는 다음처럼 실행할 수 있습니다.

```powershell
docker run --rm -it `
  -v "${PWD}:/workspace" `
  docker-aio-builder-image
```

특정 명령만 실행할 수도 있습니다.

```bash
docker run --rm -it docker-aio-builder-image node --version
docker run --rm -it docker-aio-builder-image python --version
docker run --rm -it docker-aio-builder-image bun --version
docker run --rm -it docker-aio-builder-image cargo --version
docker run --rm -it docker-aio-builder-image sdkmanager --version
docker run --rm -it docker-aio-builder-image flutter --version
```

## 동작 방식

`Dockerfile`은 Ubuntu 패키지 설치 후 `docker/init.sh`를 실행해 `uv`, `Volta`, `Node.js`, `Bun`, `Rust` 환경을 구성합니다.

컨테이너 시작 시 `docker/entrypoint.sh`가 실행되며 다음 작업을 수행합니다.

- `/etc/environment`가 있으면 환경 변수를 로드합니다.
- `VOLTA_HOME`을 기본값으로 설정합니다.
- `Volta` 경로를 `PATH`에 추가합니다.
- `/etc/profile.d/volta.sh`와 `~/.bashrc`를 로드합니다.
- 전달된 명령을 실행합니다.

이 과정 때문에 `bash`가 아닌 명령을 바로 실행해도 Volta 기반 Node.js 경로가 적용됩니다.

## 파일 구조

```text
.
├── Dockerfile
├── README.md
├── LICENSE
├── .dockerignore
└── docker
    ├── entrypoint.sh
    └── init.sh
```

## 커스터마이징

APT 패키지를 추가하려면 `Dockerfile`의 `apt install` 목록에 패키지를 추가합니다.

런타임 설치 과정을 변경하려면 `docker/init.sh`를 수정합니다. 예를 들어 Node.js 버전을 고정하려면 다음 줄을 원하는 버전으로 바꿀 수 있습니다.

```bash
"${VOLTA_HOME}/bin/volta" install node@22
```

컨테이너 시작 시 항상 적용되어야 하는 환경 설정은 `docker/entrypoint.sh`에 추가합니다.

## 라이선스

이 저장소는 `LICENSE` 파일의 조건을 따릅니다.
