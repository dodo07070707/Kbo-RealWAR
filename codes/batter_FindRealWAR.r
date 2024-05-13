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

#연도 정보 추가
data_batter$Year <- 2005

#팀 정보를 가져와 저장하기 
selected_rows <- subset(data_team_info, Year==2005 & Type == "batter")

team_info <- selected_rows$Team

data_batter$Team <- team_info


for (i in 1:nrow(data_batter)) {
  data_batter <- mutate(data_batter, caseA = as.numeric(TB)+as.numeric(SB)-as.numeric(CS)+as.numeric(BB)+as.numeric(HP)+as.numeric(IB)-as.numeric(GDP)) #case A = 한베이스당 한 가중치
  data_batter <- mutate(data_batter, caseB = as.numeric(OPS)+as.numeric(wRC)) # case B = ops + wRC+
  data_batter <- mutate(data_batter, caseC = as.numeric(SF)+as.numeric(RBI)) # case C = RBI + SF , 클러치 상황 (희생플라이 + 타점)
  data_batter <- mutate(data_batter, caseD = as.numeric(ePA)/as.numeric(G)) # case D = 많이 나오는 선수는 잘하는 선수다, 유효타석 / 출장경기수
}



print(head(data_batter),n=50)


# #y축 범위 제한 자동화 + 결측치 제거를 위한 코드
# ylim_min <- min(c(na.omit(combined_data_batter$caseA), na.omit(combined_data_batter$caseB), na.omit(combined_data_batter$caseC),na.omit(combined_data_batter$caseD)))
# ylim_max <- max(c(na.omit(combined_data_batter$caseA), na.omit(combined_data_batter$caseB), na.omit(combined_data_batter$caseC), na.omit(combined_data_batter$caseD)))

# plot(combined_data_batter$index,combined_data_batter$caseA, type="l", col="red", xlim=c(0,100), ylim=c(ylim_min,ylim_max), xlab="Batter", ylab="New custom weight", main="Graph differences in new win contribution for different custom weights")
# lines(combined_data_batter$index, combined_data_batter$caseB, col="blue", type="l")
# lines(combined_data_batter$index, combined_data_batter$caseC, col="green", type="l")
# lines(combined_data_batter$index, combined_data_batter$caseD, col="purple", type="l")