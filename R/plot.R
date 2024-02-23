



plot_network <- function (figure_name,
                          node_names,
                          edges_from,
                          edges_to,
                          node_x = NULL,
                          node_y = NULL,
                          node_shape = 21,
                          node_size = 10,
                          node_colour = "black",
                          node_fill = "white",
                          figure_width = 90,
                          figure_height = 60,
                          figure_path = "report/figs",
                          figure_ext = ".png",
                          figure_dpi = 600) {
  
  # Check arguments ------------------------------------------------------------
  
  figure_path <- gsub("/$", "", figure_path)
  
  # Define nodes ---------------------------------------------------------------
  
  nodes <- tibble::tibble(
    id = seq_along(node_names),
    label = node_names
  )
  
  # Define edges ---------------------------------------------------------------
  
  edges <- tibble::tibble(
    from = edges_from,
    to = edges_to
  )
  
  # Define network -------------------------------------------------------------
  
  network <- tidygraph::tbl_graph(
    nodes = nodes,
    edges = edges,
    directed = TRUE
  )
  
  # Define network layout ------------------------------------------------------

  if (is.null(node_x) | is.null(node_y)) {
    layout <- ggraph::create_layout(
      graph = network,
      layout = "auto",
      circular = FALSE
    )  
  } else {
    layout <- ggraph::create_layout(
      graph = network,
      layout = "manual",
      circular = FALSE,
      x = node_x,
      y = node_y
    )
  }
  
  # Create ggplot --------------------------------------------------------------
  
  p1 <- ggplot2::ggplot(data = layout) +
    ggraph::geom_edge_fan(
      arrow = ggplot2::arrow(
        length = grid::unit(2, "mm"),
        type = "closed"
      ),
      end_cap = ggraph::circle(5, "mm")
    ) + 
    ggraph::geom_node_point(
      colour = node_colour,
      fill = node_fill,
      shape = node_shape,
      size = node_size
    ) +
    ggsidekick::theme_sleek() +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      legend.position = "none",
      plot.background = ggplot2::element_rect(fill = "white", color = NA),
    )
  
  # Save ggplot ----------------------------------------------------------------
  
  ggplot2::ggsave(
    here::here(figure_path, paste0(figure_name, figure_ext)),
    width = figure_width,
    height = figure_height,
    units = "mm",
    dpi = figure_dpi
  )
  
  # Return path
  return(paste0(figure_path, "/", figure_name, figure_ext))
}