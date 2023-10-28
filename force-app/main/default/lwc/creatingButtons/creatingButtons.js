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

    createGoogleReview() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'GoogleReview__c',
                actionName: 'new',
            },
        });
    }
    // Implement similar functions for other custom objects
}