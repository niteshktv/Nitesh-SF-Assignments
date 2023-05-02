import { LightningElement, api, wire } from 'lwc';
import getContactAssociatedWithDesignation from '@salesforce/apex/GetDesignationRecords.getContactAssociatedWithDesignation';
import CONTRIBUTION_NAME  from '@salesforce/schema/Contribution__c.Name';
import CONTRIBUTION_CATEGORIES from '@salesforce/schema/Contribution__c.Pillars__c';
import CONTRIBUTION_ASSESSMENT from '@salesforce/schema/Contribution__c.Assessment__c';
import CONTRIBUTION_EXPERTISE from '@salesforce/schema/Contribution__c.Expertise__c';
import CONTRIBUTION_ADVOCACY from '@salesforce/schema/Contribution__c.Advocacy__c';
import CONTRIBUTION_LEADERSHIP from '@salesforce/schema/Contribution__c.Leadership__c';
import CONTRIBUTION_GENEROSITY from '@salesforce/schema/Contribution__c.Generosity__c';
import CONTRIBUTION_DETAILS_FIELD from '@salesforce/schema/Contribution__c.Details__c';
import CONTRIBUTION_NOTE_FIELD from '@salesforce/schema/Contribution__c.Note__c';

const horizontalFieldSet = [
    {label : 'Contribution', fieldName:CONTRIBUTION_NAME.fieldApiName, type:'text'},
    {label: 'Categories', fieldName:CONTRIBUTION_CATEGORIES.fieldApiName, type:'picklist'},
    {label:'Assessment', fieldName:CONTRIBUTION_ASSESSMENT, type:'picklist'}
]

const verticalFieldSet = [
    {label: 'Expertise', fieldName:CONTRIBUTION_EXPERTISE.fieldApiName, type:'Formula'},
    {label:'Advocacy', fieldName:CONTRIBUTION_ADVOCACY.fieldApiName, type:'Formula'},
    {label:'Generosity', fieldName:CONTRIBUTION_GENEROSITY.fieldApiName, type:'Formula'},
    {label:'Leadership', fieldName:CONTRIBUTION_LEADERSHIP.fieldApiName,type:'Formula'}
]

const detailFieldSet = [
    {label:'Details', fieldName: CONTRIBUTION_DETAILS_FIELD.fieldApiName, type:'Long Text Area'},
    {label: 'Notes', fieldName: CONTRIBUTION_NOTE_FIELD.fieldApiName, type:'Text Area'}
]

export default class MVPNomineeContributions extends LightningElement {
    results;
    columns = horizontalFieldSet;
    fields = verticalFieldSet;
    detailFieldColumns = detailFieldSet;
    @api recordId;

    @wire(getContactAssociatedWithDesignation, {designationId : '$recordId'})
    wiredContribution({data, error}){
        if(data){
            console.log('Data >>>> ' + JSON.stringify(data));
            this.results = data;

        }else if(error){
            console.log(error);
        }
    }
}