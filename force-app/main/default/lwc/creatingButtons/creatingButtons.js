import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ObjectiveNewButtonLWC extends NavigationMixin(LightningElement) {
    createObjective() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Objective__c',
                actionName: 'new',
            },
        });
    }

    createKeyResult() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'KeyResult__c',
                actionName: 'new',
            },
        });
    }

    createReview() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Review__c',
                actionName: 'new',
            },
        });
    }

    createGoogleReview() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'GoogleReview__c',
                actionName: 'new',
            },
        });
    }

    createSurvey() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Survey__c',
                actionName: 'new',
            },
        });
    }

    createCaseStudy() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'CaseStudy__c',
                actionName: 'new',
            },
        });
    }

    createEvent() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Event__c',
                actionName: 'new',
            },
        });
    }

    createCall() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Call__c',
                actionName: 'new',
            },
        });
    }

    createContract() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contract',
                actionName: 'new',
            },
        });
    }

    createOpportunity() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Opportunity',
                actionName: 'new',
            },
        });
    }

    createLinkedInLead() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'LinkedInLead__c',
                actionName: 'new',
            },
        });
    }

    createTarget() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Target__c',
                actionName: 'new',
            },
        });
    }
}