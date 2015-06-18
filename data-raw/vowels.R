datafile <- 'data-raw/data.csv'

vowels <- read.csv(datafile)

# Sensible zero efects

vowels$v1 <- relevel(vowels$v1, 'i')
vowels$context <- relevel(vowels$context, 'short')

# Enforce consistent coding: 'nn' and 'rr' are actually the same
# consonant as 'n' and 'r', the only difference should be the context

vowels$c1[vowels$c1 == 'nn'] <- 'n'
vowels$c1[vowels$c1 == 'rr'] <- 'r'

# Calculate stuff

vowels <- mutate(vowels,
                 v1.dur = v1.end - v1.start,
                 v2.dur = v2.end - v2.start,
                 hv1.dur = v1.end - v1.pre.start,
                 hv1h.dur = v1.post.end - v1.pre.start,
                 v1h.dur = v1.post.end - v1.start,
                 v2h.dur = v2.post.end - v2.start,
                 v1.v2.ratio = v1.dur / v2.dur,
                 hv1.v2.ratio = hv1.dur / v2.dur,
                 hv1h.v2.ratio = hv1h.dur / v2.dur,
                 v1h.v2.ratio = v1h.dur / v2.dur,
                 c1.dur = c1.end - c1.start,
                 hc1.dur = c1.end - v1.post.start,
                 c1h.dur = v2.pre.end - c1.start,
                 hc1h.dur = v2.pre.end - v1.post.start,
                 v1.c1.ratio = v1.dur / c1.dur,
                 v1.hc1.ratio = v1.dur / hc1.dur,
                 v1h.c1.ratio = v1h.dur / c1.dur,
                 v1.vot = v1.pre.end - v1.pre.start,
                 v2.vot = v2.pre.end - v2.pre.start,
                 c1.preasp.dur = c1.start - v1.post.start,
                 h1.hch.ratio = c1.preasp.dur / hc1h.dur,
                 c.hch.ratio = c1.dur / hc1h.dur,
                 h2.hch.ratio = v2.vot / hc1h.dur,
                 v1h.v2h.ratio = v1h.dur / v2h.dur)

pre.means <- filter(vowels, context != 'cluster', c.hch.ratio < 100) %>%
             group_by(c1) %>%
             summarize(mean.hc = mean(h1.hch.ratio, na.rm = TRUE),
                       mean.c = mean(c.hch.ratio, na.rm = TRUE),
                       mean.ch = mean(h2.hch.ratio, na.rm = TRUE),
                       mean.post.dur = mean(v2.vot, na.rm = TRUE),
                       mean.c.dur = mean(c1.dur, na.rm = TRUE),
                       mean.pre.dur = mean(c1.preasp.dur, na.rm = TRUE))

pre.shares.melted <- melt(pre.means, id.vars=('c1'), measure.vars=c('mean.hc', 'mean.c', 'mean.ch'))
pre.durs.melted <- melt(pre.means, id.vars=('c1'), measure.vars=c('mean.pre.dur', 'mean.c.dur', 'mean.post.dur'))

pre.shares.plot <- ggplot(pre.shares.melted, aes(c1, value, fill=variable))+geom_bar(stat='identity')+coord_flip()
pre.durs.plot <- ggplot(pre.durs.melted, aes(c1, value, fill=variable))+geom_bar(stat='identity')+coord_flip()

vowels$final.closed <- recode(vowels$word,
                          'c("llipa", "gwella", "gyrru", "honni", "suddo", "colli", "pysgota", "tyfu", "plygu", "felly", "llogi", "siglo", "boddi", "ysbyty", "torri", "heddlu", "hybu", "cyfle", "hwnnw", "bore", "cwta", "cludo", "llety", "Guto", "curo", "geni", "copi", "trefnu", "lludw", "pobi", "prynu", "codi")=F;
c("pobol", "popeth", "dilyn", "personol", "cwpan", "dillad", "ennill", "cyfan", "sydyn", "seren", "dwsin", "tocyn", "prysur", "gogledd", "gofyn", "difyr", "bwgan", "pecyn", "ifanc", "lwcus", "ffyddlon", "defod", "pryder", "gofal", "cwpwrdd", "enillwch", "crwtyn", "pennod", "diweddar", "cynnal", "llinell", "ffrwgwd", "Nadolig", "cyllell", "cwbwl", "cyson", "neges", "byddin", "rhedeg", "edrych", "posib", "Ebrill", "digon", "sefyll", "gelyn", "ffenestr", "rheswm", "problem", "hollol", "dibyn", "tybed", "llygad", "wedyn", "tipyn", "bwced", "tebyg", "mwdwl", "cwlwm", "trefnu", "cerrig", "brodor", "modryb", "isod", "diben", "unig", "tlotyn", "gosod", "brodorol", "meddwl")=T;else=NA')

vowels$c.manner <- recode(vowels$c1, 'c("v", "\\\\dh")="v.fricative";c("s","\\\\l-")="vl.fricative";c("p","t","k")="vl.stop";c("b","d","g")="v.stop";else="sonorant"')

vowels$c.place <- recode(vowels$c1, 'c("p", "b", "v")="labial";c("t","d","\\\\dh","s","\\\\l-","n", "r", "l")="coronal";c("k","g")="dorsal"')

vowels$v2.is.high <- vowels$v2 %in% c("i", "u")

vowels$v1.is.long <- vowels$context == 'long'

v1.df <- select(vowels, speaker, v1, v1.f1, v1.f2, v1.dur, v1h.dur, context)
v1.df$pos <- 'v1'
v2.df <- select(vowels, speaker, v2, v2.f1, v2.f2, v2.dur, v2h.dur)
v2.df$pos <- 'v2'
v2.df$context <- 'posttonic'

vowels.all <- rbind(plyr::rename(v1.df, c('v1'='v', 'v1.f1'='v.f1', 'v1.f2'='v.f2', 'v1.dur'='v.dur', 'v1h.dur'='vh.dur')),
              plyr::rename(v2.df, c('v2'='v', 'v2.f1'='v.f1', 'v2.f2'='v.f2', 'v2.dur'='v.dur', 'v2h.dur'='vh.dur')))

vowel.stats <- vowels.all %>%
               group_by(speaker) %>%
               summarize(v.f1.mean = mean(v.f1, na.rm = TRUE),
                         v.f2.mean = mean(v.f2, na.rm = TRUE),
                         v.f1.sd = sd(v.f1, na.rm = TRUE),
                         v.f2.sd = sd(v.f2, na.rm = TRUE),
                         v.dur.mean = mean(v.dur, na.rm = TRUE),
                         v.dur.sd = sd(v.dur, na.rm=TRUE),
                         vh.dur.mean = mean(vh.dur, na.rm = TRUE),
                         vh.dur.sd = sd(vh.dur, na.rm=TRUE))

vowels.all$ctx <- recode(vowels.all$context, "'posttonic'='posttonic';'long'='long';else='short'")
vowels.all$ctx <- factor(vowels.all$ctx, levels=c('short', 'long', 'posttonic'))


vowels <- merge(vowels, vowel.stats)
vowels.all <- merge(vowels.all, vowel.stats)

consonant.stats <- vowels %>%
                   group_by(speaker) %>%
                   filter(c1.preasp.dur > 0) %>%
                   summarize(c1.preasp.dur.mean = mean(c1.preasp.dur, na.rm = TRUE),
                             c1.preasp.dur.sd = sd(c1.preasp.dur, na.rm = TRUE),
                             c1.dur.mean = mean(c1.dur, na.rm = TRUE),
                             c1.dur.sd = mean(c1.dur, na.rm = TRUE))
vowels <- merge(vowels, consonant.stats)

## Normalize everything

vowels$v1.f1.norm <- (vowels$v1.f1 - vowels$v.f1.mean) / vowels$v.f1.sd
vowels$v1.f2.norm <- (vowels$v1.f2 - vowels$v.f2.mean) / vowels$v.f2.sd
vowels$v2.f1.norm <- (vowels$v2.f1 - vowels$v.f1.mean) / vowels$v.f1.sd
vowels$v2.f2.norm <- (vowels$v2.f2 - vowels$v.f2.mean) / vowels$v.f2.sd

vowels$v1.dur.norm <- (vowels$v1.dur - vowels$v.dur.mean) / vowels$v.dur.sd
vowels$v2.dur.norm <- (vowels$v2.dur - vowels$v.dur.mean) / vowels$v.dur.sd

vowels$v1h.dur.norm <- (vowels$v1h.dur - vowels$vh.dur.mean) / vowels$vh.dur.sd
vowels$v2h.dur.norm <- (vowels$v2.dur - vowels$vh.dur.mean) / vowels$vh.dur.sd

vowels.all$v.dur.norm <- (vowels.all$v.dur - vowels.all$v.dur.mean) / vowels.all$v.dur.sd
vowels.all$vh.dur.norm <- (vowels.all$vh.dur - vowels.all$vh.dur.mean) / vowels.all$vh.dur.sd

vowels$c1.preasp.dur.norm <- ifelse(vowels$c1.preasp.dur > 0,
                                  (vowels$c1.preasp.dur - vowels$c1.preasp.dur.mean) / vowels$c1.preasp.dur.sd,
                                  NA)
vowels$c1.dur.norm <- (vowels$c1.dur - vowels$c1.dur.mean) / vowels$c1.dur.sd

devtools::use_data(vowels, overwrite = T)
devtools::use_data(vowels.all, overwrite = T)
