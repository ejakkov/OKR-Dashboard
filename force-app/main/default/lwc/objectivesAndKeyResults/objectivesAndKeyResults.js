import { LightningElement, wire, track } from 'lwc';
import getUsers from '@salesforce/apex/SelectUserController.getUsers';
import getYears from '@salesforce/apex/SelectYearController.getYears';
import displayKeyResult from '@salesforce/apex/displayKeyResultController.getKeyResult';



export default class UserSelectionComponent extends LightningElement {
    @track selectedUserId = '';
    @track selectedYear;
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
            console.log(data);
            this.yearOptions = data.map(year => ({
                label: year.toString(),
                value: year.toString()
            }));
            console.log('years:',this.yearOptions);
        } else if (error) {
            console.error('Error fetching user data: ' + JSON.stringify(error));
        }
    }

    handleUserSelection(event) {
        this.selectedUserId = event.detail.value;
        this.getKeyResult();
    }

    handleYearSelection(event) {
        this.selectedYear = event.detail.value;
        console.log(this.selectedYear);
        this.getKeyResult();
    }


    getKeyResult() {
        if (this.objectives) {
            displayKeyResult({ userId: this.selectedUserId, year: this.selectedYear })
                .then(result => {
                    this.keyResults = result;
                    console.log('keyresults',this.keyResults);
                })
                .catch(error => {
                    console.error('Error calling Apex method: ' + JSON.stringify(error));
                });
        }
    }
}

