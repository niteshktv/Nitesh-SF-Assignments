import {createElement} from 'lwc'
import { setImmediate } from 'timers';
import MVPNomineeContribution from 'c/mVPNomineeContribution'
import getContributionRecords from '@salesforce/apex/DesignationController.getContributionsAssociatedWithDesignation'
import CONTRIBUTION_NAME  from '@salesforce/schema/Contribution__c.Name';
import CONTRIBUTION_CATEGORIES from '@salesforce/schema/Contribution__c.Pillars__c';
import CONTRIBUTION_ASSESSMENT from '@salesforce/schema/Contribution__c.Assessment__c';
import CONTRIBUTION_EXPERTISE from '@salesforce/schema/Contribution__c.Expertise__c';
import CONTRIBUTION_ADVOCACY from '@salesforce/schema/Contribution__c.Advocacy__c';
import CONTRIBUTION_LEADERSHIP from '@salesforce/schema/Contribution__c.Leadership__c';
import CONTRIBUTION_GENEROSITY from '@salesforce/schema/Contribution__c.Generosity__c';
import CONTRIBUTION_DETAILS_FIELD from '@salesforce/schema/Contribution__c.Details__c';
import CONTRIBUTION_NOTE_FIELD from '@salesforce/schema/Contribution__c.Note__c';
import CONTRIBUTION_OBJECT  from '@salesforce/schema/Contribution__c'

const horizontalFieldSet = [CONTRIBUTION_NAME,CONTRIBUTION_CATEGORIES,CONTRIBUTION_ASSESSMENT ];
const verticalFieldSet = [CONTRIBUTION_EXPERTISE,CONTRIBUTION_ADVOCACY,CONTRIBUTION_LEADERSHIP, CONTRIBUTION_GENEROSITY ];
const detailFieldSet = [CONTRIBUTION_NOTE_FIELD,CONTRIBUTION_DETAILS_FIELD ];
const detailColumn = "1"
const verticalColumn = "2"
const horizontalColumn = "3"

const contributionMockData = require('./data/contributionMockData.json');
jest.mock('@salesforce/apex/DesignationController.getContributionsAssociatedWithDesignation',()=>{
    const {createApexTestWireAdapter} = require("@salesforce/sfdx-lwc-jest");
    return{
        default : createApexTestWireAdapter(jest.fn())
    };
}, {virtual : true})

describe('test MVP Nominee Contribution Fields',()=>{
    beforeEach(()=>{
        const element = createElement('c-mvp-nominee-contribution', 
        {is:MVPNomineeContribution}
        );
        document.body.appendChild(element);
    })

    test('contribution fields test', ()=>{
        const testElement = document.body.querySelector('c-mvp-nominee-contribution');
        getContributionRecords.emit(contributionMockData);
        return Promise(setImmediate).then(()=>{
            
            const recordAccordionTemplate = testElement.shadowRoot.querySelector('c-record-accordion-template');
            expect(verticalFieldSet).toEqual(recordAccordionTemplate.verticalFieldSet);
            expect(horizontalFieldSet).toEqual(recordAccordionTemplate.horizontalFieldSet);
            expect(detailFieldSet).toEqual(recordAccordionTemplate.detailFieldSet);
            expect(CONTRIBUTION_OBJECT.objectApiName).toEqual(recordAccordionTemplate.objectName);
            expect(verticalColumn).toEqual(recordAccordionTemplate.verticalColumn);
            expect(horizontalColumn).toEqual(recordAccordionTemplate.horizontalColumn);
            expect(detailColumn).toEqual(recordAccordionTemplate.detailColumn);
        })
    })
})