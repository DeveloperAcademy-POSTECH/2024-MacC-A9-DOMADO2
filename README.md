# 🍎가 되지 말고 🍅가 되라

## 🚴‍♂️ App Statement 
**자전가 라이딩을 즐기는 사용자에게 현재 속도를 명확히 보여줘 화면을 자주 보지 않아도 원하는 페이스를 유지할 수 있도록 도와주자.**

## 🎨 Project Architecture 
```mermaid
graph TD
    subgraph View
        A[RidePreparationView]
        B[ActiveRideView]
        C[PauseRideView]
        D[RideSummaryView]
    end
    subgraph ViewModel
        E[RidePreparationViewModel]
        F[ActiveRideViewModel]
        G[PauseRideViewModel]
        H[RideSummaryViewModel]
    end
    subgraph Model
        I[RideSession]
        K[LocationData]
        L[RestPeriod]
        M[SpeedDistribution]
        N[RideSummary]
        Q[LocationManager]
    end
    subgraph Coordinator
        O[AppCoordinator]
    end
    A -->|Binds to| E
    B -->|Binds to| F
    C -->|Binds to| G
    D -->|Binds to| H
    E -->|Uses| I
    F -->|Uses| I
    G -->|Uses| I
    H -->|Uses| I
    I -->|Contains| K
    I -->|Contains| L
    I -->|Calculates| M
    I -->|Generates| N
    I -->|Uses| Q
    Q -->|Provides| K
    P[CoreData] -->|Persists| I
    O -->|Controls| A
    O -->|Controls| B
    O -->|Controls| C
    O -->|Controls| D
    O -->|Uses| I
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

### 커밋 이름 ➡️ `이슈종류: 이슈번호 - 작업내용`  
ex) `feat:#3-로그인 버튼 추가` 

### 풀리퀘스트 이름 ➡️ `[이슈종류] 작업내용`
ex) `[feat] 로그인 기능 완료`
