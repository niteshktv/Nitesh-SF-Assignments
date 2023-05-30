import {createElement} from 'lwc'
import { setImmediate } from 'timers';
import MVPNomineeFeedback from 'c/mVPNomineeFeedback'

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
import FEEDBACK_OBJECT  from '@salesforce/schema/Feedback__c'

const horizontalFieldSet = [FEEDBACK_ADVOCACY_RATING, FEEDBACK_EXPERTISE_RATING, FEEDBACK_LEADERSHIP_RATING, FEEDBACK_GENEROSITY_RATING];
const verticalFieldSet = [FEEDBACK_NOMINATOR_NAME, FEEDBACK_NOMINATOR_EMAIL];
const detailFieldSet = [FEEDBACK_EXPERTISE, FEEDBACK_ADVOCACY, FEEDBACK_LEADERSHIP, FEEDBACK_GENEROSITY];

const feedbackMockData = require('./data/feedbackMockData.json');
jest.mock('@salesforce/apex/DesignationController.getFeedbackAssociateWithDesignation',()=>{
    const {createApexTestWireAdapter} = require("@salesforce/sfdx-lwc-jest");
    return{
        default : createApexTestWireAdapter(jest.fn())
    };
}, {virtual : true});

describe('self feedback check test suite', ()=>{
    beforeEach(()=> {
        const element = createElement('c-mvp-nominee-feedback',{
            is: MVPNomineeFeedback
        });
        document.body.appendChild(element);
    });

    test('test self-feedback fieldSets', ()=>{
        const element = document.querySelector('c-mvp-nominee-feedback');
        getFeedbackAssociateWithDesignation.emit(feedbackMockData);
        return new Promise(setImmediate).then(()=>{
            const recordAccordionTemplate = element.shadowRoot.querySelector('c-record-accordion-template');
            console.log(`detailColumn : ${recordAccordionTemplate.detailColumn}`);
            expect(verticalFieldSet).toEqual(recordAccordionTemplate.verticalFieldSet);
            expect(horizontalFieldSet).toEqual(recordAccordionTemplate.horizontalFieldSet);
            expect(detailFieldSet).toEqual(recordAccordionTemplate.detailFieldSet);
            expect(FEEDBACK_OBJECT.objectApiName).toEqual(recordAccordionTemplate.objectName);
            expect(recordAccordionTemplate.verticalColumn).toBe("2");
            expect(recordAccordionTemplate.horizontalColumn).toBe("4");
            expect(recordAccordionTemplate.detailColumn).toBe("1");
            expect(recordAccordionTemplate.showAverage).toBe("true");
        })
    })
})