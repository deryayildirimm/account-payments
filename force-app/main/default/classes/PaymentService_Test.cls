@isTest
public with sharing class PaymentService_Test {

    @isTest
    static void testAddAndFetcPayments(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Payment__c newPayment = new Payment__c(
            Payment_Type__c = 'Service',
            Amount__c = 100,
            Due_Date__c = Date.today(),
            Notes__c = 'Test Notes',
            Account__c = acc.Id );


        Test.startTest();
        Payment__c createdPayment = PaymentService.createPayment(newPayment);
        List<Payment__c> fetchedPayments = PaymentService.fetchPaymentsByAccount(acc.Id);
        Test.stopTest();

    
        System.Assert.areEqual(1, fetchedPayments.size());
        System.Assert.areEqual('Service', fetchedPayments[0].Payment_Type__c);
        System.Assert.areEqual(100, fetchedPayments[0].Amount__c);
        System.Assert.areEqual(Date.today(), fetchedPayments[0].Due_Date__c);
        System.Assert.areEqual('Test Notes', fetchedPayments[0].Notes__c);
        System.Assert.areEqual(acc.Id, fetchedPayments[0].Account__c);

    }

   @isTest
    static void testCreatePayment_InvalidDueDate(){
        Account acc = new Account(Name = 'Invalid Date Account');
        insert acc;

        Payment__c badPayment = new Payment__c(
            Payment_Type__c = 'Service',
            Amount__c = 50,
            Due_Date__c = Date.today().addDays(-5), // geçmiş tarih
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
    static void testCreatePayment_InvalidPicklist(){
        Account acc = new Account(Name = 'Invalid Picklist Account');
        insert acc;

        Payment__c badPayment = new Payment__c(
            Payment_Type__c = 'InvalidValue', // geçersiz picklist
            Amount__c = 75,
            Due_Date__c = Date.today().addDays(10),
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
    static void testCreatePayment_ExceptionHandled() {
        Account acc = new Account(Name = 'Exception Account');
        insert acc;

        Payment__c badPayment = new Payment__c(
            Payment_Type__c = 'Service',
            Account__c = acc.Id
            // Amount ve DueDate yok → insert fail
        );

        Test.startTest();
        Boolean caught = false;
        try {
            PaymentService.createPayment(badPayment);
        } catch (AuraHandledException e) {
            caught = true;
            System.assert(e.getMessage().contains('Error while creating payment'),
                'Hata mesajı bekleniyor');
        }
        Test.stopTest();

        System.assertEquals(true, caught, 'Exception yakalanmalıydı');
    }


}