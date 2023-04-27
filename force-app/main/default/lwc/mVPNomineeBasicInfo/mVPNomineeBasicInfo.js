import { LightningElement, api } from 'lwc';
import getFormFields from '@salesforce/apex/GetContact.getFormFields';
export default class MVPNomineeBasicInfo extends LightningElement {

    // Flexipage provides recordId and objectApiName
    @api recordId;
    @api objectApiName;

    @api fieldSet;
    @api title;
    @api columnView;
    @api showHeader;
    objectName;
    fields;

    connectedCallback(){
        getFormFields({recordId:this.recordId, fieldSetName : this.fieldSet}).then(result =>{
            console.log(JSON.stringify(result));
            if(result){
                this.objectName = Object.keys(result)[0];
                this.fields = result[Object.keys(result)[0]];
            }
        }).catch(error=>{
            console.log(error);
        })
    } 
}