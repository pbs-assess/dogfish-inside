# Adapted from github.com/pbs-assess/gfsynopsis/

# remotes::install_github("pbs-assess/gfplot")
library(gfplot)
library(ggplot2)
library(rosettafish)

french <- FALSE
xlim <- c(550, 975)
ylim <- c(5350, 5675)
bath <- c(100, 200, 500)
utm_zone <- 9

ll_range <- gfplot:::utm2ll(cbind(X = xlim, Y = ylim), utm_zone = 9)
coastline_utm <- gfplot:::load_coastline(
  xlim_ll = ll_range[, "X"] + c(-5, 5),
  ylim_ll = ll_range[, "Y"] + c(-5, 5),
  utm_zone = utm_zone
)
isobath_utm <- gfplot:::load_isobath(
  xlim_ll = ll_range[, "X"] + c(-5, 5),
  ylim_ll = ll_range[, "Y"] + c(-12, 12),
  bath = bath, utm_zone = utm_zone
)

# HBLL Inside North & South

cols <- paste0(c(RColorBrewer::brewer.pal(5L, "Set1"),
                 RColorBrewer::brewer.pal(8L, "Set1")[7:8],
                 # "#303030", "#a8a8a8", "#a8a8a8", "#a8a8a8"), "80")
                 "#303030", "#0a0a0a", "#0a0a0a", "#0a0a0a"), "95")
# "#60b6bb", "#60b6bb", "#1d989e", "#a8a8a8"), "80")

hbll_n_in <- gfplot:::ll2utm(gfplot::hbll_inside_n_grid$grid, utm_zone = 9)
hbll_s_in <- gfplot:::ll2utm(gfplot::hbll_inside_s_grid$grid, utm_zone = 9)

hbll <- dplyr::bind_rows(
  list(
    data.frame(hbll_n_in, survey = "Inside Hard Bottom Long Line (North)", stringsAsFactors = FALSE),
    data.frame(hbll_s_in, survey = "Inside Hard Bottom Long Line (South)", stringsAsFactors = FALSE)))

g2 <- ggplot()
g2 <- g2 + geom_rect(data = hbll,
                     aes_string(xmax = "X + 1", ymax = "Y + 1", xmin = "X - 1", ymin = "Y - 1", fill = "survey")) +
  scale_fill_manual(values = c(
    "Inside Hard Bottom Long Line (North)" = cols[5],
    "Inside Hard Bottom Long Line (South)" = cols[6]
  )) +
  geom_path(
    data = isobath_utm, aes_string(
      x = "X", y = "Y",
      group = "paste(PID, SID)"
    ),
    inherit.aes = FALSE, lwd = 0.4, col = "grey70", alpha = 0.4
  )
g2 <- g2 + geom_polygon(
  data = coastline_utm,
  aes_string(x = "X", y = "Y", group = "PID"),
  inherit.aes = FALSE, lwd = 0.1, fill = "grey91", col = "grey72"
) +
  coord_equal(xlim = xlim, ylim = ylim) +
  theme_pbs() + labs(fill = "", colour = "", y = en2fr("Northing", french), x = en2fr("Easting", french))

g2 <- g2 + theme(legend.justification = c(0, 0), legend.position = c(0, 0))

g2
