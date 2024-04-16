combined_data_batter <- data.frame()
combined_data_pitcher <- data.frame()

for (year in 2005:2023) {
  # 파일 이름 생성
  file_name_batter <- paste0("Kbo_Stats/batter/batter_", year, ".xlsx")
  file_name_pitcher <- paste0("Kbo_Stats/pitcher/pitcher_", year, ".xlsx")
  
  # 파일 경로 생성
  file_path_batter <- file.path(getwd(), file_name_batter)
  file_path_pitcher <- file.path(getwd(), file_name_pitcher)
  
  # 엑셀 파일 읽기
  data_batter <- read_excel(file_path_batter)
  data_pitcher <- read_excel(file_path_pitcher)
  
  # 데이터 프레임에 데이터 병합하기
  combined_data_batter <- bind_rows(combined_data_batter, data_batter)
  combined_data_pitcher <- bind_rows(combined_data_pitcher, data_pitcher)
}

#결측치 제거
combined_data_batter <- combined_data_batter %>% filter(Rank != "Rank")
combined_data_pitcher <- combined_data_pitcher %>% filter(Rank != "Rank")

#중복값 제거
combined_data_batter <- combined_data_batter %>% select(-ncol(combined_data_batter))
combined_data_pitcher <- combined_data_pitcher %>% select(-ncol(combined_data_pitcher))

#4번째 열 이름 오류 수정
names(combined_data_batter)[4] <- "WAR"
names(combined_data_pitcher)[4] <- "WAR"

print(head(combined_data_batter,n=10))
