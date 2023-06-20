import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'

export default class RecordAccordionTemplate extends NavigationMixin(LightningElement) {
    
    @api results
    @api horizontalFieldSet
    @api verticalFieldSet
    @api detailFieldSet
    @api objectName
    @api title

    @api verticalColumn=0
    @api horizontalColumn=0
    @api detailColumn=0

    @api showAverage=false
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
        return (this.detailColumn == 1) ? true : false;
    }

    get isColTwo() {
        return (this.verticalColumn == 2) ? true : false;
    }
}