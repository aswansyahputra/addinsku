#' R for Data Science
#'
#' Baca buku R for Data Science

baca_r4ds <- function() {
  if (rstudioapi::hasFun("viewer")) {
    rstudioapi::viewer("https://r4ds.had.co.nz/")
  } else {
    utils::browseURL("https://r4ds.had.co.nz/")
  }
}

#' R for Data Science: Exercise Solutions
#'
#' Baca solusi dari latihan soal dalam buku R for Data Science

baca_solusi_r4ds <- function() {
  if (rstudioapi::hasFun("viewer")) {
    rstudioapi::viewer("https://jrnold.github.io/r4ds-exercise-solutions/")
  } else {
    utils::browseURL("https://jrnold.github.io/r4ds-exercise-solutions/")
  }
}


#' Persiapan kerja
#'
#' Mempersiapkan struktur direktori yang direkomendasikan serta memulai sistem git lokal

persiapan <- function() {
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

  if (Sys.which("git") != "" & !dir.exists(".git")) {
    system("git init")
  }

  if (!file.exists(".gitignore") & dir.exists(".git")) {
    file.create(".gitignore")
    cat(".Rhistory", ".RData", ".Rproj.user", file = ".gitignore", sep = "\n")
  }

  rstudioapi::restartSession()
  rstudioapi::showDialog(
    title = "",
    message = "Direktori kerja Anda telah berhasil disiapkan. Selamat berkerja!"
  )
}

#' Ganti skema tema
#'
#' Mengganti tema RStudio antar skema terang dan gelap

ganti_skema <- function() {
  rstudioapi::verifyAvailable("1.2")
  tema_skrg <- rstudioapi::getThemeInfo()
  tema_baru <- ifelse(tema_skrg$dark, "Textmate (default)", "Material")
  rstudioapi::applyTheme(tema_baru)
}

#' Hapus paket duplikat
#'
#' Menghapus paket yang terpasang lebih dari satu kali

hapus_paket_duplikat <- function() {
  libdir <- .libPaths()
  libpath <- libdir[grep("home", x = libdir)]
  pkgs <- unname(installed.packages()[,1])

  if (anyDuplicated(pkgs) == 0) {
    message("Tidak ada duplikasi paket!")
  } else {
    remove.packages(pkgs[duplicated(pkgs)], lib = libpath)
    message(
      "Paket: ",
      paste0(pkgs[duplicated(pkgs)], collapse = ", "),
      " telah dihapus dari ",
      libpath
    )
  }

}

#' Cadangkan nama paket
#'
#' Mencadangkan nama paket yang saat ini telah terpasang

cadangkan_nama_paket <- function(){
  pkgs <- unname(installed.packages()[,1])
  pkgs <- pkgs[!pkgs %in% c("stats", "graphics", "grDevices", "utils", "datasets", "methods", "base")]
  target <- rstudioapi::selectFile(caption = "Save File",
                                   label = "Save",
                                   filter = "Rda(*.rda)",
                                   existing = FALSE)
  save(pkgs, file = paste0(target, ".rda"))
}

#' Pasang paket tercadangkan
#'
#' Memasang paket-paket yang sebelumnya telah dicadangkan

pasang_paket_tercadangkan <- function(){
  path <- rstudioapi::selectFile(caption = "Pilih berkas nama paket",
                                 filter = "Rda Files (*.rda)",
                                 existing = TRUE)
  load(path)
  install.packages(pkgs)
}


