library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)
library(writexl)

# 반복할 연도 범위 설정
start_year <- 2005
end_year <- 2023
# for (now_year in start_year:end_year) {

#     # 파일 이름 생성
#     file_name_batter <- paste0("Kbo_Stats/batter/batter_", now_year, ".xlsx")
#     file_name_pitcher <- paste0("Kbo_Stats/pitcher/pitcher_", now_year, ".xlsx")
#     file_name_team_info <- "Kbo_Stats/TeamInfo.xlsx"
#     file_name_team_rank <- paste0("Kbo_Stats/Team/Team_", now_year, ".xlsx")
    
#     # 파일 경로 생성
#     file_path_batter <- file.path(getwd(), file_name_batter)
#     file_path_pitcher <- file.path(getwd(), file_name_pitcher)
#     file_path_team_info <- file.path(getwd(), file_name_team_info)
#     file_path_team_rank <- file.path(getwd(), file_name_team_rank)
    
#     # 엑셀 파일 읽기
#     data_batter <- read_excel(file_path_batter)
#     data_pitcher <- read_excel(file_path_pitcher)
#     data_team_info <- read_excel(file_name_team_info)
#     data_team_rank <- read_excel(file_name_team_rank)
    
#     #결측치 제거
#     data_batter <- data_batter %>% filter(Rank != "Rank")
#     data_pitcher <- data_pitcher %>% filter(Rank != "Rank")

#     #중복값 제거
#     data_batter <- data_batter %>% select(-ncol(data_batter))
#     data_pitcher <- data_pitcher %>% select(-ncol(data_pitcher))

#     #이름 오류 수정
#     names(data_batter)[4] <- "WAR"
#     names(data_batter)[25] <- "AVG"
#     names(data_batter)[26] <- "OBP"
#     names(data_batter)[27] <- "SLG"
#     names(data_batter)[28] <- "OPS"
#     names(data_batter)[29] <- "R/ePA"
#     names(data_batter)[30] <- "wRC"
#     names(data_team_rank)[1] <- "Team"
#     names(data_team_rank)[8] <- "WinRate"
#     names(data_pitcher)[4] <- "WAR"

#     #연도 정보 추가
#     data_batter$Year <- now_year
#     data_pitcher$Year <- now_year

#     #팀 정보 다른 파일에서 추출 후 저장 
#     selected_rows <- subset(data_team_info, Year==now_year & Type == "batter")
#     team_info <- selected_rows$Team
#     data_batter$Team <- team_info

#     selected_rows <- subset(data_team_info, Year==now_year & Type == "pitcher")
#     team_info <- selected_rows$Team
#     data_pitcher$Team <- team_info

#     #정해놓은 가중치 생성 _ 타자
#     for (i in 1:nrow(data_batter)) {
#     data_batter <- mutate(data_batter, caseA = (as.numeric(TB)+as.numeric(SB)-as.numeric(CS)+as.numeric(BB)+as.numeric(HP)+as.numeric(IB)-as.numeric(GDP))^2) #case A = 한베이스당 한 가중치
#     data_batter <- mutate(data_batter, caseB = as.numeric(OPS)+as.numeric(wRC)) # case B = ops + wRC+
#     data_batter <- mutate(data_batter, caseC = (as.numeric(RBI)*1.5+as.numeric(H)+as.numeric(SB)*2)^2) # case C = RBI + F ,  (안타 + 타점)
#     data_batter <- mutate(data_batter, caseD = as.numeric(PA)/as.numeric(G)) # case D = 많이 나오는 선수는 잘하는 선수다, 유효타석 / 출장경기수
#     }

#     #정해놓은 가중치 생성 _ 투수
#     for (i in 1:nrow(data_pitcher)) {
#     data_pitcher <- mutate(data_pitcher, caseX = ifelse(100-(as.numeric(rRA9pf)*10+as.numeric(WHIP)*10)<=0, 0, 2*(100-(as.numeric(rRA9pf)*10+as.numeric(WHIP)*10)))) # case X = rRA9pf + WHIP
#     data_pitcher <- mutate(data_pitcher, caseY = if_else(as.numeric(ERA)>=50,0,-1*as.numeric(ERA))) # case Y = -ERA
#     data_pitcher <- mutate(data_pitcher, caseZ = ifelse(as.numeric(ERA)>=20 | as.numeric(ERA)<=0.5 | as.numeric(G)<=3,0,0.12*((as.numeric(HD)+as.numeric(S))*5.2+as.numeric(IP)*1.35-as.numeric(ERA)*10)^2.55)) # case Z = 많이 나오는 선수는 잘하는 선수다, 소화이닝 + 경기수
#     } 

#     #팀별로 가중치값 합산
#     team_WAR_batter <- data_batter %>% group_by(Team) %>% summarise(WAR_total_batter = sum(as.numeric(WAR), na.rm=TRUE))
#     team_WAR_pitcher <- data_pitcher %>% group_by(Team) %>% summarise(WAR_total_pitcher = sum(as.numeric(WAR), na.rm=TRUE))
#     team_WAR <- team_WAR_batter %>% full_join(team_WAR_pitcher, by = "Team") %>% mutate(WAR_total = coalesce(WAR_total_batter, 0) + coalesce(WAR_total_pitcher, 0))
#     team_caseA <- data_batter %>% group_by(Team) %>% summarise(caseA_total = 0.00127 * sum(caseA, na.rm=TRUE))
#     team_caseB <- data_batter %>% group_by(Team) %>% summarise(caseB_total = sum(caseB, na.rm=TRUE)) #사장
#     team_caseC <- data_batter %>% group_by(Team) %>% summarise(caseC_total = 0.0011 * sum(caseC, na.rm=TRUE))
#     team_caseD <- data_batter %>% group_by(Team) %>% summarise(caseD_total = sum(caseD, na.rm=TRUE)) #사장
#     team_caseX <- data_pitcher %>% group_by(Team) %>% summarise(caseX_total = 0.28 * sum(caseX, na.rm=TRUE)) #사장
#     team_caseY <- data_pitcher %>% group_by(Team) %>% summarise(caseY_total = sum(caseY, na.rm=TRUE)) #사장
#     team_caseZ <- data_pitcher %>% group_by(Team) %>% summarise(caseZ_total = 0.00095 * sum(caseZ, na.rm=TRUE))
    
#     # 필요시 열 생성
#     if (!"WAR_total" %in% colnames(data_team_rank)) {
#         data_team_rank$WAR_total <- NA
#     }
#     if (!"caseA_total" %in% colnames(data_team_rank)) {
#         data_team_rank$caseA_total <- NA
#     }
#     if (!"caseB_total" %in% colnames(data_team_rank)) {
#         data_team_rank$caseB_total <- NA
#     }
#     if (!"caseC_total" %in% colnames(data_team_rank)) {
#         data_team_rank$caseC_total <- NA
#     }
#     if (!"caseD_total" %in% colnames(data_team_rank)) {
#         data_team_rank$caseD_total <- NA
#     }
#     if (!"caseX_total" %in% colnames(data_team_rank)) {
#         data_team_rank$caseX_total <- NA
#     }
#     if (!"caseY_total" %in% colnames(data_team_rank)) {
#         data_team_rank$caseY_total <- NA
#     }
#     if (!"caseZ_total" %in% colnames(data_team_rank)) {
#         data_team_rank$caseZ_total <- NA
#     }
#     if (!"caseA_rank" %in% colnames(data_team_rank)) {
#         data_team_rank$caseA_rank <- NA
#     }
#     if (!"caseC_rank" %in% colnames(data_team_rank)) {
#         data_team_rank$caseC_rank <- NA
#     }
#     if (!"caseZ_rank" %in% colnames(data_team_rank)) {
#         data_team_rank$caseZ_rank <- NA
#     }

#     # data_team_rank 파일에 WAR_total 값을 추가
#     for (i in 1:nrow(team_WAR)) {
#     temp_team_name1 <- team_WAR$Team[i]
#     selected_teamrow <- subset(team_WAR, Team==temp_team_name1)
#     selected_teamWAR <- selected_teamrow$WAR_total
#     for(j in 1:nrow(data_team_rank)){
#         temp_team_name2 <- data_team_rank$Team[j]
#         if(temp_team_name1 == temp_team_name2){
#             data_team_rank$WAR_total[j] <- selected_teamWAR
#             break
#         }
#     }
#     }

#     team_caseA <- team_caseA %>% arrange(desc(caseA_total)) %>% mutate(caseA_rank = rank(-caseA_total, ties.method = "min"))
#     team_caseC <- team_caseC %>% arrange(desc(caseC_total)) %>% mutate(caseC_rank = rank(-caseC_total, ties.method = "min"))
#     team_caseZ <- team_caseZ %>% arrange(desc(caseZ_total)) %>% mutate(caseZ_rank = rank(-caseZ_total, ties.method = "min"))

#     for (i in 1:nrow(team_caseA)) {
#     temp_team_name1 <- team_caseA$Team[i]
#     selected_teamrow <- subset(team_caseA, Team == temp_team_name1)
#     selected_teamcaseA <- selected_teamrow$caseA_total
#     selected_teamcaseA_rank <- selected_teamrow$caseA_rank
#         for (j in 1:nrow(data_team_rank)) {
#             temp_team_name2 <- data_team_rank$Team[j]
#             if (temp_team_name1 == temp_team_name2) {
#                 data_team_rank$caseA_total[j] <- selected_teamcaseA
#                 data_team_rank$caseA_rank[j] <- selected_teamcaseA_rank
#             break
#             }
#         }
#     }

#     # data_team_rank 파일에 caseB_total 값을 추가
#     for (i in 1:nrow(team_caseB)) {
#     temp_team_name1 <- team_caseB$Team[i]
#     selected_teamrow <- subset(team_caseB, Team==temp_team_name1)
#     selected_teamcaseB <- selected_teamrow$caseB_total
#         for(j in 1:nrow(data_team_rank)){
#             temp_team_name2 <- data_team_rank$Team[j]
#             if(temp_team_name1 == temp_team_name2){
#                 data_team_rank$caseB_total[j] <- selected_teamcaseB
#                 break
#             }
#         }
#     }

#     # data_team_rank 파일에 caseC_total 값을 추가
#     for (i in 1:nrow(team_caseC)) {
#     temp_team_name1 <- team_caseC$Team[i]
#     selected_teamrow <- subset(team_caseC, Team == temp_team_name1)
#     selected_teamcaseC <- selected_teamrow$caseC_total
#     selected_teamcaseC_rank <- selected_teamrow$caseC_rank 
#         for (j in 1:nrow(data_team_rank)) {
#             temp_team_name2 <- data_team_rank$Team[j]
#             if (temp_team_name1 == temp_team_name2) {
#                 data_team_rank$caseC_total[j] <- selected_teamcaseC
#                 data_team_rank$caseC_rank[j] <- selected_teamcaseC_rank
#             break
#             }
#         }
#     }

#     # data_team_rank 파일에 caseD_total 값을 추가
#     for (i in 1:nrow(team_caseD)) {
#     temp_team_name1 <- team_caseD$Team[i]
#     selected_teamrow <- subset(team_caseD, Team==temp_team_name1)
#     selected_teamcaseD <- selected_teamrow$caseD_total
#         for(j in 1:nrow(data_team_rank)){
#             temp_team_name2 <- data_team_rank$Team[j]
#             if(temp_team_name1 == temp_team_name2){
#                 data_team_rank$caseD_total[j] <- selected_teamcaseD
#                 break
#             }
#         }
#     }

#     # data_team_rank 파일에 caseX_total 값을 추가
#     for (i in 1:nrow(team_caseX)) {
#     temp_team_name1 <- team_caseX$Team[i]
#     selected_teamrow <- subset(team_caseX, Team==temp_team_name1)
#     selected_teamcaseX <- selected_teamrow$caseX_total
#         for(j in 1:nrow(data_team_rank)){
#             temp_team_name2 <- data_team_rank$Team[j]
#             if(temp_team_name1 == temp_team_name2){
#                 data_team_rank$caseX_total[j] <- selected_teamcaseX
#                 break
#             }
#         }
#     }

#     # data_team_rank 파일에 caseY_total 값을 추가
#     for (i in 1:nrow(team_caseY)) {
#     temp_team_name1 <- team_caseY$Team[i]
#     selected_teamrow <- subset(team_caseY, Team==temp_team_name1)
#     selected_teamcaseY <- selected_teamrow$caseY_total
#         for(j in 1:nrow(data_team_rank)){
#             temp_team_name2 <- data_team_rank$Team[j]
#             if(temp_team_name1 == temp_team_name2){
#                 data_team_rank$caseY_total[j] <- selected_teamcaseY
#                 break
#             }
#         }
#     }

#     # data_team_rank 파일에 caseZ_total 값을 추가
#     for (i in 1:nrow(team_caseZ)) {
#     temp_team_name1 <- team_caseZ$Team[i]
#     selected_teamrow <- subset(team_caseZ, Team == temp_team_name1)
#     selected_teamcaseZ <- selected_teamrow$caseZ_total
#     selected_teamcaseZ_rank <- selected_teamrow$caseZ_rank
#         for (j in 1:nrow(data_team_rank)) {
#             temp_team_name2 <- data_team_rank$Team[j]
#             if (temp_team_name1 == temp_team_name2) {
#             data_team_rank$caseZ_total[j] <- selected_teamcaseZ
#             data_team_rank$caseZ_rank[j] <- selected_teamcaseZ_rank
#             break
#             }
#         }
#     }

#     # data_team_rank에 각 가중치의 순위와 실제 순위의 차이값 입력
#     data_team_rank$Rank <- rank(-data_team_rank$WinRate, ties.method = "min")
#     data_team_rank$caseA_rankdif <- abs(data_team_rank$Rank-rank(-data_team_rank$caseA_total, ties.method = "min"))
#     data_team_rank$caseB_rankdif <- abs(data_team_rank$Rank-rank(-data_team_rank$caseB_total, ties.method = "min"))
#     data_team_rank$caseC_rankdif <- abs(data_team_rank$Rank-rank(-data_team_rank$caseC_total, ties.method = "min"))
#     data_team_rank$caseD_rankdif <- abs(data_team_rank$Rank-rank(-data_team_rank$caseD_total, ties.method = "min"))
#     data_team_rank$caseX_rankdif <- abs(data_team_rank$Rank-rank(-data_team_rank$caseX_total, ties.method = "min"))
#     data_team_rank$caseY_rankdif <- abs(data_team_rank$Rank-rank(-data_team_rank$caseY_total, ties.method = "min"))
#     data_team_rank$caseZ_rankdif <- abs(data_team_rank$Rank-rank(-data_team_rank$caseZ_total, ties.method = "min"))
#     data_team_rank$ACXZcomb <- abs(data_team_rank$Rank-rank(-(data_team_rank$caseA_total + data_team_rank$caseC_total + data_team_rank$caseX_total + data_team_rank$caseZ_total), ties.method = "min"))
#     data_team_rank$AXcomb <- abs(data_team_rank$Rank-rank(-(data_team_rank$caseA_total + data_team_rank$caseX_total), ties.method = "min"))
#     data_team_rank$AZcomb <- abs(data_team_rank$Rank-rank(-(data_team_rank$caseA_total + data_team_rank$caseZ_total), ties.method = "min"))
#     data_team_rank$CXcomb <- abs(data_team_rank$Rank-rank(-(data_team_rank$caseC_total + data_team_rank$caseX_total), ties.method = "min"))
#     data_team_rank$CZcomb <- abs(data_team_rank$Rank-rank(-(data_team_rank$caseC_total + data_team_rank$caseZ_total), ties.method = "min"))
#     data_team_rank$XZcomb <- abs(data_team_rank$Rank-rank(-(data_team_rank$caseX_total + data_team_rank$caseZ_total), ties.method = "min"))
#     data_team_rank$AZhapdif <- abs(data_team_rank$Rank-rank((data_team_rank$caseA_rank + data_team_rank$caseZ_rank), ties.method = "min"))
#     data_team_rank$CZhapdif <- abs(data_team_rank$Rank-rank((data_team_rank$caseC_rank + data_team_rank$caseZ_rank), ties.method = "min"))

#     write_xlsx(data_team_rank, path = paste0("Analyzed/final/data_", now_year, ".xlsx"))

#     rm(file_name_batter)
#     rm(file_name_pitcher)
#     rm(file_name_team_info)
#     rm(file_name_team_rank)
#     rm(file_path_batter)
#     rm(file_path_pitcher)
#     rm(file_path_team_info)
#     rm(file_path_team_rank)
#     rm(data_batter)
#     rm(data_pitcher)
#     rm(data_team_info)
#     rm(data_team_rank)
#     rm(team_info)
#     rm(selected_rows)
#     rm(team_WAR_batter)
#     rm(team_WAR_pitcher)
#     rm(team_WAR)
#     rm(team_caseA)
#     rm(team_caseB)
#     rm(team_caseC)
#     rm(team_caseD)
#     rm(team_caseX)
#     rm(team_caseY)
#     rm(team_caseZ)
    
#     print(paste("Year : ",now_year," file created, completed"))

# }


# results <- list()

# for (now_year in start_year:end_year) {
#     file_path <- paste0("Analyzed/final/data_", now_year, ".xlsx")
#     data <- read_excel(file_path)
    
#     # 동적 저장
#     assign(paste0("data_", now_year), data)
    
#     # 가중치 합 계산
#     selected_columns <- c("ACXZcomb", "AXcomb", "AZcomb", "CXcomb", "CZcomb","XZcomb","AZhapdif","CZhapdif")
#     case_sums <- colSums(data[, selected_columns])
#     results[[paste0("data_", now_year, "_sums")]] <- case_sums
# }

# # 결과 데이터 프레임 통합
# results_df <- do.call(rbind, lapply(names(results), function(name) {
#     year <- as.numeric(sub("data_(\\d+)_sums", "\\1", name))
#     data.frame(Year = year, t(results[[name]]))
# }))

# # 데이터 프레임을 long format으로 변환
# results_long <- gather(results_df, key = "Case", value = "Sum", -Year)

# # 'AXcomb'와 'AZcomb' 데이터만 필터링
# results_filtered <- results_long %>% filter(Case %in% c("AZcomb","CZcomb"))

# # 그래프 그리기
# cases <- unique(results_filtered$Case)
# colors <- rainbow(length(cases))
# plot(results_filtered$Year, results_filtered$Sum, type = "n", xlab = "Year", ylab = "Sum of weight Differences", main = "Comparison trends for AZcomb and CZcomb")
# for (i in seq_along(cases)) {
#     case_data <- subset(results_filtered, Case == cases[i])
#     lines(case_data$Year, case_data$Sum, type = "b", col = colors[i], pch = 19, lwd = 2)
# }
# legend("topleft", legend = cases, col = colors, pch = 19, lwd = 2)

#정확도 계산

total_AZcomb <- 0  # AZcomb의 총 합
total_CZcomb <- 0  # CZcomb의 총 합

# 반복문을 통해 각 년도의 파일을 읽고 합산
for (now_year in start_year:end_year) {
    if(now_year==2018) next
    file_path <- paste0("Analyzed/final/data_", now_year, ".xlsx")
    data <- read_excel(file_path)
    
    total_AZcomb <- total_AZcomb + sum(data$AZcomb, na.rm = TRUE)
    total_CZcomb <- total_CZcomb + sum(data$CZcomb, na.rm = TRUE)
}

# 결과 출력
cat("model A accuracy:", (1000-total_AZcomb)/10,"%", "\n")
cat("model B accuracy:", (1000-total_CZcomb)/10,"%", "\n")