---
title: "Sampling, Point Estimation and Central Limit Theorem in R - A brief introduction"
output:
  html_document: default
  pdf_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## 1. Library
Load the necessary libraries into this R studio session.
<br>
<br>
<strong>Note:</strong> some packages may need to be installed. Use the install.package() function or search for the package at R Studio Menu Bar > Tools > Install Packages.
<br>

Many libraries used below are <strong>not necessary</strong> to complete this assignment.
<br>
``` {r library, message = FALSE}
library(tidyr)
library(readxl)
library(dplyr)
library(stringr)
library(writexl)
library(ggplot2)
library(httpuv)
library(googledrive)
library(googlesheets4)
library(knitr)
library(xtable)
library(glue)
```
<br>
<br>

## 2. Load Files
For this assignment, our file and directory are hosted by Google drive. As such, we need to authorize access to the drive and read the necessary file(s) into this R studio session.
<br>

The code below give us access to our Google drive. Check the console output for additional instructions.
```{r, message=FALSE}
googledrive::drive_auth()
sample_data2 = read_sheet(gs4_find('sample_data2'))
```
<br>
Next, we need to read and assign the Google spreadsheet to a variable.
```{r, message=FALSE}
sample_data2 = read_sheet(gs4_find('sample_data2'))
```
<br>
Let's take a look at the first five rows of the data frame to ensure the import was successful and correct.
```{r view_import}
view_sample = sample_data2[1:5,]
kable(view_sample, align = "llllcccc", caption = "Sample Data - 2020 Population by County and State")
```
<br>
<br>

## 3. Summary Statistics
We can run the summary function to get a full panel of descriptive statistics (see code below). 
<br>
For this specific assignment, the population mean is the only statistic necessary. Since a single population observation equates to one person, we're also going to round the population mean to the nearest number.
<br>
```{r summary_statistics}
dstats = summary(sample_data2)

pop_mean = round(mean(sample_data2$Population))
glue("Population Mean (Mu): {pop_mean}")
```
<br>
<br>

## 4. Point Estimate of Mean Using Various Sample Sizes:
This assignment assumes that we <strong>DO NOT</strong> have all the population data which is why we're using the point estimate method to derive the best estimation of our population mean.
<br>

<strong>Important Note:</strong> each time we run the code below, we're sampling from the total population. Every occurrence uses a different combination of observations to calculate our point estimate. As a result, we will always produce a <strong>different point estimate of the sample mean</strong>. 
<br>
<br>

#### Point Estimation (sample of 20 observations)
Using the sample function to select <strong>20</strong> random samples followed by the mean function to derive the average.
```{r point estimates 20}
sample_20 = mean(sample(sample_data2$Population, size = 20))
glue("Point Estimate (20 Observations): {sample_20}")
```
The variance between our population mean of 102930 and this point estimation is due to randomness. As we increase the number of observations used, our point estimations will moving closer and closer to the observed population mean. 
<br>

#### Point Estimation (sample of 200 observations)
Using the sample function to select <strong>200</strong> random samples (10x the previous sample) followed by the mean function to derive the average.
```{r point estimates 200}
sample_200 = mean(sample(sample_data2$Population, size = 200))
glue("Point Estimate (200 Observations): {sample_200}")

```
<br>

#### Point Estimation (sample of 2000 observations)
Using the sample function to select <strong>200</strong> random samples (10x the previous sample and slight 1000 less observations than the population data set) followed by the mean function to derive the average.
```{r point estimates 2000}
sample_2000 = mean(sample(sample_data2$Population, size = 2000))
glue("Point Estimate (2000 Observations): {sample_2000}")
```
<br>
<br>



## 5. Point Estimate of Mean Using Multiple Sample Sizes: 
In this section, we calculate the sample mean using a fixed sample  of 100 observations. Then we use the replicate function to repeat this process <strong>n</strong> number of times and examine how closely we can approximate the true population mean.

In the example below, we replicate the sampling of 100 observations <strong>40</strong> times provide us with different 400 means. Then we compute a mean of means:
```{r estimate replicate 100 40}
rsample_40 = mean(replicate(40,mean(sample(sample_data2$Population, size=100))))
print(rsample_40)
```
<br>

Increasing the number of replications to <strong>400</strong> would result in a mean of mean even closer to the population mean:
```{r estimate replicate 100 400}
rsample_400 = mean(replicate(400,mean(sample(sample_data2$Population, size=100))))
print(rsample_400)
```
<br>

Let's set the replicate function to <strong>4000</strong> and compare to the population mean:
```{r estimate replicate 100 4000}
rsample_4000 = mean(replicate(4000,mean(sample(sample_data2$Population, size=100))))
print(rsample_4000)
```
<br>

The tables below aggregates the results from using sampling and sompling with replication. Two key takeways:

1. Increasing the sample size will move us closer to the true population mean.

2. Increasing the sample size via replication is a faster and more efficient method of getting as close as possible to our population mean. 

```{r echo=FALSE}
rd_40 = (pop_mean-rsample_40)/rsample_40
rd_400 = (pop_mean-rsample_400)/rsample_400
rd_4000 = (pop_mean-rsample_4000)/rsample_4000
```

```{r results dataframe, echo=FALSE}
sample_results = data.frame(Sample_Size=rep(c(20,200,2000)),Sample_Mean = rep(c(sample_20,sample_200,sample_2000)),Diff_Pop_Mean = rep(c(pop_mean)), delta = rep(c((pop_mean-sample_20)/sample_20,(pop_mean-sample_200)/sample_200,(pop_mean-sample_2000)/sample_2000)))

kable(sample_results,  col.names = c("n","x","$\\mu$","$\\Delta$(%)"), escape = FALSE, align = "lccc", caption = '1. Point Estimation of Mean with Sampling', booktabs = TRUE)

rsample_results = data.frame(size=rep(c(100)), replicate = rep(c(40,400,4000)), num_of_means = rep(c(400,4000,40000)),samplemeans = rep(c(rsample_40,rsample_400, rsample_4000)),pmean = rep(c(pop_mean)), d_rs = rep(c(rd_40,rd_400,rd_4000)))

kable(rsample_results, col.names = c("n","Replicate Factor","# of Means", "$\\chi$","$\\mu$","$\\Delta$(%)"), escape = FALSE, align = "lccccc", caption = '2. Point Estimation of Mean (Fixed Sample with Replication)', booktabs = TRUE)
```
<br>
<br>



## 6. Lessons from Histograms
We can analyze the histograms of the previous "mean of means" to illustrate how an increase in the frequency of computed sample means impacts the distribution of means.
<br>
```{r histogram_rs40}
hist(replicate(40,mean(sample(sample_data2$Population, size=100),simplify=TRUE)), xlab = 'Sample Means', ylab = 'Frequency', main = 'Distribution of Sample Means = 40 Replications', col = 'blue', border = 'white')

```
<br>
```{r histogram_rs400}

hist(replicate(400,mean(sample(sample_data2$Population, size=100),simplify=TRUE)), xlab = 'Sample Means', ylab = 'Frequency', main = 'Distribution of Sample Means - 400 Replications', col = 'purple', border = 'white')
```
<br>
```{r histogram_rs4000}

hist(replicate(4000,mean(sample(sample_data2$Population, size=100),simplify=TRUE)), xlab = 'Sample Means', ylab = 'Frequency', main = 'Distribution of Sample Means - 4000 Replications', col = 'grey', border = 'white', breaks = 30)
```
<br>

### Observations from Histograms
1. As we increase the number of observations sampled, more and more sample means fall within the same bin of our population mean (or nearby bins depending on bin sizes).

2. Consistent with the Central Limit Theorem, when we repeatedly draw samples of a specific size (100), calculate the means and display those means on a histogram, the histogram will tend to have an normal bell shape distribution. 

3. Outliers increase the variability in the sample. 




