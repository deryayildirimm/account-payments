import { LightningElement, api } from 'lwc';

export default class PaymentForm extends LightningElement {
    @api accountId;
    errorMessage; 

    handleSubmit(event) {
        event.preventDefault(); // default submit’i engelle
        const fields = event.detail.fields;

       
        fields.Account__c = this.accountId;

        // Formu submit et
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event) {
        this.errorMessage = null;

         // Alanları sıfırla
        this.template.querySelectorAll('lightning-input-field')
            .forEach(field => { field.value = null; });


        //  parent'e event fırlat → payment list refresh için
      this.dispatchEvent(new CustomEvent('paymentcreated', {
        bubbles: true,
        composed: true
        }));
    }

    handleError(event) {
        this.errorMessage = 'Ödeme kaydedilemedi. Lütfen alanları kontrol edin.';
       console.error('Payment create error detail: ', JSON.stringify(event.detail, null, 2));
    }
}

