import { LightningElement } from 'lwc';

export default class AccountPayments extends LightningElement {

    selectedAccountId;

    handleAccountSelected(event) {
        this.selectedAccountId = event.detail;
    }


    handlePaymentCreated() {
        const paymentListCmp = this.template.querySelector('c-payment-list');
        if (paymentListCmp) {
            paymentListCmp.refreshPayments();
        } else {
            console.warn('Payment list component bulunamadı ya da refreshPayments metodu yok');
        }
    }

}