import { LightningElement, wire, api } from 'lwc';
import getPaymentsAccount from '@salesforce/apex/AccountPaymentController.getPaymentsAccount';
import { refreshApex } from '@salesforce/apex';

export default class PaymentList extends LightningElement {
    @api accountId;
    payments;
    wiredResult;

    columns = [
        { label: 'Payment Type', fieldName: 'Payment_Type__c' },
        { label: 'Amount', fieldName: 'Amount__c', type: 'currency' },
        { label: 'Due Date', fieldName: 'Due_Date__c', type: 'date' },
        { label: 'Notes', fieldName: 'Notes__c' },
        { label: 'Account', fieldName: 'AccountName' }
    ];

     @wire(getPaymentsAccount, { accountId: '$accountId' })
    wiredPayments(result) {
        this.wiredResult = result; // refreshApex için referans sakla
        const { data, error } = result;
        if (data) {
            this.payments = data.map(p => ({
                ...p,
                AccountName: p.Account__r ? p.Account__r.Name : ''
            }));
        } else if (error) {
            console.error(error);
        }
    }

    @api
    refreshPayments() {
        if (this.wiredResult) {
            return refreshApex(this.wiredResult);
        }
    }
}
