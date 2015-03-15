Reproducible Research: Peer Assessment 1
Loading and preprocessing the data

Show any code that is needed to

Load the data (i.e. read.csv())
Process/transform the data (if necessary) into a format suitable for your analysis
originalData <- read.csv("activity.csv")
A portion of the original dataset is as follows:

print(originalData[1:20,])
What is mean total number of steps taken per day?

For this part of the assignment, you can ignore the missing values in the dataset.

Make a histogram of the total number of steps taken each day
Calculate and report the mean and median total number of steps taken per day
The goal of this section is to generate the overall mean (average) of the total number of steps taken per day. There are a few steps taken to reach this goal.

A dataset containing the total number of steps taken each day is created.

dailyStepSum <- aggregate(originalData$steps, list(originalData$date), sum)
A portion of the new dataset is as follows:

colnames(dailyStepSum) <- c("Date", "Steps")
print(dailyStepSum[1:20,])
A histogram of the above data is created as a form of visual representation.

with(dailyStepSum, {
    par(oma=c(2,0,0,0), mar=c(6.75,6.75,3,0), mgp=c(5.75,0.75,0), las=2)
    barplot(
      height=Steps,
      main="Graph of Total Steps taken per Day",
      xlab="Dates",
      ylab="Steps per Day",
      names.arg=Date,
      space=c(0)
    )
})
Calculate the mean and median values (ignoring NA values) using the above dataset.

Mean {r echo=TRUE} dailyStepMean <- mean(dailyStepSum$Steps, na.rm=TRUE)  {r echo=FALSE} print(dailyStepMean) 
Median {r echo=TRUE} dailyStepMedian <- median(dailyStepSum$Steps, na.rm=TRUE)  {r echo=FALSE} print(dailyStepMedian) 
What is the average daily activity pattern?

What is the average daily activity pattern?

Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
This goal of this section is to find the mean (average) steps taken for eatch 5-minute time interval averaged over all the days in the data. Similar to the previous section, the steps taken to reach the above goal are as follows:

Generate the mean (average) number of steps taken (ignoring NA values) for each 5-minute interval, itself averaged across all days.

intervalSteps <- aggregate(
    data=originalData,
    steps~interval,
    FUN=mean,
    na.action=na.omit
)
colnames(intervalSteps) <- c("Interval", "AvgStepsAvgAcrossDay")
A portion of the new dataset is as follows:

print(intervalSteps[1:20,])
A Time-Series plot is created from the above dataset

with(intervalSteps, {
    plot(
      x=Interval,
      y=AvgStepsAvgAcrossDay,
      type="l",
      main="Time-Series of Average Steps against Interval",
      xlab="5-minute Interval",
      ylab="Average Steps, Average across all Days"

    )
})
Finding the 5-minute interval with the maximum number of steps

intervalMax <- intervalSteps[intervalSteps$AvgStepsAvgAcrossDay==max(intervalSteps$AvgStepsAvgAcrossDay),]
print(intervalMax)
Therefore, the interval between r as.character(intervalMax[1]) and r as.character(as.numeric(intervalMax[1])+5) minutes has the maximum number of steps.

Imputing missing values

Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
Create a new dataset that is equal to the original dataset but with the missing data filled in.
Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?
The goal of this section is to generate a new graph using the same data as from the first section but with its NA values replaced.

To achieve this goal the mean (average) 5-minunte interval values as from the previous section will be used to replace the NA values.

Total number of rows with NA values in original data.

countNA <- nrow(subset(originalData, is.na(originalData$steps)))
print(countNA)
The average 5-minute interval values from the prevous section is used to replace the NA values of the original data and a new dataset will be generated from the latter.

Decimal values will be rounded up to a whole number.

stepValues <- data.frame(originalData$steps)
stepValues[is.na(stepValues),] <- ceiling(tapply(X=originalData$steps,INDEX=originalData$interval,FUN=mean,na.rm=TRUE))
newData <- cbind(stepValues, originalData[,2:3])
colnames(newData) <- c("Steps", "Date", "Interval")
A portion of the new dataset is as follows:

print(newData[1:20,])
The total number of steps taken each day is generated using this new dataset.

newDailyStepSum <- aggregate(newData$Steps, list(newData$Date), sum)
A portion of the new dataset is as follows:

colnames(newDailyStepSum) <- c("Date", "Steps")
print(newDailyStepSum[1:20,])
A histogram of the above data is created as a form of visual representation.

with(newDailyStepSum, {
    par(oma=c(2,0,0,0), mar=c(6.75,6.75,3,0), mgp=c(5.75,0.75,0), las=2)
    barplot(
      height=Steps,
      main="Graph of Total Steps taken per Day",
      xlab="Dates",
      ylab="Steps per Day",
      names.arg=Date,
      space=c(0)
    )
})
Calculate the mean and median values of this new dataset (NA values replaced with mean).

Mean {r echo=TRUE} newDailyStepMean <- mean(newDailyStepSum$Steps)  {r echo=FALSE} print(newDailyStepMean) 
Median {r echo=TRUE} newDailyStepMedian <- median(newDailyStepSum$Steps)  {r echo=FALSE} print(newDailyStepMedian) 
It seems that adding the missing values to the original data has caused both the mean and median values to increase.

Mean:

r as.character(floor(as.numeric(dailyStepMean))) to r as.character(floor(as.numeric(newDailyStepMean)))

Median:

r as.character(floor(as.numeric(dailyStepMedian))) to r as.character(floor(as.numeric(newDailyStepMedian)))

Are there differences in activity patterns between weekdays and weekends?

For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). The plot should look something like the following, which was creating using simulated data:
A new column indicating whether the date is a weekday or a weekend is added to the new dataset created in the previous section.

dateDayType <- data.frame(sapply(X=newData$Date, FUN=function(day) {
  if (weekdays(as.Date(day)) %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")) {
    day <- "weekday"
  }
  else {
    day <- "weekend"
  } 
}))

newDataWithDayType <- cbind(newData, dateDayType)

colnames(newDataWithDayType) <- c("Steps", "Date", "Interval", "DayType")
A portion of this dataset is as follows:

print(newDataWithDayType[1:20,])
The data is then separated into weekday or weekend and the mean (average) number of steps taken for each 5-minute interval, itself averaged across all weekday days or weekend days is calculated.

dayTypeIntervalSteps <- aggregate(
    data=newDataWithDayType,
    Steps ~ DayType + Interval,
    FUN=mean
)
A portion of the dataset is as follows:

print(dayTypeIntervalSteps[1:20,])
Finally, a panel plot of both weekend and weekday graphs is generated.

library("lattice")

xyplot(
    type="l",
    data=dayTypeIntervalSteps,
    Steps ~ Interval | DayType,
    xlab="Interval",
    ylab="Number of steps",
    layout=c(1,2)
)
