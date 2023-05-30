import { createElement } from 'lwc';
import MVPNomineeBasicInfo from 'c/mVPNomineeBasicInfo';
import getContactFields from '@salesforce/apex/GetContact.getContactFields';
import { setImmediate } from 'timers';
import CONTACT_OBJECT from '@salesforce/schema/Contact';

const mockContactFieldSet = require('./data/contactMockData.json');

jest.mock('@salesforce/apex/GetContact.getContactFields', () => {
    const {createApexTestWireAdapter} = require('@salesforce/sfdx-lwc-jest');
    return {
        default : createApexTestWireAdapter(jest.fn())
    }
}, {virtual: true});

const contactFieldSetList = ['No_Dreamforce_Attended__c', 'Nomination_Count__c', 'MVP_Count__c', 'Feedback_Rating_Count__c'];
const recordId = '0031y00000Uu263AAB';

describe('c-m-vpnominee-basic-info', () => {
    beforeEach(()=>{
        const element = createElement('mvp-nominee-basic-info', {
            is:MVPNomineeBasicInfo
        });
        element.fieldSet = 'Contact_Field_Set';
        document.body.appendChild(element);
    });

    afterEach(()=>{
        while(document.body.firstChild){
            document.body.removeChild(document.body.firstChild);
        }
    })

    test('check lightning record form', ()=>{
        const element = document.querySelector('mvp-nominee-basic-info');
        getContactFields.emit(mockContactFieldSet);
        return new Promise(setImmediate).then(()=>{
            const formElement = element.shadowRoot.querySelector('lightning-record-form');
            if (formElement.recordId === undefined) {
                expect(formElement.recordId).toBeUndefined();
            } else {
                expect(formElement.recordId).toBe(recordId);
                expect(formElement.objectApiName).toBe(CONTACT_OBJECT.objectApiName);
                expect(formElement.fields).toEqual(contactFieldSetList);
            }
        })
    })
})