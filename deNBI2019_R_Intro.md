Introduction to R/Bioconductor
========================================================
author: Jing Xu (Applied Bioinformatics (B330), DKFZ)
date: 2019-03-27
autosize: true
width: 1440
height: 900



Outline
========================================================
- R history
- Introduction to Bioconductor
- Software installation
- Introduction to Rstudio (demo)
- R / Bioconductor package repos
- Getting and exporting data
- Checking help page of R functions


R history
========================================================
- **R** -- a language and environment for statistical computing and graphics based on _S_ language
- created by Ross Ihaka and Robert Gentleman at the University of Auckland (1993)
- currently being developed by the R Development Core Team in Austra ( [R Foundation](https://www.r-project.org/foundation/) )
- free software: 
    + **GNU** is a Unix-like operating system. That means it is a collection of many programs: applications, libraries, developer tools, even games. 
    + General Public License version 2.0, freedom to run, source, redistribute and improvement
- **The Comprehensive R Archive Network (CRAN)** at https://cran.r-project.org/, you can choose a location close to you (select CRAN Mirrors).


Why using R?
========================================================
- Powerful in statistics and graphics
- Free downloads and access to resources
- It compiles and runs on various platforms, such as UNIX, Windows and MacOS 
- Widely used in the community: supports, blogs, tutorials, videos...
- Fast development in packages:

    + CRAN repository: currently 13938 packages available
    + Bioconductor: currently 1649 packages available


Introduction to Bioconductor
========================================================
- **Bioconductor** is open source development project for high-throughput genomic data, started in Fall, 2001 by Robert Gentleman and others
- being developed by Bioconductor core team in Buffalo (USA), funded through National Human Genome Research Institute
- current release: version 3.8 (requires R version later than 3.5.0)
- currently hosts 1649 software packages
- Bioconductor releases once every half a year, which is different from R updates


Installation of R/ R packages
========================================================
- **R** and R packages from CRAN: https://cran.r-project.org/

```r
install.packages("devtools")
```

- **Bioconductor** from https://www.bioconductor.org/

```r
if (!requireNamespace("BiocManager"))
    install.packages("BiocManager")
BiocManager::install("GenomicFeatures")
```


- **Github repo**: mostly unoffcial packages, under development or not intended to publish

```r
require("devtools")
devtools::install_github("developername/packagename")
```


Introduction to Rstudio (Demo)
========================================================
- Integrated Development Environment (IDE) for R, making you more effective in R programming
- Installation via https://www.rstudio.com/products/rstudio/download/
- User interface includes 4 windows: 
    + a syntax-highlighting code editor
    + a console
    + upperright window: Workspace/History/File browser
    + lowerright window: files, plots, packages, help pages and viewer
- Menu and global settings


Setting and changing working directory
========================================================
- Default working directory is the file location
- You may need to setup your working directory by `setwd("YourFilePath")`, note that you need to __use forward slash ("/")__ instead of back slash, the file path should be inside the quotation mark
- Check if your working directory is correct by `getwd()`
- Create new directory by `dir.create()` or by Terminal in R
- Check if a directory exists by `dir.exists()` 
- List all files in a directory by `list.files()`


Loading packages
========================================================
- **Installation** vs. **Loading** packages
- if the package is existing: `library("package name")`

```r
library(dplyr)
```

- if new: install new packages depending on the resources
- if outdated: 

    + update a CRAN R package by `update.packages(package name)` or click "update" button in Rstudio
    + update a Bioconductor package by reinstalling it with `BiocManager::install()`



Getting data into R
========================================================
There are many ways to import data into R depending on the data format, Sometimes you need to download a specific package for reading data. Here are some commonly used functions. 

        Functions        |        File type        |  required Package
    ---------------------|-------------------------|--------------------
      `read.csv()`       |  comma separated files  |     basic
      `read.table()`     |  csv, txt, semicolon    |     basic
      `read.delim()`     |  other delimited Files  |     basic
      `readHTMLTable()`  |  HTML file (URL)        |   RCurl, XML
      `read.xls()`       |  Excel xls sheets       |     gdata 
      `read.xlsx()`      |  Excel xlsx sheets      |     openxlsx 
        
- However, things may not go as smooth as you think ... sometimes it can be very frastrating for not being able to read some xlsx sheets into R, especially when you have dirty data. 


Load build-in data sets
========================================================
Build-in data sets and external data packages are very good sources to practice R coding. You can either call them directly, or use `data()` function to get them into the console.

Some famous datasets: e.g. **iris**, **mtcars**
- The **Iris** flower data set is a multivariate data set introduced by the British statistician and biologist Ronald Fisher in 1936. 
- The **mtcars** data set (Motor trend car road test) was extracted from the 1974 Motor Trend US magazine, and comprises fuel consumption and 10 aspects of automobile design and performance for 32 automobiles (1973 to 1974 models).


The Iris flower data
========================================================
- The **Iris** dataset 

    + 3 species ( _Iris setosa_ , _Iris virginica_ and _Iris versicolor_); 
    + 50 samples per species
    + 4 features in each sample: the length and the width of the sepals and petals, in centimeters. 
- Based on the combination of these four features, Fisher developed a linear discriminant model to distinguish the species from each other. 


A quick look on your data
========================================================
- display structure of an R object

```r
str(iris)
```

```
'data.frame':	150 obs. of  5 variables:
 $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
 $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
 $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
 $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
 $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
```

```r
dim(iris)
```

```
[1] 150   5
```

========================================================
- check head and tail of a data

```r
head(iris)
```

```
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1          5.1         3.5          1.4         0.2  setosa
2          4.9         3.0          1.4         0.2  setosa
3          4.7         3.2          1.3         0.2  setosa
4          4.6         3.1          1.5         0.2  setosa
5          5.0         3.6          1.4         0.2  setosa
6          5.4         3.9          1.7         0.4  setosa
```

```r
head(iris, 3)
```

```
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1          5.1         3.5          1.4         0.2  setosa
2          4.9         3.0          1.4         0.2  setosa
3          4.7         3.2          1.3         0.2  setosa
```

========================================================

```r
tail(iris, 3)
```

```
    Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
148          6.5         3.0          5.2         2.0 virginica
149          6.2         3.4          5.4         2.3 virginica
150          5.9         3.0          5.1         1.8 virginica
```


Getting help in R
========================================================
- You can always ask Google for sure
    * ask specific questions
    * ask questions step by step
    
- Learn to check R help page, also it can be lengthy and not easy to understand! Basic syntax is to use `?FunctionName` or `help(FunctionName)`


```r
?str
help(str)
?head
?tail
```



Exporting data 
========================================================
- Export to current working directory

```r
# double check working directory
getwd()
```

```
[1] "D:/Teaching/deNBI2019_RNAseq_WGBS"
```

```r
write.table(iris, "iris1.txt", sep = "\t")
write.csv(iris, "iris2.csv", sep = ",")
```
- Export to other directory

```r
dir.create("./results/")
write.table(iris, "./results/iris1.txt", sep = "\t")
write.csv(iris, "./results/iris2.csv", sep = ";")
write.csv(iris, "./results/iris3.csv", sep = " ")
```
