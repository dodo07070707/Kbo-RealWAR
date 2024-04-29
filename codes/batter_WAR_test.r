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

#print(head(arrange(combined_data_batter,desc(caseA)),n=50))

#데이터를 long term으로 변환, case와 value로 이루어진 새로운 data frame 형성
combined_data_long <- combined_data_batter %>% select(caseA, caseB, caseC, caseD) %>% tidyr::gather(key = "case", value = "batter")

print(summary(combined_data_long))

# print(ggplot(data = combined_data_long, aes(x = row_number(), y = batter, color = case)) +
#   geom_line() +
#   ggtitle("Graph differences in new win contribution for different custom weights") +
#   xlab("Player") + ylab("New custom weight") +
#   theme_minimal() +
#   scale_color_manual(values = c("blue", "red", "green", "purple")))
