# read pvsyst files
# readPVsyst = 
#   function(file)
#   {
#     p2 = read.csv(file, skip = 14, header = FALSE)
#     h = read.csv(file, skip = 12, nrow = 1, header = FALSE)
#     names(p2) = h[1,]
#     p2
#   }

pv = lapply(pvsyst, readPVsyst)
names(pv) = basename(pvsyst)

table(sapply(pv, class))
table(sapply(pv, nrow))
table(sapply(pv, ncol))

nlines = sapply(pv.files, function(x) length(readLines(x, encoding = "latin1")))
nlines - sapply(pv, nrow)

if(!require("clifro"))
  install.packages("clifro")

library(clifro)
windrose(pv[[1]]$WindVel, pv[[1]]$WindDir)

pv.all = do.call(rbind, pv)
pv.all$location = rep(pv.files, sapply(pv, nrow))
windrose(pv.all$WindVel, pv.all$WindDir, pv.all$location, n_col = 2)

pairs(pv[[1]][, -c(1, 5)], pch = ".", diag.panel = function(x, ...) { 
  usr = par()$usr 
  on.exit(par(usr = usr))
  if(is.integer(x))
    hist(x, add = TRUE)
  else {		
    d = density(x)	
    par(usr = c(usr[1:2], 0, max(d$y)*1.04))
    lines(d)
  }
})

p = read.csv(pv.files[1], row.names = NULL)

dim(p)

length(readLines(pv.files[1]))

library(readr)
p = read_csv(pv.files[1])

p = read_csv(pv.files[1], skip = 12)

sapply(p, class)

head(p)

p1 = p[-1,]
w = sapply(p1, is.character)
p1[w] = sapply(p1[w], as.numeric)

p = read_csv(pv.files[1], skip = 12)
p1 = p[-1,]
w = sapply(p, is.character)
p1[w] = sapply(p1[w], as.numeric)
p1 = as.data.frame(p1) # to convert from a tibble.

p = read_csv(pv.files[1], skip = 12, locale = locale(encoding = "latin1"))