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

#4번째 열 이름 오류 수정
names(combined_data_batter)[4] <- "WAR"

for (i in 1:nrow(combined_data_batter)) {
  combined_data_batter <- mutate(combined_data_batter, caseA = as.numeric(TB)+as.numeric(SB)-as.numeric(CS)+as.numeric(BB)+as.numeric(HP)+as.numeric(IB)-as.numeric(GDP))
  combined_data_batter <- mutate(combined_data_batter, caseA = as.numeric(TB)+as.numeric(SB)-as.numeric(CS)+as.numeric(BB)+as.numeric(HP)+as.numeric(IB)-as.numeric(GDP))
}

print(head(arrange(combined_data_batter,desc(caseA)),n=50))
