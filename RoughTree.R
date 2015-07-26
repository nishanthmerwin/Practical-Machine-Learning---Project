library(doParallel)
registerDoParallel(cores=4)

## Prediction

library(caret)
## Separating training from test
wholedata <- read.csv("pml-training.csv",header=T)
set.seed(12345)
inTrain <- createDataPartition(y=wholedata$classe,
                               p=0.7, list=FALSE)
training <- wholedata[inTrain,]; testing <- wholedata[-inTrain,]


## Removing unneccesary features
remove <- nearZeroVar(training)
remove <- c(remove,1,2,3,4,5,7)

training <- training[,-remove]

training[] <- lapply(training, as.numeric)

## fill in missing values
imp <- preProcess(training[,-100],method="knnImpute")
trainimp <- predict(imp,training[,-100])

trainimp <- cbind(trainimp,classe=training$classe)

## Testing to see if it works with a smaller size
set.seed(12345)
inTrain <- createDataPartition(y=trainimp$classe,
                               p=0.05, list=FALSE)
rftest <- trainimp[inTrain,]



## Random Forest model fitting

library("randomForest")
library("caret")
names(getModelInfo())


modFit  <- train(classe ~.,data=trainimp,method="rf",prox=T)


## In sample testing for trees
intest <- predict(modFit,newdata=trainimp)
confusionMatrix(intest,trainimp$classe)