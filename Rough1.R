
training <- read.csv("pml-training.csv",header=T)


#install.packages("doParallel")
library(doParallel)
registerDoParallel(cores=2)



levels(training[,160])


summary(training)

dim(training)


names(training)


head(training,n=2)


tail(training,n=6)


summary(training[,5])


"avg_roll_belt",
"var_roll_belt",
"max_yaw_belt",
"min_yaw_belt",
"amplitude_yaw_belt"


names <- read.csv("WLE.csv",nrow=5)

names(names)