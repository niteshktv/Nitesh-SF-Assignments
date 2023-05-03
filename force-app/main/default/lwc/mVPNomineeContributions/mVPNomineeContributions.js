import { LightningElement, api, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import getContactAssociatedWithDesignation from '@salesforce/apex/GetDesignationRecords.getContactAssociatedWithDesignation';
import OBJECT_API_NAME from '@salesforce/schema/Contribution__c';
import CONTRIBUTION_NAME  from '@salesforce/schema/Contribution__c.Name';
import CONTRIBUTION_CATEGORIES from '@salesforce/schema/Contribution__c.Pillars__c';
import CONTRIBUTION_ASSESSMENT from '@salesforce/schema/Contribution__c.Assessment__c';
import CONTRIBUTION_EXPERTISE from '@salesforce/schema/Contribution__c.Expertise__c';
import CONTRIBUTION_ADVOCACY from '@salesforce/schema/Contribution__c.Advocacy__c';
import CONTRIBUTION_LEADERSHIP from '@salesforce/schema/Contribution__c.Leadership__c';
import CONTRIBUTION_GENEROSITY from '@salesforce/schema/Contribution__c.Generosity__c';
import CONTRIBUTION_DETAILS_FIELD from '@salesforce/schema/Contribution__c.Details__c';
import CONTRIBUTION_NOTE_FIELD from '@salesforce/schema/Contribution__c.Note__c';

export default class MVPNomineeContributions extends LightningElement {
    horizontalFieldSet = [CONTRIBUTION_NAME,CONTRIBUTION_CATEGORIES,CONTRIBUTION_ASSESSMENT ];
    verticalFieldSet = [CONTRIBUTION_EXPERTISE,CONTRIBUTION_ADVOCACY,CONTRIBUTION_LEADERSHIP, CONTRIBUTION_GENEROSITY ];
    detailFieldSet = [CONTRIBUTION_NOTE_FIELD,CONTRIBUTION_DETAILS_FIELD ];
    objectName;
    @api recordId;
    mainDataYear = [];
    mainDataContribution = [];
    mainData = [];
    myData = {};
    results;

    @wire(getContactAssociatedWithDesignation, {designationId : '$recordId'})
    wiredContribution({data, error}){
        if(data){
            console.log('Data >>>> ' + JSON.stringify(data));
            for(var i=0; i<Object.keys(data).length; i++){
                this.mainDataYear.push(Object.keys(data)[i]);
                this.mainDataContribution.push(Object.values(data)[i]);
            }
            for (var i = 0; i < this.mainDataYear.length; i++) {
                this.myData = {};
                this.myData.year = this.mainDataYear[i];
                this.myData.contribution = this.mainDataContribution[i];
                
                this.mainData.push(this.myData);
            }
            this.results= this.mainData;
            console.log(`mainData : ${JSON.stringify(this.mainData)}`);

        }else if(error){
            console.log(error);
        }
    }
    @wire(getObjectInfo, { objectApiName: OBJECT_API_NAME })
    objectInfo({data, error}){
        if(data){ 
            this.objectName = data.apiName;
            console.log('objectApiName ' + this.objectName);
        }else if(error){
            console.log(error);
        }
    }
}