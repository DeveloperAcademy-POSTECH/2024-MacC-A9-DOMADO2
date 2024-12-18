# PacePal - 나만의 페이스 메이커 
<p align="center">
  <a href="">
    <img src="https://github.com/user-attachments/assets/ebcfde66-3d94-4a95-8022-4546345344b1" width="200" height="200" alt="app store">
  </a>
</p>
<p align="center">
  <a href="https://apps.apple.com/kr/app/pacepal/id6737474748">
    <img src="https://github.com/OneMoreThink/Earth/assets/121593683/0193bc32-c702-42f5-9549-cca277d63870" width="200" height="80" alt="app store">
  </a>
</p>


## 🚴‍♂️ App Statement 
**자전가 라이딩을 즐기는 사용자에게 현재 속도를 명확히 보여줘 화면을 자주 보지 않아도 원하는 페이스를 유지할 수 있도록 도와주자.**

## 📱 앱 소개 
<table style="width: 100%; table-layout: fixed;">
  <tr>
    <td style="text-align: center;">
      <img src="https://github.com/user-attachments/assets/91dc16b2-f994-4cea-ae06-13d68fcc2e07" width="100%" alt="Image 1">
    </td>
    <td style="text-align: center;">
      <img src="https://github.com/user-attachments/assets/3c059f38-2faf-4c02-85b7-5b9e44f6c2fc" width="100%" alt="Image 2">
    </td>
    <td style="text-align: center;">
      <img src= "https://github.com/user-attachments/assets/bdec04fc-b92c-446b-a700-66777c0f9c1c" width="100%" alt="Image 3">
    </td>
    <td style="text-align: center;">
      <img src="https://github.com/user-attachments/assets/b0f4f86a-c537-4374-8434-6161b0e3a9cf" width="100%" alt="Image 4">
    </td>
    <td style="text-align: center;">
      <img src="https://github.com/user-attachments/assets/78af7a1d-0477-4216-8230-2675bd9c5870" width="100%" alt="Image 5">
    </td>
  </tr>
</table>


## 🎨 Project Architecture 
```mermaid
flowchart TD
    subgraph View["View"]
        direction TB
        A[ContentView]
        J[RidePreparationView]
        K[ActiveRideView]
        L[PauseRideView]
        M[RideSummaryView]
        O[RideHistoryView]
        P[RideDetailView]
    end

    subgraph ViewModel["ViewModel"]
        direction TB
        E[RidePreparationViewModel]
        F[ActiveRideViewModel]
        G[PauseRideViewModel]
        H[RideSummaryViewModel]
        N[RideHistoryViewModel]
    end

    subgraph Model["Model"]
        direction TB
        I[RideSession]
        K1[LocationData]
        L1[RestPeriod]
        M1[SpeedDistribution]
        N1[RideSummary]
        Q[LocationManager]
        R[CoreData]
    end

    subgraph Coordinator["Coordinator"]
        direction TB
        B[AppCoordinator]
    end

    subgraph Events["Events"]
        direction TB
        D[RideEventPublishable]
        S[RideEvent]
    end
    
    A -->|Uses| B
    B -->|Manages| C((currentView))
    B -->|Subscribes to| D
    
    D --> E & F & G & H & N
    
    E & F & G & H & N --> S
    
    S -->|Triggers| B
    
    C -->|Shows| J & K & L & M & O
    
    J -.->|User Action| E
    K -.->|User Action| F
    L -.->|User Action| G
    M -.->|User Action| H
    O -.->|User Action| N
    
    O -->|NavigationLink| P
    O -.->|Back Button| N
    
    E & F & G & H & N -->|Uses| I
    
    I --> K1 & L1
    I -->|Calculates| M1
    I -->|Generates| N1
    I -->|Uses| Q
    Q -->|Provides| K1
    R -->|Persists| I

    classDef viewStyle fill:#f9f,stroke:#333,stroke-width:2px;
    classDef coordinatorStyle fill:#bbf,stroke:#333,stroke-width:2px;
    classDef eventStyle fill:#fbb,stroke:#333,stroke-width:2px;
    classDef historyStyle fill:#bfb,stroke:#333,stroke-width:2px;
    classDef sessionStyle fill:#ffa,stroke:#333,stroke-width:2px;
    classDef componentStyle fill:#afa,stroke:#333,stroke-width:2px;

    class A,J,K,L,M,O,P viewStyle;
    class B coordinatorStyle;
    class S eventStyle;
    class O,P historyStyle;
    class I sessionStyle;
    class K1,L1,M1,N1 componentStyle;
```


## 🧩 Team 
<table style="width: 100%; table-layout: fixed;">
  <tr>
    <td style="text-align: center; padding: 10px;">
      <h3>김리</h3>
    </td>
    <td style="text-align: center; padding: 10px;">
      <h3>마리</h3>
    </td>
    <td style="text-align: center; padding: 10px;">
      <h3>제이비</h3>
    </td>
    <td style="text-align: center; padding: 10px;">
      <h3>파인</h3>
    </td>
  </tr>
  <tr>
    <td style="text-align: center; padding: 10px;">
      <img src="https://github.com/user-attachments/assets/f81df4d7-530c-4887-acd5-1c8cb1ab2f86" width="100" alt="Image 1">
    </td>
    <td style="text-align: center; padding: 10px;">
      <img src="https://github.com/user-attachments/assets/155562e5-a3ac-4aea-9418-c60242e5803d" width="100" alt="Image 2">
    </td>
    <td style="text-align: center; padding: 10px;">
      <img src= "https://github.com/user-attachments/assets/2c591b0c-c274-4b86-9b29-94529ce9f75f" width="100" alt="Image 3">
    </td>
    <td style="text-align: center; padding: 10px;">
      <img src="https://github.com/user-attachments/assets/9447f050-638f-4411-a273-19fa869d0d25" width="100" alt="Image 4">
    </td>
  </tr>
</table>



## 🐈‍⬛ Github Convention

### 이슈 종류

| 이슈 종류        | 설명                                                                                         |
|------------------|----------------------------------------------------------------------------------------------|
| `feat`     | **Feature**: 새로운 기능을 추가하거나 구현할 때 사용하는 이슈입니다. 예: 다크 모드 지원 추가.               |
| `bug`          | **Bug**: 예상과 다른 동작이나 코드 오류를 해결할 때 사용하는 이슈입니다. 예: 로그인 화면에서 앱 충돌.   |
| `enh`  | **Enhancement** 기존 기능을 개선하거나 확장할 때 사용하는 이슈입니다. 예: List 컴포넌트의 성능 최적화.         |
| `ref`   | **Refactor**: 기능을 변경하지 않고 코드 구조를 개선할 때 사용하는 이슈입니다. 예: 상태 관리를 ViewModel로 분리.|
| `chore`    | **Chore**: 유지보수 작업이나 설정 업데이트 같은 비기능적 작업에 사용하는 이슈입니다. 예: Xcode 프로젝트 설정 업데이트. |
| `doc`| **Documentation**: 문서화 작업이 필요할 때 사용하는 이슈입니다. 예: 새로운 기능에 대한 사용자 가이드 업데이트.    |

### 이슈 제목 ➡️ `[이슈 종류] 이슈 이름` 
ex) `[feat] 로그인 기능 추가`

### 브랜치 이름 ➡️ `이슈종류/#이슈 번호/적업할내용`
ex) `feat/#3-Login`

### 커밋 이름 ➡️ `이슈종류/#이슈 번호 - 작업내용`  
ex) `feat/#3-로그인 버튼 추가` 

### 풀리퀘스트 이름 ➡️ `[이슈종류] 작업내용`
ex) `[feat] 로그인 기능 완료`
