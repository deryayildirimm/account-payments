@isTest
public with sharing class AccountPaymentController_Test {
    public AccountPaymentController_Test() {

    }

   @isTest
    static void testControllerFlow(){
        // arrange
        Account acc = new Account(Name = 'Controller Test Account');
        insert acc;

        Payment__c newPayment = new Payment__c(
            Payment_Type__c = 'Service',
            Amount__c = 100,
            Due_Date__c = Date.today().addDays(5),
            Notes__c = 'Test Notes',
            Account__c = acc.Id
        );

        Test.startTest();
        List<Account> fetchedAccounts = AccountPaymentController.getAccounts();
        Payment__c createdPayment = AccountPaymentController.createPayment(newPayment);
        List<Payment__c> fetchedPayments = AccountPaymentController.getPaymentsAccount(acc.Id);
        Test.stopTest();

        // assert
        System.assertEquals(1, fetchedAccounts.size(), '1 account olmalı');
        System.assertEquals('Controller Test Account', fetchedAccounts[0].Name, 'Account adı eşleşmeli');

        System.assertEquals(1, fetchedPayments.size(), '1 payment olmalı');
        System.assertEquals('Service', fetchedPayments[0].Payment_Type__c, 'Payment tipi doğru olmalı');
    }

    @isTest
    static void testControllerFlow_InvalidDueDate(){
        Account acc = new Account(Name = 'Controller Invalid Date');
        insert acc;

        Payment__c badPayment = new Payment__c(
            Payment_Type__c = 'Service',
            Amount__c = 300,
            Due_Date__c = Date.today().addDays(-2),
            Account__c = acc.Id
        );

        Test.startTest();
        Database.SaveResult sr = Database.insert(badPayment, false);
        Test.stopTest();

        System.assertEquals(false, sr.isSuccess(), 'Insert başarısız olmalı');
        System.assert(sr.getErrors()[0].getMessage().contains('Due Date'),
            'Due Date validation hatası bekleniyor');
    }

    @isTest
    static void testControllerFlow_InvalidPicklist(){
        Account acc = new Account(Name = 'Controller Invalid Picklist');
        insert acc;

        Payment__c badPayment = new Payment__c(
            Payment_Type__c = 'InvalidValue', // olmayan değer
            Amount__c = 400,
            Due_Date__c = Date.today().addDays(3),
            Account__c = acc.Id
        );

        Test.startTest();
        Database.SaveResult sr = Database.insert(badPayment, false);
        Test.stopTest();

        System.assertEquals(false, sr.isSuccess(), 'Insert başarısız olmalı');
        System.assert(sr.getErrors()[0].getMessage().contains('bad value for restricted picklist'),
            'Picklist hatası bekleniyor');
    }

    @isTest
    static void testControllerFlow_ExceptionThrown() {
        Account acc = new Account(Name = 'Controller Exception Account');
        insert acc;

        // zorunlu alan eksik bırakalım → hata tetikler
        Payment__c badPayment = new Payment__c(
            Account__c = acc.Id
            // Payment_Type__c boş → insert fail
        );

        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            AccountPaymentController.createPayment(badPayment);
        } catch (AuraHandledException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Payment kaydedilemedi'),
                'Beklenen AuraHandledException mesajı gelmeli');
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown, 'Exception tetiklenmeli');
    }

}