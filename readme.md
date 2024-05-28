# Kbo_RealWAR
# 2024 한국디지털미디어고등학교 자료구조 수행평가 / 개발중
**Subject**
최근 20년 KBO 통계를 이용해 야구 WAR(승리기여도)의 알맞은 수치별 가중치를 구해보자   
**Developer**
김도윤  
**Special Thanks**
김민재, 조성민  
**Used Stack**
R, Node.js, Excel Web Scrapper  
**Gita Sahang**
이거 하려고 R 배움    

# 필요한 라이브러리 불러오기
```
install.packages("readxl")  # readxl 패키지 설치  
install.packages("dplyr")    # dplyr 패키지 설치
install.packages("ggplot2") # ggplot2 패키치 설치
install.packages("tidyr") # tidyr 패키지 설치
install.packages("writexl") # tidyr 패키지 설치
library(readxl)  # readxl 라이브러리 불러오기  
library(dplyr)   # dplyr 라이브러리 불러오기
library(ggplot2) # ggplot2 라이브러리 불러오기
library(tidyr) # tidyr 라이브러리 불러오기 
library(writexl) # tidyr 라이브러리 불러오기 
```
![Frame 3797](https://github.com/dodo07070707/Kbo-RealWAR/assets/98579912/98a3a865-674c-485d-a0e1-a1aeb64fc3ba)  
# 타자 재정립 WAR 순위 (model A, accuracy 85.5%)
![Untitled](https://github.com/dodo07070707/Kbo-RealWAR/assets/98579912/f6c63efb-5db3-4cb7-b8f7-da3b2236f05f)  
# 투수 재정립 WAR 순위  
![Untitled1](https://github.com/dodo07070707/Kbo-RealWAR/assets/98579912/c249c7b3-6d04-4684-83d3-6425b1ca82c5)  
# 년도별 실제 순위와 재정립 WAR 기반 팀 순위의 차
![Untitled](https://github.com/dodo07070707/Kbo-RealWAR/assets/98579912/d8ddb069-5796-44fc-9870-c2586465669d)  
# 2024.05.28 기준 2024년 KBO리그 기대순위
![KakaoTalk_20240528_122603083](https://github.com/dodo07070707/Kbo-RealWAR/assets/98579912/2b338055-ec3c-43a9-b779-56a6d87b8898)  
