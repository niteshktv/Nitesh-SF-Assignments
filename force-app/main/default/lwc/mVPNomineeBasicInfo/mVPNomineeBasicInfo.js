import { LightningElement, api, wire } from 'lwc';
import getContactFields from '@salesforce/apex/GetContact.getContactFields';
import getContactAssociateContact from '@salesforce/apex/GetContact.getContactAssociateContact';
export default class MVPNomineeBasicInfo extends LightningElement {

    // Flexipage provides recordId and objectApiName
    @api recordId;
    @api fieldSet;
    @api title;
    @api columnView;
    @api showHeader;
    objectName;
    fields;
    contactId;

    @wire(getContactAssociateContact, {designationId: '$recordId'})
    wiredContact({data, error}){
        if(data){
            this.contactId = data;
        }
    }

    @wire(getContactFields, {varContactId:'$contactId',fieldSetName : '$fieldSet' })
    wiredFieldSet({data, error}){
        if(data){
            this.objectName = Object.keys(data)[0];
            this.fields = data[Object.keys(data)];
        }else if(error){
            console.log(error);
        }
    } 
}