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

