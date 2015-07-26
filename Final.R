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


## Submission
pml_write_files = function(x){
    n = length(x)
    for(i in 1:n){
        filename = paste0("problem_id_",i,".txt")
        write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
}
pml_write_files(pred)
