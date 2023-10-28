import { LightningElement, api } from 'lwc';

export default class objectiveCard extends LightningElement {
    @api user;
    @api userId;

    connectedCallback() {
        console.log('Record ID:', this.recordId);
        console.log('Movie Data:', this.movie);
    }

}