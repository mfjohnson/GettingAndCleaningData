# Getting and Cleaning Course Project Description
Author: Mark Johnson

## Overview
This is a guide for **the Getting and Cleaning Course project** which prepares a tiddy data set for both the test and train wearables datasets.  The target audience for  this project includes the course peer reviewers to aide their evaluation of this submission.

## Project Output results
The output from this assignment are two files:
* Tiddy_data.txt: the unsummarized tiddy data file containing only the mean and std measures plus the factor variables
* Tiddy_mean.txt: The summarized mean of all the numeric variables

## Source Data files
Some notes about the source data files used in this project are found below:
* The source of the data tiddying program is found in the program **'run_analysis.R'** found at the root of this project.  
* In the first row of the R program there is a 'setwd' command set to "~/R_Coursera_Course/gettingAndCleaning/UCI HAR Dataset". You will need to set this directory to the proper location where your instance of the UCI HAR dataset resides.
* variable names Raw data ingested follow their UCI HAR dataset datasets mirror 
* derived data such as the 'Activity Label' and unlabeled source columns follow traditional camelCase in order to properly distinguish the two sources.
* As the code proceeds and variables are no longer required they are removed in order to save system resources.
* Upon loading the factor variables are properly setup so they don't create problems when doing the rowise mean calculation.

## R Packages used
This program is dependent on the following libraries:
* plyr

## Running the program
To execute the program first confirm that the working directory specified at the start of the program is set to the appropriate directory and then run the R Script file: *run_analysis.R* 


