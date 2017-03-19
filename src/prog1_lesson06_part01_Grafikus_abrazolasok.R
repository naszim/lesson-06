#########################
# Grafikus ábrázolások  #
# Programozás I.        #
# 6. óra                #
# 2017-03-21            #
#########################

#---Adatok előkészítése a vizualizációkhoz--------------------------------------
# reshape2 installálása és behívása
# install.packages("reshape2", dependencies = TRUE)
library(reshape2)

# data frame létrehozása - wide format
# sokszor vannak ilyen formában az adataink, pl SPSS is így tárol
wide_df <- data.frame(subject = c(1, 2, 3, 4), sex = c("M", "F", "F", "M"),
                      control = c(7.9, 6.3, 9.5, 11.5),
                      cond1 = c(12.3, 10.6, 13.1, 13.4),
                      cond2 = c(10.7, 11.1, 13.8, 12.9))
wide_df

# átalakítás long formatra a melt függvénnyel
# id.vars: kategóriát tartalmazó oszlop(ok), amit meg akarunk tartani
melt(wide_df, id.vars=c("subject", "sex"))

# átalakítás long formatra további opciókkal
# measure.vars: értéket, gyakoriságokat tartalmazó forrás oszlopok
# variable.name: új oszlop neve, hogy az érték, gyakoriság honnan jön
# value.name: értéket, gyakoriságot tartalmazó új oszlop neve
long_df <- melt(wide_df, id.vars=c("subject", "sex"),
                measure.vars=c("control", "cond1", "cond2" ), 
                variable.name="condition",
                value.name="measurement")
long_df


#---Oszlopdiagramok (Bar Graphs)------------------------------------------------
### Egyszerű oszlopdiagram - érték ábrázolása
# R Graphics Cookbook könyv adatait tartalmazó package és ggplot2 installálása
# install.packages("gcookbook", dependencies = TRUE)
# install.packages("ggplot2", dependencies = TRUE)

# package-ek behívása
library(gcookbook)
library(ggplot2)

# pg_mean dataset: Means of results from an experiment on plant growth
pg_mean

## oszlopdiagram ggplot2-vel
# bar graph-ot készítünk: geom_bar
# értéket ábrázolunk: stat = "identity"
ggplot(data = pg_mean, aes(x = group, y = weight)) + 
  geom_bar(stat = "identity", fill="#AFC0CB") +
  ggtitle("Means of results from an experiment on plant growth") +
  theme(plot.title = element_text(hjust = 0.5))

## base oszlopdiagram
# bar graph-ot készítünk: barplot függvény
barplot(pg_mean$weight, names.arg = pg_mean$group,
        col = "#AFC0CB", border = FALSE,
        main = "Means of results from an experiment on plant growth")


### Egyszerű oszlopdiagram - gyakoriság ábrázolása

# diamonds dataset: Prices of 50,000 round cut diamonds
head(diamonds)

## ggplot2
# gyakoriságot ábrázolunk: stat = "identity"
ggplot(data = diamonds, aes(x = cut)) + 
  geom_bar(stat = "count", fill="#AFC0CB") +
  ggtitle("Count of diamond cuts") +
  theme(plot.title = element_text(hjust = 0.5))

## base
# adat átalakítása
diamond_cuts <- table(diamonds$cut)
diamond_cuts

barplot(diamond_cuts, col = "#AFC0CB", border = FALSE,
        main = "Count of diamond cuts")


### Csoportosított oszlopdiagram
# cabbage_exp dataset
cabbage_exp

## ggplot2
# csoportosítás egymás melletti oszlopokba
ggplot(cabbage_exp, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(stat = "identity", position = position_dodge())

# csoportosítás egy oszlop több felé osztásával
ggplot(cabbage_exp, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(stat = "identity", position = position_stack())

## base
# adatok átalakítása
cabbage_mat <- matrix(cabbage_exp$Weight, nrow = 2, byrow=TRUE,
                      dimnames = list(c("c39", "c52"), c("d16", "d20", "d21")))
cabbage_mat

# oszlopszínek
mf_col <- c("#FD8210", "#3CC3BD")
# csoportosítás egymás melletti oszlopokba
barplot(cabbage_mat, beside = TRUE, border = NA, col = mf_col)
# legend hozzáadása
legend("topright", row.names(cabbage_mat), pch = 15, col = mf_col)

# csoportosítás egy oszlop több felé osztásával
barplot(cabbage_mat, border = NA, col = mf_col)
legend("topright", row.names(cabbage_mat), pch = 15, col = mf_col)


#---Vonaldiagramok (Line Graphs)------------------------------------------------
### Egyszerű vonaldiagramok

# BOD dataset: Biochemical Oxygen Demand
BOD

## ggplot2
# line graph-ot csinálunk: geom_line
# time numerikus adat
ggplot(BOD, aes(x = Time, y = demand)) + geom_line()

# ha a time faktor
BOD1 <- BOD
BOD1$Time <- factor(BOD1$Time)
# group = 1 használata, hogy tudja, hogy összetartoznka a pontok
ggplot(BOD1, aes(x = Time, y = demand, group = 1)) + geom_line()

## base
# line graph-ot csinálunk: plot függvény type = "l" argumentummal 
plot(BOD$Time, BOD$demand, type = "l", xlab = "time", ylab = "total bill")

# y-tengely most nem időt jelöl, hanem más folytonos változó
# data frame definiálása
dat1 <- data.frame(
  time = factor(c("Lunch","Dinner"), levels=c("Lunch","Dinner")),
  total_bill = c(14.89, 17.23)
)
dat1

## ggplot2
# árak ábrázolása az étkezések függvényében
ggplot(data = dat1, aes(x = time, y = total_bill, group = 1)) + geom_line() 

# vonal egyéb opciókkal (szín, típus, méret)
# pontok hozzáadása a geom_point-tal
ggplot(data = dat1, aes(x = time, y = total_bill, group = 1)) + 
    geom_line(colour = "red", linetype = "dashed", size = 1.5) + 
    geom_point(colour = "red", size = 4, shape = 21, fill = "white")

## base
plot(c(1, 2), dat1$total_bill, type = "l", xlab = "time", ylab = "", lty = 2,
     lwd = 3, col = "red")
points(c(1, 2), dat1$total_bill, pch = 21, col = "red", cex = 2, bg = "white",
       lwd = 3)


### Többszörös vonaldiagramok

# data frame definiálása
dat2 <- data.frame(
  sex = factor(c("Female", "Female", "Male", "Male")),
  time = factor(c("Lunch", "Dinner", "Lunch", "Dinner"),
  levels = c("Lunch", "Dinner")),
  total_bill = c(13.53, 16.81, 16.24, 17.42))
dat2

## ggplot2
# a nem szerint szeretnénk több vonalat: group = sex
# a színezést is a nem szerint szeretnénk: colour = sex
ggplot(data = dat2, aes(x = time, y = total_bill, group = sex, colour = sex)) +
  geom_line() + geom_point() + ggtitle("Average Bill for Two People") + 
  xlab("Time of day") + ylab("Total bill") +
  theme(plot.title = element_text(hjust = 0.5))

## base
# adat átalakítása
dat2_mat <- matrix(dat2$total_bill, nrow = 2, byrow=TRUE, 
                   dimnames = list(c("Female", "Male"), c("Lunch", "Dinner")))
dat2_mat

par(cex = 1.2, cex.axis = 1.1)
matplot(dat2_mat, type = "b", lty = 1, pch = 19, col = mf_col, cex = 1.5, 
        lwd = 3, las = 1, bty = "n", xaxt = "n", xlim = c(0.7, 2.2), 
        ylim = c(12,18), xlab = "Time of day", ylab = "Total bill",
        main = "Average Bill for Two People")
mtext("Lunch", side = 1, at = 1)
mtext("Dinner", side = 1, at = 2)
legend("topleft", c("Lunch", "Dinner"), pch = 15, col = mf_col)


#---Pontfelhődiagramok/szórásdiagramok (Scatter plots)--------------------------
### Egyszerű szórásdiagramok

set.seed(955)
# data frame definiálása
dat3 <- data.frame(cond = rep(c("A", "B"), each = 10),
                   xvar = 1:20 + rnorm(20, sd = 3),
                   yvar = 1:20 + rnorm(20, sd = 3))
head(dat3)

## ggplot2
# scatter plot: geom_point
# shape = 1 üres karika
ggplot(dat3, aes(x = xvar, y = yvar)) + geom_point(shape = 1)

## base
# scatter plotot csinálunk: plot függvény defaultja
plot(dat3$xvar, dat3$yvar)

## ggplot2
# lineáris regresszió illesztése 95%-os konfidencia intervallummal
ggplot(dat3, aes(x = xvar, y = yvar)) + geom_point(shape = 1) +
  geom_smooth(method = lm)

# konfidencia intervallum nélkül
ggplot(dat3, aes(x = xvar, y = yvar)) + geom_point(shape = 1) +
  geom_smooth(method = lm, se = FALSE)

# loess görbe
ggplot(dat3, aes(x = xvar, y = yvar)) + geom_point(shape = 1) +
  geom_smooth(method = loess)

## base
# ugyanaz, mint előbb, csak formulával
plot(yvar ~ xvar, dat3)
fitline <- lm(dat3$yvar ~ dat3$xvar)
abline(fitline)


### Csoportra bontott szórásdiagramok

## ggplot2
# kondíció szerint színekre szétbontva
# lineáris regressziós vonallal
ggplot(dat3, aes(x = xvar, y = yvar, color = cond)) + 
  geom_point(shape = 1) + 
  geom_smooth(method = lm, se = FALSE, fullrange = TRUE)

# kondíció szerint formákra szétbontva
ggplot(dat3, aes(x = xvar, y = yvar, shape = cond)) + 
  geom_point()

## base
plot(dat3$xvar, dat3$yvar, col = dat3$cond)

plot(dat3$xvar, dat3$yvar, pch = unclass(dat3$cond))
legend("bottomright", legend=levels(dat3$cond), pch=c(1:3))


### Annotált szórásdiagramok
# countries dataset: Health and economic data about countries around the world
countries_sub <- subset(countries, Year == 2009 & healthexp > 2000)
head(countries_sub)

## ggplot2
# geom_text-tel annotálunk
ggplot(countries_sub, aes(x = healthexp, y = infmortality)) + 
  geom_point() +
  geom_text(aes(label = Name), size = 4)

## base
# text függvénnyel annotálunk
plot(countries_sub$healthexp, countries_sub$infmortality,
     main = "Health vs mortality")
text(countries_sub$healthexp, countries_sub$infmortality, 
     labels = as.character(countries_sub$Name), cex = 0.8)


### Szórásdiagram mátrix
source("src/prog1_lesson06_part01_Grafikus_abrazolasok_functions.R")
c2009 <- subset(countries, Year == 2009, 
                select = c(Name, GDP, laborrate, healthexp, infmortality))

pairs(c2009[,2:5])

pairs(c2009[,2:5], upper.panel = panel.cor,
      diag.panel = panel.hist, lower.panel = panel.lm)


#---Eloszlások ábrázolása-------------------------------------------------------
### Hisztogramok és sűrűségfüggvények
# faithful dataset: Old Faithful Geyser Data
head(faithful)

## ggplot2
# hisztogram: geom_histogram
ggplot(faithful, aes(x = waiting)) + geom_histogram()

# alapból túl sok bin-re van osztva az adat, túl finom felosztás
# a binek nagyságát a binwidth argumentummal tudjuk változtatni
ggplot(faithful, aes(x = waiting)) +
 geom_histogram(binwidth = 5, fill = "white", colour = "black")

### hisztogram
## base
# hist függvény
hist(faithful$waiting)
# breaks argumnetummal tudunk állítani
hist(faithful$waiting, breaks = 6)

### sűrűségfüggvény görbéje
## ggplot2
# sűrűségfüggvény görbéje: geom_density
ggplot(faithful, aes(x = waiting)) + geom_density()

# hisztogram és sűrűségfüggvény görbéje együtt
ggplot(faithful, aes(x = waiting)) + 
    geom_histogram(aes(y = ..density..), binwidth = 5, 
                   colour = "black", fill = "white") +
    geom_density(alpha = .2, fill = "#FF6666")

## base
plot(density(faithful$waiting))

### átlag berajzolása
## ggplot2
# függőleges vonal: geom_vline (vízszintes vonal: geom_hline)
ggplot(faithful, aes(x = waiting)) +
    geom_histogram(binwidth = 5, colour = "black", fill = "white") +
    geom_vline(aes(xintercept = mean(waiting)),
               color = "red", linetype = "dashed", size = 1)

## base
hist(faithful$waiting)
abline(v = mean(faithful$waiting), col = "red", lwd = 2, lty = 1)

### Több csoport hisztogramja és sűrűségfüggvény görbéje
# data frame definiálása
set.seed(1234)
dat4 <- data.frame(cond = factor(rep(c("A","B"), each = 200)), 
                   rating = c(rnorm(200), rnorm(200, mean = .8)))

## ggplot2
# hisztogram
ggplot(dat4, aes(x = rating, fill = cond)) +
    geom_histogram(binwidth = .5, alpha = .5, position = "identity")

# sűrűségfüggvény
ggplot(dat4, aes(x = rating, colour = cond)) + geom_density()

## base
# hisztogram
hist(subset(dat4, cond == "A")$rating, 
     col = rgb(0, 0, 1, 1/4), xlim = c(-5, 5))
hist(subset(dat4, cond == "B")$rating, 
     col = rgb(1, 0, 0, 1/4), xlim = c(-5, 5),
     breaks = 10, add = T)

# sűrűségfüggvény
# sm package-gel lehet


### Box plotok
## ggplot2
# geom_boxplot
ggplot(dat4, aes(x = cond, y = rating, fill=cond)) + geom_boxplot()

## base
# boxplot függvény
boxplot(dat4$rating ~ dat4$cond, data = dat4, col=c('mistyrose', 'powderblue'))


#---Plotok kimentése------------------------------------------------------------
# új mappa létrehozása a plotoknak
dir.create("fig", showWarnings = FALSE)

## ggplot2
ggplot(dat4, aes(x = cond, y = rating, fill=cond)) + geom_boxplot()
# amilyen kiterjesztést megadunk a fájlnévben, olyanba menti ki
# pdf, jpeg, svg, eps, png stb.
ggsave("fig/ggplot2_boxplot.png", width = 10, height = 5, dpi = 100)

## base
# pdf, svg, png stb. függvények attól függően, hogy mibe szeretnénk menteni
png("fig/base_boxplot.png", width = 960, height = 560, res = 120)
boxplot(dat4$rating ~ dat4$cond, data = dat4, col=c('mistyrose', 'powderblue'))
dev.off()
