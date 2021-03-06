authors_from_csv <- function(filename, format = "papaja", what = "aut"){

  df <- read.csv(filename, stringsAsFactors = FALSE)

  aff <- df[, 6:ncol(df)]

  unique_aff <- as.vector(t(as.matrix(aff)))
  unique_aff <- unique_aff[!unique_aff == ""]
  unique_aff <- unique_aff[!duplicated(unique_aff)]
  df$affiliation <- apply(aff, 1, function(x){
    paste(which(unique_aff %in% unlist(x)), collapse = ",")
  })

  aff <- do.call(c, lapply(1:length(unique_aff), function(x){
    c(paste0("  - id: \"", x, "\""), paste0("    institution: \"", unique_aff[x], "\""))
  }))


  df$name <- paste(df[[1]], df[[2]])
  aut <- df[, c("name", "affiliation", "corresponding", "address", "email")]
  names(aut) <- paste0("    ", names(aut))
  names(aut)[1] <- "  - name"

  aut <- do.call(c, lapply(1:nrow(aut), function(x){
    tmp <- aut[x, ]
    tmp <- tmp[, !tmp == "", drop  = FALSE]
    out <- paste0(names(tmp), ': "', tmp, '"')
    gsub('\\"yes\\"', "yes", out)
  }))
  if(what == "aff") return(paste0(aff, collapse = "\n")) #cat("\n", aff, sep = "\n")

  if(what == "aut") return(paste0(aut, collapse = "\n")) #cat(aut, "", sep = "\n")

}

