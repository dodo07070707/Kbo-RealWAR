combined_data_batter <- data.frame()

for (year in 2005:2023) {
  # 파일 이름 생성
  file_name_batter <- paste0("Kbo_Stats/batter/batter_", year, ".xlsx")
  
  # 파일 경로 생성
  file_path_batter <- file.path(getwd(), file_name_batter)
  
  # 엑셀 파일 읽기
  data_batter <- read_excel(file_path_batter)
  
  # 데이터 프레임에 데이터 병합하기
  combined_data_batter <- bind_rows(combined_data_batter, data_batter)
}

#결측치 제거
combined_data_batter <- combined_data_batter %>% filter(Rank != "Rank")

#중복값 제거
combined_data_batter <- combined_data_batter %>% select(-ncol(combined_data_batter))

#이름 오류 수정
names(combined_data_batter)[4] <- "WAR"
names(combined_data_batter)[25] <- "AVG"
names(combined_data_batter)[26] <- "OBP"
names(combined_data_batter)[27] <- "SLG"
names(combined_data_batter)[28] <- "OPS"
names(combined_data_batter)[29] <- "R/ePA"
names(combined_data_batter)[30] <- "wRC"


for (i in 1:nrow(combined_data_batter)) {
  combined_data_batter <- mutate(combined_data_batter, caseA = as.numeric(TB)+as.numeric(SB)-as.numeric(CS)+as.numeric(BB)+as.numeric(HP)+as.numeric(IB)-as.numeric(GDP)) #case A = 한베이스당 한 가중치
  combined_data_batter <- mutate(combined_data_batter, caseB = as.numeric(OPS)+as.numeric(wRC)) # case B = ops + wRC+
  combined_data_batter <- mutate(combined_data_batter, caseC = as.numeric(SF)+as.numeric(RBI)) # case C = RBI + SF , 클러치 상황 (희생플라이 + 타점)
  combined_data_batter <- mutate(combined_data_batter, caseD = as.numeric(ePA)/as.numeric(G)) # case D = 많이 나오는 선수는 잘하는 선수다, 유효타석 / 출장경기수
}

combined_data_batter <- combined_data_batter %>% unite(NameYear, Name, Team, sep=" ")
combined_data_batter <- arrange(combined_data_batter,desc(caseA))
combined_data_batter$index <- 1:nrow(combined_data_batter)

#print(head(arrange(combined_data_batter,desc(caseA)),n=50))

#y축 범위 제한 자동화 + 결측치 제거를 위한 코드
ylim_min <- min(c(na.omit(combined_data_batter$caseA), na.omit(combined_data_batter$caseB), na.omit(combined_data_batter$caseC),na.omit(combined_data_batter$caseD)))
ylim_max <- max(c(na.omit(combined_data_batter$caseA), na.omit(combined_data_batter$caseB), na.omit(combined_data_batter$caseC), na.omit(combined_data_batter$caseD)))

plot(combined_data_batter$index,combined_data_batter$caseA, type="l", col="red", xlim=c(0,4715), ylim=c(ylim_min,ylim_max), xlab="Batter", ylab="New custom weight", main="Graph differences in new win contribution for different custom weights")
lines(combined_data_batter$index, combined_data_batter$caseB, col="blue", type="l")
lines(combined_data_batter$index, combined_data_batter$caseC, col="green", type="l")
lines(combined_data_batter$index, combined_data_batter$caseD, col="purple", type="l")