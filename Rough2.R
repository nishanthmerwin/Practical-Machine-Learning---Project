install.packages("doParallel")
library(doParallel)
registerDoParallel(cores=2)


##Loading in data
setwd("~/Coursera/MachineLearning")

training <- read.csv("pml-training.csv",header=T)




## A full linear model
library(caret)
remove <- nearZeroVar(training)
remove <- c(remove,1,2,3,4,5,7)
clean <- training[,-remove]
fit<- lm(classe~.,data=clean)
df <- data.frame(x=predict(fit),y=as.numeric(resid(fit)))
            

g <- ggplot(data=df,aes(x=x,y=y))
g <- g + geom_point(pch=21,size=40,alpha=0.1,bg="gray69",col="gray69") + xlab("Linear Model Prediction") + ylab("Residual")
g <- g + stat_smooth(method="lm")
g

test <- predict(fit,clean[,-94])

confusionMatrix(clean$classe,test)


testPC <- predict(preProc,log10(testing[,-58]+1))
confusionMatrix(testing$type,predict(modelFit,testPC))


?predict


featurePlot(x=training[,c("avg_roll_belt",
                          "min_yaw_belt",
                          "amplitude_yaw_belt"
                          ,"classe")],y=training$classe,plot="pairs")