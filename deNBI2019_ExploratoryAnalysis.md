Exploratory Data Analysis
========================================================
author: Jing Xu (Applied Bioinformatics (B330), DKFZ)
date: 2019-03-08
autosize: true
width: 1440
height: 900



Outline
========================================================
- Inspecting your data
- Learn to use **dplyr** package
- Descriptive statistics
- Basic plotting functions


Inspect your data 
========================================================
**It's extremely important to work with clean data!** Excel sheets always use free text boxes which may contain lots of garbage, you cannot even read the mess into R! Sometimes you can get data into R, but 

- Does it follow "one column one data type" rules? 
- In each column, do call the formats look alike? Can they be separate by regular expression?
- In each column, are all the values in correct format as required? (e.g. character format, date format, number range ...) Identify the wrong ones and try to fix them.
- Convert missing values to NA


Some examples of bad data...
========================================================
1. A column named "cell number"...

```
[1] "1970000"       "11800000"      "9.23E04 cells"
```

```
[1]  1970000 11800000       NA
```


```r
# which value is not a number?
suppressWarnings(
    cellnumber[which(is.na(as.numeric(cellnumber)))]
    )
```

```
[1] "9.23E04 cells"
```

```r
# which values are numbers?
suppressWarnings(
    cellnumber[which(!is.na(as.numeric(cellnumber)))]
    )
```

```
[1] "1970000"  "11800000"
```


=======================================================
How to fix this with R?

```r
cellnumber[which(is.na(as.numeric(cellnumber)))] <- "9.23E04"
cellnumber <- as.numeric(cellnumber)
cellnumber
```

```
[1]  1970000 11800000    92300
```

But what if there are many values like this?

```r
ind <- which(is.na(as.numeric(cellnumber)))

# method 1. string split
as.numeric(unlist(strsplit(as.character(cellnumber[ind]), " "))[1])

# method 2. string split by sapply
as.numeric(sapply(strsplit(as.character(cellnumber[ind]), " "), "[[", 1))
```
Pandoc bug... cannot display the results correctly, you can try to run it in R console.


Explore Iris dataset (demo)
========================================================
As you already know this dataset contains the length and the width of the sepals and petals of 3 Iris species, and there are 50 samples per species, but how do you know?

```r
names(iris)
```

```
[1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width" 
[5] "Species"     
```

```r
table(iris$Species)
```

```

    setosa versicolor  virginica 
        50         50         50 
```


Get to know 'dplyr' for data frames
========================================================
* Selecting columns with long variables names or subset data based on multiple columns can produce lengthy code, which is very difficult to read. The 'dplyr' package provides a handful of useful functions for easy data frame manipulation:

    - `filter()` to select cases based on their values.
    - `arrange()` to reorder the cases.
    - `select()` and `rename()` to select variables based on their names.
    - `mutate()` and `transmute()` to add new variables that are functions of existing variables.
    - `summarise()` to condense multiple values to a single value.
    - `group_by()`to group data based on variable(s)

* You can pipe your code by `%>%`


Select and filter 
========================================================

```r
names(iris)
```

```
[1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width" 
[5] "Species"     
```

```r
iris[iris$Sepal.Width>4,c("Species", "Sepal.Width", "Sepal.Length")]
```

```
   Species Sepal.Width Sepal.Length
16  setosa         4.4          5.7
33  setosa         4.1          5.2
34  setosa         4.2          5.5
```


```r
# dplyr package is loaded in setup chunk
iris %>% select(Species, Sepal.Width, Sepal.Length) %>% filter(Sepal.Width>4)
```

```
  Species Sepal.Width Sepal.Length
1  setosa         4.4          5.7
2  setosa         4.1          5.2
3  setosa         4.2          5.5
```


Mutate and arrange
========================================================

```r
Data <- iris %>% 
        mutate(height= sample(seq(30.0, 50.0, by=0.2), nrow(iris), replace = T )) %>%
        filter(height > 40) %>%        
        dplyr::select(Species, Sepal.Length, Sepal.Width, height) %>% 
        arrange(height)

head(Data) 
```

```
     Species Sepal.Length Sepal.Width height
1 versicolor          5.6         3.0   40.2
2  virginica          6.8         3.0   40.4
3  virginica          6.9         3.2   40.4
4 versicolor          6.6         2.9   41.0
5 versicolor          5.0         2.3   41.0
6     setosa          5.0         3.3   41.2
```



Data distribution
========================================================
Overview of total distribution by `summary()`

```
  Sepal.Length    Sepal.Width     Petal.Length    Petal.Width   
 Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100  
 1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300  
 Median :5.800   Median :3.000   Median :4.350   Median :1.300  
 Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199  
 3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800  
 Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500  
       Species  
 setosa    :50  
 versicolor:50  
 virginica :50  
                
                
                
```


========================================================

```r
par(mfrow =c(1,2))
graphics::boxplot(iris[,names(iris) != "Species"], main="Boxplot", xlab="measurement", ylab="values")
graphics::boxplot(iris[,names(iris) != "Species"], 
        main="Boxplot", xlab="measurement", ylab="values",
        col=c("red", "blue", "green", "yellow") )
```

<img src="deNBI2019_ExploratoryAnalysis-figure/unnamed-chunk-10-1.png" title="plot of chunk unnamed-chunk-10" alt="plot of chunk unnamed-chunk-10" style="display: block; margin: auto;" />



Calculation based on a variable
========================================================
* Use `tapply(vector, index, function)`

```r
tapply(iris$Sepal.Length, iris$Species, mean)
```

```
    setosa versicolor  virginica 
     5.006      5.936      6.588 
```

```r
tapply(iris$Sepal.Width, iris$Species, mean)
```

```
    setosa versicolor  virginica 
     3.428      2.770      2.974 
```

```r
tapply(iris$Petal.Length, iris$Species, mean)
```

```
    setosa versicolor  virginica 
     1.462      4.260      5.552 
```

```r
tapply(iris$Sepal.Width, iris$Species, mean)
```

```
    setosa versicolor  virginica 
     3.428      2.770      2.974 
```

========================================================
* Use `group_by` and `summarise_at` from `dplyr` package

```r
iris %>% 
    group_by(Species) %>%
    summarise(mean=mean(Sepal.Length))
```

```
# A tibble: 3 x 2
  Species     mean
  <fct>      <dbl>
1 setosa      5.01
2 versicolor  5.94
3 virginica   6.59
```


========================================================

```r
par(mfrow =c(1,2))
graphics::boxplot(iris$Sepal.Width ~ as.factor(iris$Species), 
                  col=c("red", "blue", "green")) 
graphics::boxplot(iris$Sepal.Length ~ as.factor(iris$Species), 
                  col=c("red", "blue", "green")) 
```

<img src="deNBI2019_ExploratoryAnalysis-figure/unnamed-chunk-13-1.png" title="plot of chunk unnamed-chunk-13" alt="plot of chunk unnamed-chunk-13" style="display: block; margin: auto;" />


Correlation
========================================================
Is there any correlation between these variables?
It's a good idea to plot your data first!

```r
pairs(iris[1:4])
```

<img src="deNBI2019_ExploratoryAnalysis-figure/unnamed-chunk-14-1.png" title="plot of chunk unnamed-chunk-14" alt="plot of chunk unnamed-chunk-14" style="display: block; margin: auto;" />

========================================================

```r
pairs(iris[1:4], main="pair-wise correlation in Iris Data", pch=21, bg=c("red", "green3", "blue")[unclass(iris$Species)])
```

<img src="deNBI2019_ExploratoryAnalysis-figure/unnamed-chunk-15-1.png" title="plot of chunk unnamed-chunk-15" alt="plot of chunk unnamed-chunk-15" style="display: block; margin: auto;" />


Test correlations
========================================================

```r
cor.test(iris$Petal.Length, iris$Sepal.Width, method="spearman")
```

```

	Spearman's rank correlation rho

data:  iris$Petal.Length and iris$Sepal.Width
S = 736640, p-value = 0.0001154
alternative hypothesis: true rho is not equal to 0
sample estimates:
       rho 
-0.3096351 
```

```r
cor.test(iris$Petal.Length, iris$Sepal.Length, method = "spearman")
```

```

	Spearman's rank correlation rho

data:  iris$Petal.Length and iris$Sepal.Length
S = 66429, p-value < 2.2e-16
alternative hypothesis: true rho is not equal to 0
sample estimates:
      rho 
0.8818981 
```

========================================================
You may also check paired correlation for all variables

```r
M <- suppressMessages(stats::cor(iris[1:4]));
M
```

```
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length    1.0000000  -0.1175698    0.8717538   0.8179411
Sepal.Width    -0.1175698   1.0000000   -0.4284401  -0.3661259
Petal.Length    0.8717538  -0.4284401    1.0000000   0.9628654
Petal.Width     0.8179411  -0.3661259    0.9628654   1.0000000
```

========================================================
Use `corrplot` package for visulization

```r
par(mfrow =c(1,2))
corrplot(M)
corrplot(M, method = "number")
```

<img src="deNBI2019_ExploratoryAnalysis-figure/unnamed-chunk-18-1.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" style="display: block; margin: auto;" />


========================================================
# $\color{red}{\text{Congrats! You finish this session!}}$
