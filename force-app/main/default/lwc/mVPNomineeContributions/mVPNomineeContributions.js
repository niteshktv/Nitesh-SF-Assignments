import { LightningElement, api, wire } from 'lwc';

export default class MVPNomineeContributions extends LightningElement {
    
    @api results
    @api horizontalFieldSet
    @api verticalFieldSet
    @api detailFieldSet
    @api objectName
    @api title
}