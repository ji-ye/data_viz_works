theme_jiye <- theme(
    panel.grid.major.y = element_line(size = .1, color = "#999999"),
    panel.grid.major.x = element_blank(),
    panel.background = element_blank(),
    plot.title = element_text(size=24,
                              family = "Helvetica",
                              colour = "#3a3a3a",
                              face = "bold"),
    plot.subtitle = element_text(size=12,
                                 family = "Avenir",
                                 colour = "#666666"),
    axis.title.y = element_text(colour="#325a8c"),
    axis.title.x = element_blank(),
    axis.text.y = element_text(colour="#325a8c"),
    axis.text.x = element_text(size=12,
                                family = "Avenir",
                                colour = "#666666"),
    axis.ticks.y = element_blank(),
    legend.position = "none",
    plot.caption = element_text(size=8,
                                family = "Avenir",
                                colour = "#666666",
                                hjust = 0),
    plot.margin = unit(c(0,0,0,0), "pt")
)

theme_map_short <- theme_jiye + theme(
    panel.grid.major.y = element_blank(),
    axis.title.y = element_blank(),
    axis.text.y = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks = element_blank(),
    plot.margin = unit(c(5,0,0,0), "pt")
)

theme_percBar_short <- theme_jiye + theme(
    panel.grid.major.y = element_blank(),
    aspect.ratio = 0.05,
    axis.title.y = element_blank(),
    axis.text.x = element_text(hjust = 1,
                               size = 10),
    axis.line.x = element_line(),
    plot.caption = element_text(size = 12),
    plot.margin = unit(c(0, 5, 0, 5), "pt")
)

theme_volume_short <- theme_jiye + theme(
    axis.title.y = element_text(colour = "#666666"),
    axis.text.y = element_text(colour = "#666666"),
    axis.title.x = element_text(size = 12,
                                family = "Avenir",
                                colour = "#666666")
)

theme_heatmap_short <- theme_jiye + theme(
    panel.grid.major.y = element_blank(),
    aspect.ratio = 1,
    axis.title.y = element_text(colour = "#666666"),
    axis.text.y = element_text(colour = "#666666"),
    legend.position = c(0.1, 0.9)
)
