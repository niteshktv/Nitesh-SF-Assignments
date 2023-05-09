import { LightningElement,api, wire } from 'lwc';

import getFeedbackAssociateWithDesignation from '@salesforce/apex/DesignationController.getFeedbackAssociateWithDesignation';
import FEEDBACK_EXPERTISE from '@salesforce/schema/Feedback__c.Expertise__c';
import FEEDBACK_ADVOCACY from '@salesforce/schema/Feedback__c.Advocacy__c';
import FEEDBACK_LEADERSHIP from '@salesforce/schema/Feedback__c.Leadership__c';
import FEEDBACK_GENEROSITY from '@salesforce/schema/Feedback__c.Generosity__c';
import FEEDBACK_NOMINATOR_NAME from '@salesforce/schema/Feedback__c.Nominator__c';
import FEEDBACK_NOMINATOR_EMAIL from '@salesforce/schema/Feedback__c.Nominator__c';
import FEEDBACK_ADVOCACY_RATING from '@salesforce/schema/Feedback__c.Advocacy_Rating__c';
import FEEDBACK_EXPERTISE_RATING from '@salesforce/schema/Feedback__c.Expertise_Rating__c';
import FEEDBACK_LEADERSHIP_RATING from '@salesforce/schema/Feedback__c.Leadership_Rating__c';
import FEEDBACK_GENEROSITY_RATING from '@salesforce/schema/Feedback__c.Generosity_Rating__c';


export default class MVPNomineeFeedback extends LightningElement {
    horizontalFieldSet = [FEEDBACK_ADVOCACY_RATING,FEEDBACK_EXPERTISE_RATING, FEEDBACK_LEADERSHIP_RATING, FEEDBACK_GENEROSITY_RATING];
    verticalFieldSet = [FEEDBACK_NOMINATOR_NAME,FEEDBACK_NOMINATOR_EMAIL];
    detailFieldSet = [FEEDBACK_EXPERTISE,FEEDBACK_ADVOCACY,FEEDBACK_LEADERSHIP,FEEDBACK_GENEROSITY];

    @api recordId;
    mainDataYear = [];
    mainDataFeedback = [];
    mainData = [];
    myData = {};
    results;

    @wire(getFeedbackAssociateWithDesignation, { designationId: '$recordId' })
    wiredContribution({data, error }) {
        if (data) {
            this.mainDataYear = [];
            this.mainDataFeedback = [];
            for (var i = 0; i < Object.keys(data).length; i++) {
                this.mainDataYear.push(Object.keys(data)[i]);
                this.mainDataFeedback.push(Object.values(data)[i]);
            }
            for (var i = 0; i < this.mainDataYear.length; i++) {
                this.myData = {};
                this.myData.year = `${this.mainDataYear[i]} (${this.mainDataFeedback[i].length})`;
                this.myData.values = this.mainDataFeedback[i];

                this.mainData.push(this.myData);
            }
            this.results = this.mainData;

        } else if (error) {
            console.log(error);
        }
    }
}