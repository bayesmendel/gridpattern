test_raster <- function(ref_png, fn, update = FALSE) {
    f <- file.path("../figs/array", ref_png)
    if (update) my_png(f, fn)
    ref <- magick::image_read(f)

    tmpfile <- tempfile(fileext = ".png")
    my_png(tmpfile, fn)
    image <- magick::image_read(tmpfile)
    unlink(tmpfile)

    diff <- magick::image_compare(image, ref, "AE")
    expect_true(attr(diff, "distortion") < 0.01)
}

my_png <- function(f, fn) {
    current_dev <- grDevices::dev.cur()
    grDevices::png(f, type = "cairo", width = 240, height = 240)
    val <- fn()
    grDevices::dev.off()
    if (current_dev > 1) grDevices::dev.set(current_dev)
    invisible(val)
}

test_that("array patterns works as expected", {
    skip_on_ci()
    skip_on_cran()
    skip_if_not(capabilities("cairo"))
    skip_if_not_installed("magick")
    skip_if_not_installed("ragg")

    x <- 0.5 + 0.5 * cos(seq(2 * pi / 4, by = 2 * pi / 6, length.out = 6))
    y <- 0.5 + 0.5 * sin(seq(2 * pi / 4, by = 2 * pi / 6, length.out = 6))
    test_raster("gradient.png",
                function() grid.pattern_gradient(x, y, fill="blue", fill2="green",
                                                 orientation="radial", use_R4.1_gradients = FALSE))
    test_raster("gradient_horizontal.png",
                function() grid.pattern_gradient(x, y, fill="blue", fill2="green",
                                                 orientation="horizontal", use_R4.1_gradients = FALSE))
    logo_filename   <- system.file("img", "Rlogo.png" , package="png")
    test_raster("image.png", function() {
                    grid.pattern_image(x, y, filename=logo_filename, type="fit")
                })
    test_raster("image_expand.png", function() {
                    grid.pattern_image(x, y, filename=logo_filename, type="expand")
                })
    test_raster("image_tile.png", function() {
                    grid.pattern_image(x, y, filename=logo_filename, type="tile", scale=-2)
                })
    test_raster("image_none.png", function() {
                    grid.pattern_image(x, y, filename=logo_filename, type="none", scale=-1)
                })
    test_raster("image_squish.png", function() {
                    grid.pattern_image(x, y, filename=logo_filename, type="squish")
                })
    test_raster("magick.png",
                function() grid.pattern_magick(x, y, type="octagons", fill="blue", scale=2))
    test_raster("placeholder.png",
                function() grid.pattern_placeholder(x, y, type="bear"))

    test_raster("plasma_zero.png",
                function() grid.pattern_plasma(x = c(0.5, 0.5, 0.5, 0.5),
                                               y = c(0, 1, 1, 0), fill = "green"))

    playing_card_symbols <- c("\u2660", "\u2665", "\u2666", "\u2663")
    test_raster("text.png",
                function() grid.pattern_text(x, y, shape = playing_card_symbols,
                                             colour = c("black", "red", "red", "black"),
                                             use_R4.1_masks = TRUE,
                                             size = 18, spacing = 0.1, angle = 0))

    gp <- gpar(fill = c("blue", "red", "yellow", "green"), col = "black")
    test_raster("rose.png",
             function() grid.pattern_rose(x, y,
                                          spacing = 0.15, density = 0.5, angle = 0,
                                          use_R4.1_masks = NULL,
                                          frequency = 1:4, gp = gp))

    # plasma images are random and doesn't seem to be a way to set a seed
    tmpfile <- tempfile(fileext = ".png")
    grob <- my_png(tmpfile, function() grid.pattern_plasma(fill="green"))
    unlink(tmpfile)
    expect_true(inherits(grob, "pattern"))

    create_pattern_simple <- function(width, height, params, legend) {
      choice <- params$pattern_type
      if (is.null(choice) || is.na(choice) || !is.character(choice)) {
        choice <- 'a'
      }
      values <- switch(
        choice,
        a = rep(c(0, 1, 0, 1, 1, 0, 0, 1, 1, 1), each = 3),
        b = rep(c(1, 0, 0, 1, 0.5, 0.5, 1, 1, 0, 0, 0, 0, 0, 0.5), each = 7),
        c = rep(seq(0, 1, 0.05), each = 7),
        rep(c(0, 1, 0, 1, 1, 0, 0, 1, 1, 1), each = 3)
      )
      simple_array <- array(values, dim = c(height, width, 4))

      simple_array
    }
    options(ggpattern_array_funcs = list(simple = create_pattern_simple))
    test_raster("simple.png", function() grid.pattern("simple", x, y, type = "b"))

    # clippingPathGrob()
    clippee <- patternGrob("circle", gp = gpar(col = "black", fill = "yellow"),
                           spacing = 0.1, density = 0.5)
    angle <- seq(2 * pi / 4, by = 2 * pi / 6, length.out = 7)
    x_hex_outer <- 0.5 + 0.5 * cos(angle)
    y_hex_outer <- 0.5 + 0.5 * sin(angle)
    x_hex_inner <- 0.5 + 0.25 * cos(rev(angle))
    y_hex_inner <- 0.5 + 0.25 * sin(rev(angle))
    clipper <- grid::pathGrob(x = c(x_hex_outer, x_hex_inner),
                              y = c(y_hex_outer, y_hex_inner),
                              id = rep(1:2, each = 7),
                              rule = "evenodd")
    clipped <- clippingPathGrob(clippee, clipper, use_R4.1_clipping = FALSE)
    test_raster("clipGrob.png", function() grid.draw(clipped))

    # alphaMaskGrob()
    clipper <- editGrob(clipper, gp = gpar(col = NA, fill = "black"))
    masked <- alphaMaskGrob(clippee, clipper, use_R4.1_masks = FALSE)
    test_raster("alphaMaskGrob.png", function() grid.draw(masked))

    clippee <- rectGrob(gp = gpar(fill = "blue", col = NA))
    clipper <- editGrob(clipper, gp = gpar(col = "black", lwd=20, fill = rgb(0, 0, 0, 0.5)))
    masked <- alphaMaskGrob(clippee, clipper, use_R4.1_masks = NULL)
    test_raster("alphaMaskGrob_transparent.png", function() grid.draw(masked))

    clippee <- rectGrob(gp = gpar(fill = "blue", col = NA))
    clipper <- editGrob(clipper, gp = gpar(col = "black", lwd=20, fill = rgb(0, 0, 0, 0.5)))
    masked <- alphaMaskGrob(clippee, clipper, use_R4.1_masks = FALSE, png_device = grDevices::png)
    test_raster("alphaMaskGrob_cairo.png", function() grid.draw(masked))

    # ambient
    skip_if_not_installed("ambient")
    set.seed(42)
    test_raster("ambient.png", function() grid.pattern_ambient(x, y, fill = "green", fill2 = "blue"))
    set.seed(42)
    test_raster("ambient_worley.png",
                function() grid.pattern_ambient(x, y, type = "worley", fill = "green", fill2 = "blue"))
})
