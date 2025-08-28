import { LightningElement, wire, api } from 'lwc';
import { getRecord, updateRecord, getFieldValue  } from 'lightning/uiRecordApi';

import LightningAlert from 'lightning/alert';
import { NavigationMixin } from 'lightning/navigation';
import userId from '@salesforce/user/Id'; // -> ActualInAppServiceResourceID

const fields = [
    'ServiceAppointment.CoIT_Acceptance_Status__c',
    'ServiceAppointment.Status',
    'ServiceAppointment.AppointmentNumber',
    'ServiceAppointment.Subject',
    'ServiceAppointment.ArrivalWindowStartTime',
    'ServiceAppointment.EarliestStartTime',
    'ServiceAppointment.CoIT_WOM_Scheduling_Type__c',
    'ServiceAppointment.CoIT_WOM_Appointment_Type__c',
    'ServiceAppointment.CreatedDate',
    'ServiceAppointment.CoIT_WOM_Business_Line__c',
    'ServiceAppointment.DurationType',
    'ServiceAppointment.Duration',
    'ServiceAppointment.WorkType.Name',
    'ServiceAppointment.City',
    'ServiceAppointment.State',
    'ServiceAppointment.PostalCode',
    'ServiceAppointment.Street',
    'ServiceAppointment.Country',
    'ServiceAppointment.Latitude',
    'ServiceAppointment.Longitude',
    'ServiceAppointment.CoIT_AssignedUserId__c'
];

export default class CoIT_WOM_acceptanceSA extends NavigationMixin(LightningElement)  {
    @api recordId; // The record ID of the Service Appointment is passed to the component

    @wire(getRecord, { recordId: '$recordId', fields })
    serviceAppointment;

    currentUserId = userId;

    get CoITAssignedUserId() {
        return this.serviceAppointment.data.fields.CoIT_AssignedUserId__c.value;
    }

    //gets Ok
    get AppointmentNumber() {
        return this.serviceAppointment.data.fields.AppointmentNumber.value;
    }

    get CoIT_WOM_Scheduling_Type__c() {
        return this.serviceAppointment.data.fields.CoIT_WOM_Scheduling_Type__c.value;
    }

    get CoIT_WOM_Appointment_Type__c() {
        return this.serviceAppointment.data.fields.CoIT_WOM_Appointment_Type__c.value;
    }

    get CoIT_WOM_Appointment_Type__c() {
        return this.serviceAppointment.data.fields.CoIT_WOM_Appointment_Type__c.value;
    }

    get Street() {
        return this.serviceAppointment.data.fields.Street.value;
    }

    get City() {
        return this.serviceAppointment.data.fields.City.value;
    }

    get Country() {
        return this.serviceAppointment.data.fields.Country.value;
    }

    get State() {
        return this.serviceAppointment.data.fields.State.value;
    }

    get PostalCode() {
        return this.serviceAppointment.data.fields.PostalCode.value;
    }

    get Subject() {
        return this.serviceAppointment.data.fields.Subject.value;
    }

    get EarliestStartTime() {
        return this.serviceAppointment.data.fields.EarliestStartTime.value;
    }

    get ArrivalWindowStartTime() {
        return this.serviceAppointment.data.fields.ArrivalWindowStartTime.value;
    }

    get CoIT_WOM_Business_Line__c() {
        return this.serviceAppointment.data.fields.CoIT_WOM_Business_Line__c.value;
    }

    get durationText() {
        const durationText = this.serviceAppointment.data.fields.Duration.value + ' ' + this.serviceAppointment.data.fields.DurationType.value;
        return durationText;
    }

    get CreatedDate() {
        return this.serviceAppointment.data.fields.CreatedDate.value;
    }

    get WorkTypeName() {
        return this.serviceAppointment.data.fields.WorkType.value.fields.Name.value;
    }

    get CoIT_Acceptance_Status__c() {
        return this.serviceAppointment.data.fields.CoIT_Acceptance_Status__c.value;
    }

    get status() {
        return this.serviceAppointment.data.fields.Status.value;
    }

    //#region mapMarkers
    get mapMarkers() {
        if (this.serviceAppointment.data) {
            const sa = this.serviceAppointment.data.fields;

            let description = '';
                description += this.serviceAppointment.data.fields.Street.value ? this.serviceAppointment.data.fields.Street.value : '';
                //description += sa.Street.value ? sa.Street.value : '';
                description += this.serviceAppointment.data.fields.City.value ? ', ' + this.serviceAppointment.data.fields.City.value : '';
                description += this.serviceAppointment.data.fields.State.value ? ', ' + this.serviceAppointment.data.fields.State.value : '';
                description += this.serviceAppointment.data.fields.PostalCode.value ? ', ' + this.serviceAppointment.data.fields.PostalCode.value : '';
                description += this.serviceAppointment.data.fields.Country.value ? ', ' + this.serviceAppointment.data.fields.Country.value : '';

            return [
                {
                    location: {
                        Latitude: sa.Latitude.value,
                        Longitude: sa.Longitude.value
                    },
                    title: sa.Subject.value,
                    description: description
                    //description: `Service appointment scheduled at ${sa.Street.value}, ${sa.City.value}`
                    // You can add more properties here as needed
                }
            ];
        }
        return [];
    }

    get zoomLevel() {
        return this.mapMarkers.length > 1 ? '' : '13';
    }

    //#region handleButtonClick
    async handleButtonClick(event) {
        const buttonValue = event.target.value;
        let message = buttonValue === 'Accepted' ? 'accepted' : 'rejected';
        message = 'The Service Appointment has been ' + message;

        const servAppment = {
            fields: {
                Id: this.recordId,
                CoIT_Acceptance_Status__c: buttonValue
            }
        };

        let error;

        try {
            await updateRecord(servAppment);
        }
        catch (e) {
            error = e;
        }

        if (error === undefined || error?.errorType === 'networkAdapterError') {
            await LightningAlert.open({
                message: message,
                theme: buttonValue === 'Accepted' ? 'success' : 'error',
                label: buttonValue === 'Accepted' ? 'Accepted' : 'Rejected',
            });

            const pageRef = {
                "type": "standard__webPage",
                "attributes": {
                    "url": `com.salesforce.fieldservice://v1/sObject/${this.recordId}/details`
                }
            };

            this[NavigationMixin.Navigate](pageRef);
        }
        else {
            LightningAlert.open({
                message: JSON.stringify(error),
                theme: 'error',
                label: 'Error',
            });
        }
    }

    //#region validateStatusAndAssignedServiceResource
    get validateStatusAndAssignedServiceResource() {
        //return this.mapMarkers.length > 0;
        return this.serviceAppointment.data.fields.Status.value !== 'Scheduled' || this.serviceAppointment.data.fields.CoIT_Acceptance_Status__c.value !== null ||  (this.serviceAppointment.data.fields.CoIT_AssignedUserId__c.value !== this.currentUserId.substring(0, 15) );
    }
}