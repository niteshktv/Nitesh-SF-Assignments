import {createElement} from 'lwc'
import { setImmediate } from 'timers';
import MVPNomineeSelfFeedback from 'c/mVPNomineeSelfFeedback'
import getSelfFeedbackAssociateWithDesignation from '@salesforce/apex/DesignationController.getSelfFeedbackAssociateWithDesignation'
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
import FEEDBACK_OBJECT  from '@salesforce/schema/Feedback__c'

const  feedbackFieldSet = [FEEDBACK_EXPERTISE,
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

const feedbackMockData = require('./data/selfFeedbackMockData.json');
jest.mock('@salesforce/apex/DesignationController.getSelfFeedbackAssociateWithDesignation',()=>{
    const {createApexTestWireAdapter} = require("@salesforce/sfdx-lwc-jest");
    return{
        default : createApexTestWireAdapter(jest.fn())
    };
}, {virtual : true});

describe('self feedback check test suite', ()=>{
    beforeEach(()=> {
        const element = createElement('c-mvp-nominee-self-feedback',{
            is: MVPNomineeSelfFeedback
        });
        document.body.appendChild(element);
    });

    test('test feedback fieldSets', ()=>{
        const element = document.querySelector('c-mvp-nominee-self-feedback');
        getSelfFeedbackAssociateWithDesignation.emit(feedbackMockData);
        return new Promise(setImmediate).then(()=>{
            const recordAccordionTemplate = element.shadowRoot.querySelector('c-record-accordion-template');
            expect(feedbackFieldSet).toEqual(recordAccordionTemplate.verticalFieldSet);
            expect(FEEDBACK_OBJECT.objectApiName).toEqual(recordAccordionTemplate.objectName);
            expect(recordAccordionTemplate.verticalColumn).toBe("2");
        })
    })
})