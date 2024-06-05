library(readxl)
library(dplyr)
library(tidyr)

combined_data_batter <- data.frame()
combined_data_pitcher <- data.frame()

# 반복할 연도 범위 설정
start_year <- 2005
end_year <- 2023

for (now_year in start_year:end_year) {
    
    # 파일 경로 생성
    file_path_batter <- file.path(getwd(), "Kbo_Stats/batter", paste0("batter_", now_year, ".xlsx"))
    file_path_pitcher <- file.path(getwd(), "Kbo_Stats/pitcher", paste0("pitcher_", now_year, ".xlsx"))
    file_path_team_info <- file.path(getwd(), "Kbo_Stats", "TeamInfo.xlsx")
    file_path_team_rank <- file.path(getwd(), "Kbo_Stats/Team", paste0("Team_", now_year, ".xlsx"))
    
    # 엑셀 파일 읽기
    data_batter <- read_excel(file_path_batter) %>% filter(Rank != "Rank")
    data_pitcher <- read_excel(file_path_pitcher) %>% filter(Rank != "Rank")
    data_team_info <- read_excel(file_path_team_info)
    data_team_rank <- read_excel(file_path_team_rank)
    
    # 중복값 제거
    data_batter <- data_batter %>% select(-ncol(data_batter))
    data_pitcher <- data_pitcher %>% select(-ncol(data_pitcher))
    
    # 열 이름 수정
    names(data_batter)[4] <- "WAR"
    names(data_batter)[25] <- "AVG"
    names(data_batter)[26] <- "OBP"
    names(data_batter)[27] <- "SLG"
    names(data_batter)[28] <- "OPS"
    names(data_batter)[29] <- "R/ePA"
    names(data_batter)[30] <- "wRC"
    names(data_team_rank)[1] <- "Team"
    names(data_team_rank)[8] <- "WinRate"
    names(data_pitcher)[4] <- "WAR"
    
    # 연도 정보 추가
    data_batter$Year <- now_year
    data_pitcher$Year <- now_year
    
    # 팀 정보 추가
    data_batter$Team <- data_team_info %>% filter(Year == now_year, Type == "batter") %>% pull(Team)
    data_pitcher$Team <- data_team_info %>% filter(Year == now_year, Type == "pitcher") %>% pull(Team)
    
    # 가중치 계산
    data_batter <- data_batter %>%
        mutate(
            caseA = 0.00127 * ((as.numeric(TB) + as.numeric(SB) - as.numeric(CS) + as.numeric(BB) + as.numeric(HP) + as.numeric(IB) - as.numeric(GDP))^2),
            caseC = 0.0011 * ((as.numeric(RBI) * 1.5 + as.numeric(H) + as.numeric(SB) * 2)^2)
        )
    
    data_pitcher <- data_pitcher %>%
        mutate(
            caseZ = ifelse(as.numeric(ERA) >= 20 | as.numeric(ERA) <= 0.5 | as.numeric(G) <= 3, 0, 0.00095 * (0.12 * ((as.numeric(HD) + as.numeric(S)) * 5.2 + as.numeric(IP) * 1.35 - as.numeric(ERA) * 10)^2.55))
        )
    
    data_batter <- data_batter %>% mutate(batter_modelA = caseA)
    data_batter <- data_batter %>% mutate(batter_modelB = caseC)
    data_pitcher <- data_pitcher %>% mutate(pitcher_model = caseZ)

    # 누적 데이터 프레임에 추가
    combined_data_batter <- bind_rows(combined_data_batter, data_batter)
    combined_data_pitcher <- bind_rows(combined_data_pitcher, data_pitcher)
    
    print(paste("Year:", now_year, "file created, completed"))
}

# caseA와 caseZ의 합으로 정렬
combined_data_batter <- combined_data_batter %>% arrange(desc(batter_modelA))
combined_data_pitcher <- combined_data_pitcher %>% arrange(desc(pitcher_model))

# modelA를 다섯번째 열로 이동
combined_data_batter <- combined_data_batter %>% select(1:3, Year, everything())
combined_data_pitcher <- combined_data_pitcher %>% select(1:3, Year, everything())
combined_data_batter <- combined_data_batter %>% select(1:5, batter_modelA, everything())
combined_data_batter <- combined_data_batter %>% select(1:6, batter_modelB, everything())
combined_data_pitcher <- combined_data_pitcher %>% select(1:5, pitcher_model, everything())

# Rank 값을 맨 뒤로 이동
combined_data_batter <- combined_data_batter %>% select(-Rank, everything(), Rank)
combined_data_pitcher <- combined_data_pitcher %>% select(-Rank, everything(), Rank)

# 최종 데이터 확인
print(head(combined_data_batter, n = 50))
print(head(combined_data_pitcher, n = 50))

