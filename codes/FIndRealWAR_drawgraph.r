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

# 그래프 그리기
cases <- unique(results_long$Case)
colors <- rainbow(length(cases))
plot(results_long$Year, results_long$Sum, type = "n", xlab = "Year", ylab = "Sum of weight Differences", main = "Comparison trends with actual team rank according to custom weight")
for (i in seq_along(cases)) {
    case_data <- subset(results_long, Case == cases[i])
    lines(case_data$Year, case_data$Sum, type = "b", col = colors[i], pch = 19, lwd = 2)
}
legend("topleft", legend = cases, col = colors, pch = 19, lwd = 2)
