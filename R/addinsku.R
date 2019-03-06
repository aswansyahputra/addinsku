#' R for Data Science
#'
#' Baca buku R for Data Science
#'
#' @export

baca_r4ds <- function(){
  rstudioapi::viewer("https://r4ds.had.co.nz/")
}

#' R for Data Science: Exercise Solutions
#'
#' Baca solusi dari latihan soal dalam buku R for Data Science
#'
#' @export

baca_solusi_r4ds <- function(){
  rstudioapi::viewer("https://jrnold.github.io/r4ds-exercise-solutions/")
}


#' Persiapan kerja
#'
#' Mempersiapkan struktur direktori yang direkomendasikan serta memulai sistem git lokal
#'
#' @export

persiapan <- function(){

  if (!dir.exists("R")) {
    dir.create("R")
  }

  if (!dir.exists("data")) {
    dir.create("data")
  }

  if (!dir.exists("data-raw")) {
    dir.create("data-raw")
  }

  if (!file.exists("README.Rmd")) {
    file.create("README.Rmd")
  }

  if (!file.exists(".here")) {
    file.create(".here")
  }

  if (Sys.which("git") != "") {
    system("git init")
  }
}

#' Ganti Skema Tema
#'
#' Mengganti tema RStudio antar skema terang dan gelap
#' @export

ganti_skema <- function() {
  if (rstudioapi::versionInfo()$version != "1.2") {
    stop("Maaf, fungsi ini hanya bekerja pada RStudio versi 1.2.xxx!", call. = FALSE)
  } else {
    tema_skrg <- rstudioapi::getThemeInfo()
    tema_baru <- ifelse(tema_skrg$dark, "TextMate", "Material")
    rstudioapi::applyTheme(tema_baru)
  }
}
