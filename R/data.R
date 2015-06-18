#' Welsh vowels
#'
#' This contains the main data for the vowels. Each row is a word
#' token (not a vowel! This is not quite tidy data, but since we
#' mostly work with the stressed vowels it saves a lot of
#' boilerplate. Packages like reshape2 or tidy can be used to kick
#' this into shape). There are all sorts of measures given, including
#' word, various phonological characteristics of the context, and
#' durational properties.
#'
#' @format A data frame with a large number of columns. Some more important ones:
#'
#' \describe{
#' \item{\code{v1}, \code{v2}}{The quality of the stressed and post-tonic vowel respectively}
#' \item{\code{c1}, \code{c2}}{The quality of the post-tonic consonant and the second consonant of the cluster, if any}
#' \item{\code{v1.dur}}{The duration of the vocalic portion for the stressed vowel}
#' \item{\code{hv1.dur}}{The duration of the stressed vowel, including the VOT}
#' \item{\code{v1h.dur}}{The duration of the stressed vowel, including the preaspiration following it}
#' \item{\code{hv1h.dur}}{Stressed vowel duration, including both VOT and preaspiration}
#' \item{\code{word}}{The lexical item}
#' \item{\code{speaker}}{The speaker}
#' \item{\code{v1.is.long}}{T for phonologically long vowels, F for short vowels, schwa and vowels before clusters}
#' \item{\code{context}}{All schwas have the value \code{schwa}; otherwise \code{long}, \code{short} or \code{cluster}}
#' \item{\code{filename}}{The file name of the word, for your double-checking needs}
#' \item{\code{v1.f1}, \code{v1.f2}, \code{v2.f1}, \code{v2.f2}}{The F1 and F2 values of each vowel. They also come in normalized versions (\code{v1.f1.norm} etc.)}
#' }
#' 
"vowels"

#' This dataset is most useful for normalization purposes, since it
#' contains data on both stressed and post-tonic vowels in a single
#' format
#'
"vowels.all"
