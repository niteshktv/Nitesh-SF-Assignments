import { LightningElement,api } from 'lwc';

export default class RecordAccordionTemplate extends LightningElement {
    
    @api results
    @api horizontalFieldSet
    @api verticalFieldSet
    @api detailFieldSet
    @api objectName
    @api title

    @api column
    get isColOne() {
        return (this.column == 1) ? true : false;
    }

    get isColTwo() {
        return (this.column == 2) ? true : false;
    }

    get isColThree() {
        return (this.column == 3) ? true : false;
    }
}