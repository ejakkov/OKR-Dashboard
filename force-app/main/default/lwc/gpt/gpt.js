import { LightningElement, wire, track } from 'lwc';
import getUsers from '@salesforce/apex/SelectUserController.getUsers';
import getYears from '@salesforce/apex/SelectYearController.getYears';
import displayObjective from '@salesforce/apex/displayObjectiveController.getObjective';
import displayKeyResult from '@salesforce/apex/displayKeyResultController.getKeyResult';



export default class UserSelectionComponent extends LightningElement {
    @track selectedUserId = '';
    @track userOptions = [];
    @track yearOptions = [];
    @track objectives = [];
    @track keyResults = [];

    @wire(getUsers) wiredUsers({ error, data }) {
        if (data) {
            this.userOptions = data.map(user => ({
                label: user.Name,
                value: user.Id
            }));
        } else if (error) {
            console.error('Error fetching user data: ' + JSON.stringify(error));
        }
    }

    @wire(getYears) wiredYears({ error, data }) {
        if (data) {
            this.yearOptions = data.map(year => ({
                label: year.year,
                value: year.year
            }));
        } else if (error) {
            console.error('Error fetching user data: ' + JSON.stringify(error));
        }
    }

    handleUserSelection(event) {
        this.selectedUserId = event.detail.value;
        this.getObjective();
    }

    getObjective() {
        if (this.selectedUserId) {
            displayObjective({ userId: this.selectedUserId })
                .then(result => {
                    this.objectives = result;
                    this.getKeyResult();
                })
                .catch(error => {
                    console.error('Error calling Apex method: ' + JSON.stringify(error));
                });
        }
    }

    getKeyResult(){
        if (this.objectives) {

            displayKeyResult({ objectivesList: this.objectives})
                .then(result => {
                    this.keyResults = result;
                    console.log(this.keyResults);
                })
                .catch(error => {
                    console.error('Error calling Apex method: ' + JSON.stringify(error));
                });
        }
    }
}