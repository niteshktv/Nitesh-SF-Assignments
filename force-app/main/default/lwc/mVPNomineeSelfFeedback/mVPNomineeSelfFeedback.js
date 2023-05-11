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
    yearData = [];
    feedbackData = [];
    arrayOfYearToFeedbackObject = [];
    yearToFeedbackObject = {};
    results;

    @wire(getSelfFeedbackAssociateWithDesignation, { designationId: '$recordId' })
    wiredContribution({data, error }) {
        if (data) {
            for (var i = 0; i < Object.keys(data).length; i++) {
                this.yearData.push(Object.keys(data)[i]);
                this.feedbackData.push(Object.values(data)[i]);
            }
            for (var i = 0; i < this.yearData.length; i++) {
                this.yearToFeedbackObject = {};
                this.yearToFeedbackObject.year = `${this.yearData[i]} (${this.feedbackData[i].length})`;
                this.yearToFeedbackObject.values = this.feedbackData[i];

                this.arrayOfYearToFeedbackObject.push(this.yearToFeedbackObject);
            }
            this.results = this.arrayOfYearToFeedbackObject;

        } else if (error) {
            console.log(error);
        }
    }
}