import { LightningElement,api } from 'lwc';

export default class RecordAccordionTemplate extends LightningElement {
    
    @api results
    @api horizontalFieldSet
    @api verticalFieldSet
    @api detailFieldSet
    @api objectName
    @api title
}