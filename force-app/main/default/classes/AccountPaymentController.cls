public with sharing class AccountPaymentController {
  
        @AuraEnabled(cacheable = true)
        public static List<Account> getAccounts(){
           return AccountService.getAccounts();
        }

        @AuraEnabled(cacheable = true)
        public static List<Payment__c> getPaymentsAccount(Id accountId){
            return PaymentService.fetchPaymentsByAccount(accountId);
        }

        @AuraEnabled
        public static Payment__c createPayment(Payment__c newPayment){
            try {
                return PaymentService.createPayment(newPayment);
            } catch (Exception e) {
               throw new AuraHandledException('Payment kaydedilemedi: ' + e.getMessage());
            }
        }
    }
