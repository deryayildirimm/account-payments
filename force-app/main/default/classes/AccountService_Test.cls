@isTest
public with sharing class AccountService_Test {
    public AccountService_Test() {

    }
    @isTest
    static void testFetchAccounts(){
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };

        insert accounts;
        Test.startTest();
        List<Account> fetchedAccounts = AccountService.getAccounts();
        Test.stopTest();

        System.Assert.areEqual(2, fetchedAccounts.size());
        System.assert(
            fetchedAccounts[0].Name == 'Test Account 1',
            'Account name should be Test Account 1');
         System.assert(
            fetchedAccounts[1].Name == 'Test Account 2',
            'Account name should be Test Account 2');
        
    
    }

    @isTest
    static void testFetchAllAccounts_NoData() {
        // act
        Test.startTest();
        List<Account> fetchedAccounts = AccountService.getAccounts();
        Test.stopTest();

        // assert
        System.assertEquals(0, fetchedAccounts.size(), 'Account yoksa boş liste dönmeli');
    }

}