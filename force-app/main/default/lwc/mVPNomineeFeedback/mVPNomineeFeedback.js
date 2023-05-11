import { LightningElement, api, wire } from 'lwc';

import getFeedbackAssociateWithDesignation from '@salesforce/apex/DesignationController.getFeedbackAssociateWithDesignation';
import FEEDBACK_EXPERTISE from '@salesforce/schema/Feedback__c.Expertise__c';
import FEEDBACK_ADVOCACY from '@salesforce/schema/Feedback__c.Advocacy__c';
import FEEDBACK_LEADERSHIP from '@salesforce/schema/Feedback__c.Leadership__c';
import FEEDBACK_GENEROSITY from '@salesforce/schema/Feedback__c.Generosity__c';
import FEEDBACK_NOMINATOR_NAME from '@salesforce/schema/Feedback__c.Nominator__c';
import FEEDBACK_NOMINATOR_EMAIL from '@salesforce/schema/Feedback__c.Email__c';
import FEEDBACK_ADVOCACY_RATING from '@salesforce/schema/Feedback__c.Advocacy_Rating__c';
import FEEDBACK_EXPERTISE_RATING from '@salesforce/schema/Feedback__c.Expertise_Rating__c';
import FEEDBACK_LEADERSHIP_RATING from '@salesforce/schema/Feedback__c.Leadership_Rating__c';
import FEEDBACK_GENEROSITY_RATING from '@salesforce/schema/Feedback__c.Generosity_Rating__c';


export default class MVPNomineeFeedback extends LightningElement {
    horizontalFieldSet = [FEEDBACK_ADVOCACY_RATING, FEEDBACK_EXPERTISE_RATING, FEEDBACK_LEADERSHIP_RATING, FEEDBACK_GENEROSITY_RATING];
    verticalFieldSet = [FEEDBACK_NOMINATOR_NAME, FEEDBACK_NOMINATOR_EMAIL];
    detailFieldSet = [FEEDBACK_EXPERTISE, FEEDBACK_ADVOCACY, FEEDBACK_LEADERSHIP, FEEDBACK_GENEROSITY];

    @api recordId;
    yearData = [];
    feedbackData = [];
    arrayOfYearToFeedbackObject = [];
    yearToFeedbackObject = {};
    results;
    averageAdvocacyRating = 0;
    averageExpertiseRating = 0;
    averageGenerosityRating = 0;
    averageLeadershipRating = 0;

    @wire(getFeedbackAssociateWithDesignation, { designationId: '$recordId' })
    wiredContribution({ data, error }) {
        if (data) {
            for (var i = 0; i < Object.keys(data).length; i++) {
                this.yearData.push(Object.keys(data)[i]);
                this.feedbackData.push(Object.values(data)[i]);
            }

            for (var i = 0; i < this.yearData.length; i++) {
                this.yearToFeedbackObject = {};
                this.yearToFeedbackObject.year = `${this.yearData[i]} (${this.feedbackData[i].length})`;
                this.yearToFeedbackObject.values = this.feedbackData[i];
                for (var k = 0; k < this.feedbackData[i].length; k++) {
                    this.averageAdvocacyRating += this.feedbackData[i][k].Advocacy_Rating__c;
                    this.averageExpertiseRating += this.feedbackData[i][k].Expertise_Rating__c;
                    this.averageGenerosityRating += this.feedbackData[i][k].Generosity_Rating__c;
                    this.averageLeadershipRating += this.feedbackData[i][k].Leadership_Rating__c;

                }
                this.yearToFeedbackObject.averageAdvocacy = (this.averageAdvocacyRating / this.feedbackData[i].length).toFixed(2);
                this.yearToFeedbackObject.averageExpertise = (this.averageExpertiseRating / this.feedbackData[i].length).toFixed(2);
                this.yearToFeedbackObject.averageGenerosity = (this.averageGenerosityRating / this.feedbackData[i].length).toFixed(2);
                this.yearToFeedbackObject.averageLeadership = (this.averageLeadershipRating / this.feedbackData[i].length).toFixed(2);
                this.yearToFeedbackObject.overallAverageRating = (this.averageAdvocacyRating + this.averageExpertiseRating + this.averageGenerosityRating + this.averageLeadershipRating) / 4;
                this.arrayOfYearToFeedbackObject.push(this.yearToFeedbackObject);

                this.averageAdvocacyRating = 0;
                this.averageExpertiseRating = 0;
                this.averageGenerosityRating = 0;
                this.averageLeadershipRating = 0;
            }
            this.results = this.arrayOfYearToFeedbackObject;

        } else if (error) {
            console.log(error);
        }
    }
}