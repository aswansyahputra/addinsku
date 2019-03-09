#' R Views
#'
#' Baca blog R Views

baca_rviews <- function() {
  if (rstudioapi::hasFun("viewer")) {
    rstudioapi::viewer("https://rviews.rstudio.com/")
  } else {
    utils::browseURL("https://rviews.rstudio.com/")
  }
}

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

#' Menambahkan repositori GitHub
#'
#' Menambahkan repositori GitHuB sebagai remote repository
#'
#' @import shiny miniUI

tambah_repo_github <- function(){
  ui <- miniPage(
    gadgetTitleBar(
      title = "Menambahkan Repositori GitHub",
      left = miniTitleBarCancelButton(
        inputId = "batal",
        label = "Batalkan",
        primary = TRUE
      ),
      right = miniTitleBarButton(
        inputId = "ok",
        label = "OK",
        primary = TRUE
      )
    ),
    miniContentPanel(
      fillCol(
        flex = c(1, 1, NA, NA),
        fillRow(
          textInput(
            inputId = "akun_github",
            "Akun GitHub:",
            value = "aswansyahputra",
            width = "90%"
          ),
          textInput(
            inputId = "repo_github",
            "Repositori GitHub:",
            value = "repoku",
            width = "90%"
          )
        ),
        fillRow(
          textInput(
            inputId = "nama_remote",
            "Nama repositori:",
            value = "origin",
            width = "90%"
          ),
          radioButtons(
            "metode",
            label = "Metode",
            choices = c("SSH", "HTTPS")
          )
        ),
        strong("Kode:"),
        verbatimTextOutput("teks_skrip")
      )
    )
  )

  server <- function(input, output, session) {

    skrip <- reactive({
      paste0(
        "git remote add ",
        input$nama_remote,
        " ",
        switch(input$metode,
                "SSH" = "git@github.com:",
                "HTTPS" = "https://github.com/"
        ),
        input$akun_github,
        "/",
        input$repo_github,
        ".git"
      )
    })

    output$teks_skrip <- renderText({
      skrip()
    })

    observeEvent(input$batal, {
      stopApp()
    })

    observeEvent(input$ok, {

      if (!dir.exists(".git")) {
        stopApp("Aktifkan sistem git pada direktori kerja terlebih dahulu!")
      } else{
        system(skrip())
        stopApp(
          rstudioapi::showDialog(
            title = "",
            message = "Repositori GitHub telah berhasil ditambahkan! Silakan mulai ulang sesi R terlebih dahulu."
          )
        )
      }
    })
  }
  runGadget(app = ui, server = server, viewer = paneViewer(275), stopOnCancel = FALSE)
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


