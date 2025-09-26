import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountPaymentController.getAccounts';

export default class AccountList extends LightningElement {
    selectedAccountId;
    wiredAccounts;

    @wire(getAccounts)
    loadAccounts(result) {
        this.wiredAccounts = result;
        console.log('Accounts data (wire): ', JSON.stringify(result));
    }

    get accounts() {
        if (this.wiredAccounts && this.wiredAccounts.data) {
            return this.wiredAccounts.data.map(acc => {
                return {
                    ...acc,
                    cssClass: 'slds-item ' + (this.selectedAccountId === acc.Id ? 'selected' : '')
                };
            });
        }
        return []; //  boş array döndür
    }

    handleSelect(event) {
        const accountId = event.currentTarget.dataset.id;
        this.selectedAccountId = accountId;

        this.dispatchEvent(new CustomEvent('accountselected', {
            detail: accountId
        }));
    }
}

