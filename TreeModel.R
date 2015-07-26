library(doParallel)
registerDoParallel(cores=1)

## Prediction

library(caret)
## Separating training from test
wholedata <- read.csv("pml-training.csv",header=T)
set.seed(12345)
inTrain <- createDataPartition(y=wholedata$classe,
                               p=0.7, list=FALSE)
training <- wholedata[inTrain,]; testing <- wholedata[-inTrain,]
dim(training); dim(testing)


## Removing unneccesary features
remove <- nearZeroVar(training)
remove <- c(remove,1,2,3,4,5,7)

training <- training[,-remove]

## fill in missing values
imp <- preProcess(training[,-100],method="knnImpute")
trainimp <- predict(imp,training[,-100])

trainimp <- cbind(trainimp,classe=training$classe)


## Trees model fitting
modFit  <- train(classe ~.,data=trainimp,method="rpart")


## In sample testing for trees
intest <- predict(modFit,newdata=trainimp)
confusionMatrix(intest,trainimp$classe)

