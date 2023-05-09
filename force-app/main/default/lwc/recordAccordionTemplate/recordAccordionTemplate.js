import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'

export default class RecordAccordionTemplate extends NavigationMixin(LightningElement) {
    
    @api results
    @api horizontalFieldSet
    @api verticalFieldSet
    @api detailFieldSet
    @api objectName
    @api title

    @api columnOne=0
    @api columnTwo=0
    @api columnThree=0
    @api columnFour=0

    refresh() {
        location.reload();
    }

    createNewRecord(){
        this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                objectApiName:'Feedback__c',
                actionName:'new'
            }
        })
    }

    get isFeedbackObject(){
        return (this.objectName === 'Feedback__c') ? true : false;
    }
    
    get isColOne() {
        return (this.columnOne == 1) ? true : false;
    }

    get isColTwo() {
        return (this.columnTwo == 2) ? true : false;
    }

    get isColThree() {
        return (this.columnThree == 3) ? true : false;
    }

    get isColFour() {
        return (this.columnFour == 4) ? true : false;
    }
}