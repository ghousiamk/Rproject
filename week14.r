# Installing required libraries

library(dplyr)
library(magrittr)
library(ggplot2)
library(caret)
library(caTools)
library(randomForest)

# Loading The dataset as Fraudanalysisdataset
transactions <- Fraudanalysisdataset
transactions <-as.data.frame(transactions)
head(transactions)

#Finfding the Transaction Types which are more likely to be Fraud
Fraud_trans_type <- transactions %>% group_by(type) %>% summarise(fraud_transactions = sum(isFraud))
ggplot(data = Fraud_trans_type, aes(x = type,  y = fraud_transactions)) + geom_col(aes(fill = 'type'), show.legend = FALSE) + labs(title = 'Fraud transactions as Per type', x = 'Transcation type', y = 'No of Fraud Transactions') + geom_text(aes(label = fraud_transactions), size = 4, hjust = 0.5) + theme_classic()


#Looking closely at the data reveled that there are certain transactions where the transaction Amount is greater than the Balance available in the Origin account.
head(transactions[(transactions$amount > transactions$oldbalanceOrg)& (transactions$newbalanceDest > transactions$oldbalanceDest), c("amount","oldbalanceOrg", "newbalanceOrig", "oldbalanceDest", "newbalanceDest", "isFraud")], 10)

#Creating new features adjustedBalanceOrg and adjustedBalanceDest
transactions$adjustedBalanceOrg<-round(transactions$newbalanceOrig+transactions$amount-transactions$oldbalanceOrg, 2)
transactions$adjustedBalanceDest<-round(transactions$oldbalanceDest+transactions$amount-transactions$newbalanceDest, 2)
colnames(transactions)

# Filtering only CASH_OUT and TRANSFER transactions and droping irrelevant features
transactions1<- transactions %>% 
  select( -one_of('step','nameOrig', 'nameDest', 'isFlaggedFraud')) %>%
  filter(type %in% c('CASH_OUT','TRANSFER'))

#Encoding Dummy variables for transaction type
install.packages("fastDummies")
library(fastDummies)

transactions1 <- dummy_cols(transactions1)
transactions1$isFraud <- as.factor(transactions1$isFraud)
transactions1 <- transactions1[,-1]
colnames(transactions1)


install.packages("caTools")
library(caTools)

#Splitting the train and test set.
set.seed(1)
spl <- sample.split(transactions1$isFraud, 0.8)
transactions_train <- transactions1[spl == TRUE,]
transactions_test <- transactions1[spl == FALSE,]

set.seed(1)
#Randon Forest model
fit_forest <- randomForest(isFraud ~ ., data = transactions_train, ntree = 20, mtry = 3)
plot(fit_forest)

#Predicting value using test data set
pred <- predict(fit_forest, newdata = transactions_test[,-5])

# Creating confusion Matrix to get accuracy
confusion<-confusionMatrix(pred, transactions_test$isFraud )
print(confusion)
--
  