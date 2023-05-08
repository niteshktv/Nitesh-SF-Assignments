import { LightningElement,wire,api } from 'lwc';
import getContributionsAssociatedWithDesignation from '@salesforce/apex/DesignationController.getContributionsAssociatedWithDesignation';
import CONTRIBUTION_NAME  from '@salesforce/schema/Contribution__c.Name';
import CONTRIBUTION_CATEGORIES from '@salesforce/schema/Contribution__c.Pillars__c';
import CONTRIBUTION_ASSESSMENT from '@salesforce/schema/Contribution__c.Assessment__c';
import CONTRIBUTION_EXPERTISE from '@salesforce/schema/Contribution__c.Expertise__c';
import CONTRIBUTION_ADVOCACY from '@salesforce/schema/Contribution__c.Advocacy__c';
import CONTRIBUTION_LEADERSHIP from '@salesforce/schema/Contribution__c.Leadership__c';
import CONTRIBUTION_GENEROSITY from '@salesforce/schema/Contribution__c.Generosity__c';
import CONTRIBUTION_DETAILS_FIELD from '@salesforce/schema/Contribution__c.Details__c';
import CONTRIBUTION_NOTE_FIELD from '@salesforce/schema/Contribution__c.Note__c';

export default class MVPNomineeContribution extends LightningElement {
    horizontalFieldSet = [CONTRIBUTION_NAME,CONTRIBUTION_CATEGORIES,CONTRIBUTION_ASSESSMENT ];
    verticalFieldSet = [CONTRIBUTION_EXPERTISE,CONTRIBUTION_ADVOCACY,CONTRIBUTION_LEADERSHIP, CONTRIBUTION_GENEROSITY ];
    detailFieldSet = [CONTRIBUTION_NOTE_FIELD,CONTRIBUTION_DETAILS_FIELD ];
    objectName='Contribution__c'

    @api recordId;
    mainDataYear = [];
    mainDataContribution = [];
    mainData = [];
    myData = {};
    results;

    @wire(getContributionsAssociatedWithDesignation, {designationId : '$recordId'})
    wiredContribution({data, error}){
        if(data){
            this.mainDataYear = [];
            this.mainDataContribution = [];
            for(var i=0; i<Object.keys(data).length; i++){
                this.mainDataYear.push(Object.keys(data)[i]);
                this.mainDataContribution.push(Object.values(data)[i]);
            }
            for (var i = 0; i < this.mainDataYear.length; i++) {
                this.myData = {};
                this.myData.year = this.mainDataYear[i];
                this.myData.values = this.mainDataContribution[i];
                
                this.mainData.push(this.myData);
            }
            this.results= this.mainData;

        }else if(error){
            console.log(error);
        }
    }
}