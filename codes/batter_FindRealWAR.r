combined_data_batter <- data.frame()

# 파일 이름 생성
file_name_batter <- paste0("Kbo_Stats/batter/batter_2005.xlsx")
file_name_team_info <- paste0("Kbo_Stats/TeamInfo.xlsx")
file_name_team_rank <- paste0("Kbo_Stats/Team/Team_2005.xlsx")
  
# 파일 경로 생성
file_path_batter <- file.path(getwd(), file_name_batter)
file_path_team_info <- file.path(getwd(), file_name_team_info)
file_path_team_rank <- file.path(getwd(), file_name_team_rank)
  
# 엑셀 파일 읽기
data_batter <- read_excel(file_path_batter)
data_team_info <- read_excel(file_name_team_info)
data_team_rank <- read_excel(file_name_team_rank)
  
#결측치 제거
data_batter <- data_batter %>% filter(Rank != "Rank")

#중복값 제거
data_batter <- data_batter %>% select(-ncol(data_batter))

#이름 오류 수정
names(data_batter)[4] <- "WAR"
names(data_batter)[25] <- "AVG"
names(data_batter)[26] <- "OBP"
names(data_batter)[27] <- "SLG"
names(data_batter)[28] <- "OPS"
names(data_batter)[29] <- "R/ePA"
names(data_batter)[30] <- "wRC"
names(data_team_rank)[1] <- "Team"
names(data_team_rank)[8] <- "WinRate"

#연도 정보 추가
data_batter$Year <- 2005

#팀 정보를 가져와 저장하기 
selected_rows <- subset(data_team_info, Year==2005 & Type == "batter")

team_info <- selected_rows$Team

data_batter$Team <- team_info

#정해놓은 가중치 추가
for (i in 1:nrow(data_batter)) {
  data_batter <- mutate(data_batter, caseA = as.numeric(TB)+as.numeric(SB)-as.numeric(CS)+as.numeric(BB)+as.numeric(HP)+as.numeric(IB)-as.numeric(GDP)) #case A = 한베이스당 한 가중치
  data_batter <- mutate(data_batter, caseB = as.numeric(OPS)+as.numeric(wRC)) # case B = ops + wRC+
  data_batter <- mutate(data_batter, caseC = as.numeric(SF)+as.numeric(RBI)) # case C = RBI + SF , 클러치 상황 (희생플라이 + 타점)
  data_batter <- mutate(data_batter, caseD = as.numeric(ePA)/as.numeric(G)) # case D = 많이 나오는 선수는 잘하는 선수다, 유효타석 / 출장경기수
}

#팀별로 caseA값 합산
team_WAR <- data_batter %>% group_by(Team) %>% summarise(WAR_total = sum(as.numeric(WAR), na.rm=TRUE))
team_caseA <- data_batter %>% group_by(Team) %>% summarise(caseA_total = sum(caseA, na.rm=TRUE))
team_caseB <- data_batter %>% group_by(Team) %>% summarise(caseB_total = sum(caseB, na.rm=TRUE))
team_caseC <- data_batter %>% group_by(Team) %>% summarise(caseC_total = sum(caseC, na.rm=TRUE))
team_caseD <- data_batter %>% group_by(Team) %>% summarise(caseD_total = sum(caseD, na.rm=TRUE))

# data_team_rank 파일에 WAR_total 값을 추가
for (i in 1:nrow(team_WAR)) {
  temp_team_name1 <- team_WAR$Team[i]
  selected_teamrow <- subset(team_WAR, Team==temp_team_name1)
  selected_teamWAR <- selected_teamrow$WAR_total
  for(j in 1:nrow(data_team_rank)){
    temp_team_name2 <- data_team_rank$Team[j]
    if(temp_team_name1 == temp_team_name2){
        data_team_rank$WAR_total[j] <- selected_teamWAR
        break
    }
  }
}

# data_team_rank 파일에 caseA_total 값을 추가
for (i in 1:nrow(team_caseA)) {
  temp_team_name1 <- team_caseA$Team[i]
  selected_teamrow <- subset(team_caseA, Team==temp_team_name1)
  selected_teamcaseA <- selected_teamrow$caseA_total
  for(j in 1:nrow(data_team_rank)){
    temp_team_name2 <- data_team_rank$Team[j]
    if(temp_team_name1 == temp_team_name2){
        data_team_rank$caseA_total[j] <- selected_teamcaseA
        break
    }
  }
}

# data_team_rank 파일에 caseB_total 값을 추가
for (i in 1:nrow(team_caseB)) {
  temp_team_name1 <- team_caseB$Team[i]
  selected_teamrow <- subset(team_caseB, Team==temp_team_name1)
  selected_teamcaseB <- selected_teamrow$caseB_total
  for(j in 1:nrow(data_team_rank)){
    temp_team_name2 <- data_team_rank$Team[j]
    if(temp_team_name1 == temp_team_name2){
        data_team_rank$caseB_total[j] <- selected_teamcaseB
        break
    }
  }
}

# data_team_rank 파일에 caseC_total 값을 추가
for (i in 1:nrow(team_caseC)) {
  temp_team_name1 <- team_caseC$Team[i]
  selected_teamrow <- subset(team_caseC, Team==temp_team_name1)
  selected_teamcaseC <- selected_teamrow$caseC_total
  for(j in 1:nrow(data_team_rank)){
    temp_team_name2 <- data_team_rank$Team[j]
    if(temp_team_name1 == temp_team_name2){
        data_team_rank$caseC_total[j] <- selected_teamcaseC
        break
    }
  }
}

# data_team_rank 파일에 caseD_total 값을 추가
for (i in 1:nrow(team_caseD)) {
  temp_team_name1 <- team_caseD$Team[i]
  selected_teamrow <- subset(team_caseD, Team==temp_team_name1)
  selected_teamcaseD <- selected_teamrow$caseD_total
  for(j in 1:nrow(data_team_rank)){
    temp_team_name2 <- data_team_rank$Team[j]
    if(temp_team_name1 == temp_team_name2){
        data_team_rank$caseD_total[j] <- selected_teamcaseD
        break
    }
  }
}

write_xlsx(data_team_rank, path="Kbo_Stats/testing.xlsx")


#y축 범위 제한 자동화 + 그래프 시각화
ylim_min <- min(c(data_team_rank$caseA_total, data_team_rank$caseB_total, data_team_rank$caseC_total, data_team_rank$caseD_total))
ylim_max <- max(c(data_team_rank$caseA_total, data_team_rank$caseB_total, data_team_rank$caseC_total, data_team_rank$caseD_total))

plot(data_team_rank$WinRate,data_team_rank$caseA_total, type="l", col="red", xlim=c(0.3,0.7), ylim=c(ylim_min,ylim_max), xlab="Win Rate", ylab="New custom weight", main="Correlation between winning percentage in 2005 and new weight values")
lines(data_team_rank$WinRate, data_team_rank$caseB_total, col="blue", type="l")
lines(data_team_rank$WinRate, data_team_rank$caseC_total*3, col="green", type="l")
lines(data_team_rank$WinRate, data_team_rank$caseD_total*30, col="purple", type="l")
lines(data_team_rank$WinRate, data_team_rank$WAR_total*60, col="black", type="l")
legend("bottomright",legend=c("caseA","caseB","caseC*3","caseD*30","WAR*60"),fill=c("red","blue","green","purple","black"),border="white",box.lty=0,cex=1.5)