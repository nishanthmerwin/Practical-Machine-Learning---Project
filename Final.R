## Start'er Up
library(caret)
set.seed(1234)

## Importing the data
rawData <- read.csv("pml-training.csv", na.strings=c("NA",""), strip.white=T)
dim(rawData)

## Subset for features in paper
features <- c("roll_belt","pitch_forearm","yaw_belt","magnet_dumbbell_y","pitch_belt","magnet_dumbbell_z","roll_forearm",
              "accel_dumbbell_y","roll_dumbbell","magnet_dumbbell_x","accel_forearm_x","magnet_belt_z","total_accel_dumbbell",
              "magnet_forearm_z","accel_dumbbell_z","magnet_belt_y","accel_belt_z","yaw_arm","gyros_belt_z","magnet_belt_x","classe")   

validData <- rawData[,features]

## Separate out training and test set
inTrain <- createDataPartition(validData$classe, p=0.7, list=F)
training <- validData[inTrain,]
testing <- validData[-inTrain,]

## Making a random forest model
ctrl <- trainControl(allowParallel=T, method="cv", number=4)
model <- train(classe ~ ., data=training, model="rf", trControl=ctrl)


save(model,file="RFModel.rda")

## Testing the accuracy on the testing set
pred <- predict(model, newdata=testing)
cm <-  confusionMatrix(pred,testing$classe)

conf <- confusion(pred,testing$classe)

confusionImage(conf,sort=F,numbers=T,ncols=11,names=c("Actual","Predicted"),cex.axis=NULL,
               grid.col=NULL)
str(cm)




confusionImage(x, y = NULL, labels = names(dimnames(x)), sort =F,
               numbers = TRUE, digits = 0, mar = c(3.1, 10.1, 3.1, 3.1), cex = 1, asp = 1,
               colfun, ncols = 41, col0 = FALSE, grid.col = "gray", ...)



