public with sharing class PaymentService {

    public static List<Payment__c> fetchPaymentsByAccount(Id accountId){
        return[
            SELECT Id, Name, Payment_Type__c, Amount__c, Due_Date__c,
            Notes__c, Account__c, Account__r.Name
            FROM Payment__c
            WHERE Account__c = :accountId
            ORDER BY Due_Date__c DESC
        ];
    }

    public static Payment__c createPayment(Payment__c newPayment){
          try {
            insert newPayment;
            return newPayment;
            } catch (Exception e) {
            throw new AuraHandledException('Error while creating payment: ' + e.getMessage());
            }
    }

}