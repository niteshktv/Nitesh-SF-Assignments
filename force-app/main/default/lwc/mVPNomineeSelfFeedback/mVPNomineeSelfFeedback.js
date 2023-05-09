import { LightningElement, api,wire } from 'lwc';
import getSelfFeedbackAssociateWithDesignation from '@salesforce/apex/DesignationController.getSelfFeedbackAssociateWithDesignation';
import FEEDBACK_EXPERTISE from '@salesforce/schema/Feedback__c.Expertise__c';
import FEEDBACK_ADVOCACY from '@salesforce/schema/Feedback__c.Advocacy__c';
import FEEDBACK_LEADERSHIP from '@salesforce/schema/Feedback__c.Leadership__c';
import FEEDBACK_GENEROSITY from '@salesforce/schema/Feedback__c.Generosity__c';
import FEEDBACK_ADDITIONAL_COMMENT from '@salesforce/schema/Feedback__c.Additional_Comments__c';
import FEEDBACK_DATE from '@salesforce/schema/Feedback__c.Date__c';
import FEEDBACK_DESCRIBE_NOMINEE from '@salesforce/schema/Feedback__c.Please_describe_how_you_know__c';
import FEEDBACK_CONCERNS from '@salesforce/schema/Feedback__c.Do_you_have_any_concerns__c';
import FEEDBACK_KNOW_NOMINEE from '@salesforce/schema/Feedback__c.Do_you_have_any_concerns__c';
import FEEDBACK_PRESONAL_MEAN from '@salesforce/schema/Feedback__c.Personally_mean_to_be_MVP__c';
import FEEDBACK_RENEWED from '@salesforce/schema/Feedback__c.Should_you_be_renewed__c';

export default class MVPNomineeSelfFeedback extends LightningElement {
    feedbackFieldSet = [FEEDBACK_EXPERTISE,
        FEEDBACK_ADVOCACY,
        FEEDBACK_LEADERSHIP,
        FEEDBACK_LEADERSHIP,
        FEEDBACK_GENEROSITY,
        FEEDBACK_ADDITIONAL_COMMENT,
        FEEDBACK_DATE,
        FEEDBACK_DESCRIBE_NOMINEE,
        FEEDBACK_CONCERNS,
        FEEDBACK_KNOW_NOMINEE,
        FEEDBACK_PRESONAL_MEAN,
        FEEDBACK_RENEWED
    ];

    @api recordId;
    mainDataYear = [];
    mainDataFeedback = [];
    mainData = [];
    myData = {};
    results;

    @wire(getSelfFeedbackAssociateWithDesignation, { designationId: '$recordId' })
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