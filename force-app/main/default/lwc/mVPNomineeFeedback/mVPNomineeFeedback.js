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
    mainDataYear = [];
    mainDataFeedback = [];
    mainData = [];
    myData = {};
    results;
    averageAdvocacyRating = 0;
    averageExpertiseRating = 0;
    averageGenerosityRating = 0;
    averageLeadershipRating = 0;

    @wire(getFeedbackAssociateWithDesignation, { designationId: '$recordId' })
    wiredContribution({ data, error }) {
        if (data) {
            for (var i = 0; i < Object.keys(data).length; i++) {
                this.mainDataYear.push(Object.keys(data)[i]);
                this.mainDataFeedback.push(Object.values(data)[i]);
            }

            for (var i = 0; i < this.mainDataYear.length; i++) {
                this.myData = {};
                this.myData.year = `${this.mainDataYear[i]} (${this.mainDataFeedback[i].length})`;
                this.myData.values = this.mainDataFeedback[i];
                for (var k = 0; k < this.mainDataFeedback[i].length; k++) {
                    this.averageAdvocacyRating += this.mainDataFeedback[i][k].Advocacy_Rating__c;
                    this.averageExpertiseRating += this.mainDataFeedback[i][k].Expertise_Rating__c;
                    this.averageGenerosityRating += this.mainDataFeedback[i][k].Generosity_Rating__c;
                    this.averageLeadershipRating += this.mainDataFeedback[i][k].Leadership_Rating__c;

                }
                this.myData.averageAdvocacy = this.averageAdvocacyRating / this.mainDataFeedback[i].length;
                this.myData.averageExpertise = this.averageExpertiseRating / this.mainDataFeedback[i].length;
                this.myData.averageGenerosity = this.averageGenerosityRating / this.mainDataFeedback[i].length;
                this.myData.averageLeadership = this.averageLeadershipRating / this.mainDataFeedback[i].length;
                this.myData.overallAverageRating = (this.averageAdvocacyRating + this.averageExpertiseRating + this.averageGenerosityRating + this.averageLeadershipRating) / 4;
                this.mainData.push(this.myData);

                this.averageAdvocacyRating = 0;
                this.averageExpertiseRating = 0;
                this.averageGenerosityRating = 0;
                this.averageLeadershipRating = 0;
            }
            console.log('MainData : ' + JSON.stringify(this.mainData));
            this.results = this.mainData;

        } else if (error) {
            console.log(error);
        }
    }
}