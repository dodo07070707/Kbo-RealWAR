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

#갯수 출력
num_rows_batter <- nrow(combined_data_batter)
num_rows_pitcher <- nrow(combined_data_pitcher)
cat("Number of rows (only batter):", num_rows_batter, "\n")
cat("Number of rows (only pitcher):", num_rows_pitcher, "\n")
cat("Total Number of Baseball Player(Recently 20 Years):",num_rows_batter+num_rows_pitcher,"명","\n")
