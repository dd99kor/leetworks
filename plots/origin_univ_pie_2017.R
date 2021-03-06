library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)


fromschool_data <- read_csv('./rawdatas/fromschool.csv')

selected_data_fromschool <- fromschool_data %>% filter(schoolindex == 1) %>% group_by(school) %>% mutate(tot = sum(y17)) %>% arrange(desc(tot)) %>% distinct(school,tot)

top5 <- selected_data_fromschool %>%  head(5)

etc <- data.frame(school='기타',tot=sum(selected_data_fromschool$tot)-sum(top5$tot))

fromschool <- bind_rows(top5,etc)

fromschool$school <- factor(fromschool$school, levels = rev(as.character(fromschool$school)))

from <- fromschool %>% arrange(school)

text_y <- data.frame(pos = rev(cumsum(fromschool$tot)-fromschool$tot/2))

p <- ggplot(from,aes(x='',y=tot,fill=school)) + geom_bar(width = 1, size =1, color = 'white', stat = 'identity')
p <- p+coord_polar('y', start = 0) + ggtitle(2017)
p <- p + theme_minimal() + theme(axis.title = element_blank(), axis.text = element_blank(), panel.grid = element_blank(), legend.position = 'none', plot.title = element_text(hjust = 0.5))
# p <- p + scale_fill_grey(start = 0.8, end = 0.1)
p <- p + scale_fill_manual(values = c("#FF7FFF", "#FF66FF", "#FF4CFF", "#FF33FF", "#FF1CFF", "#FF00FF"))
p + geom_text(aes(label=paste(school,tot), y = text_y), nudge_x = 0.7 )


etc_label <- selected_data_fromschool %>% tail(-5)

a = paste(etc_label$school,'(',etc_label$tot,')', collapse = ', ')
print(a)
