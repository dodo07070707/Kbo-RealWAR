library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)
library(writexl)
library(gridExtra)

start_year <- 2005
end_year <- 2023

results <- list()

for (now_year in start_year:end_year) {
    file_path <- paste0("Analyzed/raw/data_", now_year, ".xlsx")
    data <- read_excel(file_path)
    
    # 동적 저장
    assign(paste0("data_", now_year), data)
    
    # 가중치 합 계산
    selected_columns <- c(grep("case[A-D]_rankdif", names(data), value = TRUE), grep("case[X-Z]_rankdif", names(data), value = TRUE))
    case_sums <- colSums(data[, selected_columns])
    results[[paste0("data_", now_year, "_sums")]] <- case_sums
}

# 결과 데이터 프레임 통합
results_df <- do.call(rbind, lapply(names(results), function(name) {
    year <- as.numeric(sub("data_(\\d+)_sums", "\\1", name))
    data.frame(Year = year, t(results[[name]]))
}))

# 데이터 프레임을 long format으로 변환
results_long <- gather(results_df, key = "Case", value = "Sum", -Year)

# 조합론에 따른 합계 계산
calculate_sums <- function(df) {
  case_pairs <- list(
    "A_X" = c("caseA_rankdif", "caseX_rankdif"),
    "A_Y" = c("caseA_rankdif", "caseY_rankdif"),
    "A_Z" = c("caseA_rankdif", "caseZ_rankdif"),
    "B_X" = c("caseB_rankdif", "caseX_rankdif"),
    "B_Y" = c("caseB_rankdif", "caseY_rankdif"),
    "B_Z" = c("caseB_rankdif", "caseZ_rankdif"),
    "C_X" = c("caseC_rankdif", "caseX_rankdif"),
    "C_Y" = c("caseC_rankdif", "caseY_rankdif"),
    "C_Z" = c("caseC_rankdif", "caseZ_rankdif"),
    "D_X" = c("caseD_rankdif", "caseX_rankdif"),
    "D_Y" = c("caseD_rankdif", "caseY_rankdif"),
    "D_Z" = c("caseD_rankdif", "caseZ_rankdif")
  )
  
  sums <- sapply(names(case_pairs), function(pair) {
    sum(df[, case_pairs[[pair]]], na.rm = TRUE)
  })
  
  return(sums)
}

# 합계 계산 결과를 저장할 데이터 프레임 초기화
sums_results_df <- data.frame(Year = integer(), CasePair = character(), Sum = numeric())

for (now_year in start_year:end_year) {
  df <- get(paste0("data_", now_year))
  sums <- calculate_sums(df)
  
  year_sums_df <- data.frame(Year = now_year, CasePair = names(sums), Sum = sums)
  sums_results_df <- rbind(sums_results_df, year_sums_df)
}

# 그래프 그리기
cases <- unique(sums_results_df$CasePair)
colors <- rainbow(length(cases))
plot(sums_results_df$Year, sums_results_df$Sum, type = "n", xlab = "Year", ylab = "Sum of Rank Differences", main = "Comparison trends with actual team rank according to custom weight A-D to X-Z")
for (i in seq_along(cases)) {
  case_data <- subset(sums_results_df, CasePair == cases[i])
  lines(case_data$Year, case_data$Sum, type = "b", col = colors[i], pch = 19, lwd = 2)
}
legend("topleft", legend = cases, col = colors, pch = 19, lwd = 2)
