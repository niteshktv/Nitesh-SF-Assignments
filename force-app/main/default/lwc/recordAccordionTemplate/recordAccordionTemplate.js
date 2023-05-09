import { LightningElement,api } from 'lwc';

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