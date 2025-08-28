import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, updateRecord, getFieldValue } from 'lightning/uiRecordApi';
import LightningAlert from 'lightning/alert';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';

const MAPICON_DROPOFF = {
    path: 'M9 3.5C9 2.7 8.3 2 7.5 2h-3C3.7 2 3 2.7 3 3.5v45c0 .8.7 1.5 1.5 1.5h3c.8 0 1.5-.7 1.5-1.5v-45zM47.5 7.7c-16 8.4-14.2-8.8-33.5-2.1-.6.2-1 .8-1 1.4v23.3c0 .7.7 1.2 1.3.9 19.2-6.4 17.2 11.2 33.9 1.8.5-.3.8-.8.8-1.3V8.5c0-.7-.8-1.2-1.5-.8z',
    fillColor: '#EA4435',
    fillOpacity: 1,
    strokeWeight: 1,
    strokeColor: '#B41512',
    scale: .80,
    anchor: { x: 5, y: 50 }
};

const WOffer_FIELDS = [
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.Id',
    'WOM_WorkOfferDetail__c.WOM_Status__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Number__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ContactName__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_NecesidadCliente__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_RequerimientosCliente__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_SchedulingType__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_AppointmentType__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointmentSubject__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Address__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Address2__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_CreatedDate__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_WorkTypeName__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Latitude__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Longitude__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Latitude2__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.CoIT_Closure_In_Progress__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Longitude2__c'
];

const MAPWOffer_FIELDS = [
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.Id',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Latitude__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Longitude__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Latitude2__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Longitude2__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointmentSubject__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Address__c',
    'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Address2__c'
];

const MAPStatus_FIELD = ['WOM_WorkOfferDetail__c.WOM_Status__c', 
                         'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.CoIT_Closure_In_Progress__c',
                        'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.CreatedDate'];

export default class WorkOfferDetails extends NavigationMixin(LightningElement) {
    @api recordId;
    error;
    flag = false;

    pollInterval;
    wiredStatusResult;

    @wire(getRecord, { recordId: '$recordId', fields: WOffer_FIELDS })
    wOfferDetail;

    // #region init new code CAM +++++++++++++++++++

    get WOM_ServiceAppointment_Number__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_ServiceAppointment_Number__c.value : '';
    }

    get WOM_ContactName__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_ContactName__c.value : '';
    }

    get WOM_NecesidadCliente__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_NecesidadCliente__c.value : '';
    }

    get WOM_RequerimientosCliente__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_RequerimientosCliente__c.value : '';
    }

    get WOM_SchedulingType__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_SchedulingType__c.value : '';
    }

    get isEmergency() {
        return this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_SchedulingType__c === 'Emergency';
    }

    get WOM_AppointmentType__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_AppointmentType__c.value : '';
    }

    get WOM_ServiceAppointment_Address__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_ServiceAppointment_Address__c.value : '';
    }

    get WOM_ServiceAppointment_Address2__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_ServiceAppointment_Address2__c.value : '';
    }

    get WOM_ServiceAppointmentSubject__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_ServiceAppointmentSubject__c.value : '';
    }

    get WOM_ServiceAppointment_CreatedDate__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_ServiceAppointment_CreatedDate__c.value : '';
    }

    get WOM_WorkTypeName__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_WorkTypeName__c.value : '';
    }

    get WOM_ServiceAppointment_Latitude__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_ServiceAppointment_Latitude__c.value : '';
    }

    get WOM_ServiceAppointment_Longitude__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_ServiceAppointment_Longitude__c.value : '';
    }

    get WOM_ServiceAppointment_Latitude2__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_ServiceAppointment_Latitude2__c.value : '';
    }

    get WOM_ServiceAppointment_Longitude2__c() {
        return this.wOfferDetail.data ? this.wOfferDetail.data.fields.WOM_WorkOffer__r.value.fields.WOM_ServiceAppointment_Longitude2__c.value : '';
    }

    // #region MAP Aditional functions for map and markers +++++++++++++++

    @track mapMarkers = [];

    connectedCallback() {}

    @wire(getRecord, { recordId: '$recordId', fields: MAPWOffer_FIELDS })
    wiredServiceAppointment({ error, data }) {
        if (data) {
            
            const latitude = getFieldValue(data, 'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Latitude__c');
            const longitude = getFieldValue(data, 'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Longitude__c');
            const latitude2 = getFieldValue(data, 'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Latitude2__c');
            const longitude2 = getFieldValue(data, 'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Longitude2__c');
            const Title = getFieldValue(data, 'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointmentSubject__c') || 'Agendamiento';
            const Description = getFieldValue(data, 'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Address__c');
            const Description2 = getFieldValue(data, 'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.WOM_ServiceAppointment_Address2__c');

            if (this.isValidLatitude(latitude) && this.isValidLongitude(longitude)) {
                this.mapMarkers = [{
                    location: {
                        Latitude: latitude,
                        Longitude: longitude
                    },
                    title: Title,
                    description: Description,
                    mapIcon: Title.includes('Drop Off') ? MAPICON_DROPOFF : null,
                    icon: Title.includes('Drop Off') ? 'utility:priority' : 'utility:checkin'
                },
                {
                    location: {
                        Latitude: latitude2,
                        Longitude: longitude2
                    },
                    title: Title,
                    description: Description2,
                    //mapIcon: Title.includes('Drop Off') ? MAPICON_DROPOFF : null,
                    mapIcon: MAPICON_DROPOFF,
                    icon: Title.includes('Drop Off') ? 'utility:priority' : 'utility:checkin'
                }];
            } else {
                console.error('Invalid latitude or longitude values.');
            }
            this.verificationDevice();
        } else if (error) {
            console.error(error);
        }
    }

    isValidLatitude(lat) {
        return lat >= -90 && lat <= 90;
    }

    isValidLongitude(lng) {
        return lng >= -180 && lng <= 180;
    }

    get zoomLevel() {
        return this.mapMarkers.length > 1 ? '' : '13';
    }

    get mapMarkersNotEmpty() {
        return this.mapMarkers.length > 0;
    }

    verificationDevice(){
        this.startPolling();
    }

    @wire(getRecord, { recordId: '$recordId', fields: MAPStatus_FIELD })
    woChangeClousure(result){
        this.wiredStatusResult = result; // Guarda la respuesta completa
    }

    // Se hace un proceso en que cada cierto intervalo se realiza un Wire del Result
    startPolling() {
        this.pollInterval = setInterval(() => {
            if (this.wiredStatusResult) {
                refreshApex(this.wiredStatusResult).then(() => {
                    const data = this.wiredStatusResult.data;
                    const error = this.wiredStatusResult.error;
                    if (data) {
                        // Estamos es consultando directament el campo de Work Offer y lo enviamos a la función
                        this.changeFieldCheck(data.fields.WOM_WorkOffer__r.value.fields.CoIT_Closure_In_Progress__c.value);

                        // Vamos a verificar la fecha de la Work Offer en comparación con la fecha actual
                        this.dateCheck(data.fields.WOM_WorkOffer__r.value.fields.CreatedDate.value);
                    }
                    if (error) {
                        console.error('Error al actualizar:', error);
                    }
                });
            }
        }, 1000);
    }

    // Primera prueba del Polling (esta atento al cambio de estado)
    changeFieldCheck(field){
        
        if (field == true){
            // Si el cambio es verdadero entonces se activa la bandera
            // Y se limpia el intervalo
            this.flag = true;
            clearInterval(this.pollInterval);
        }
    }

    // Segunda prueba del Polling (verifica si entre la fecha actual y la creada han pasado más de 3 minutos)
    dateCheck(field){
        
        let createdDate = new Date(field);
        let now = new Date();

        // Calcular la diferencia en milisegundos
        let diffInMs = now - createdDate;
        let diffInMinutes = diffInMs / (1000 * 60);

        // Si supera los 3 minutos, activar bandera y detener polling
        if (diffInMinutes > 3) {
            this.flag = true;
            clearInterval(this.pollInterval);
        }
    }

    // Cuando se desconecta el componente se limpia el intervalo
    disconnectedCallback() {
        clearInterval(this.pollInterval);
    }

    //  #region BUTTONS Aditional functions for buttons

    @wire(getRecord, { recordId: '$recordId', fields: MAPStatus_FIELD })
    wOfferDetailStatus;

    get isOverdue() {
        
        const status = getFieldValue(this.wOfferDetailStatus.data, 'WOM_WorkOfferDetail__c.WOM_Status__c');
        const closureInProgress = getFieldValue(this.wOfferDetailStatus.data, 'WOM_WorkOfferDetail__c.WOM_WorkOffer__r.CoIT_Closure_In_Progress__c');
    
        // Caso 1: Si el status NO es 'Open' → isOverdue debe ser true
        if (status !== 'Open') {
            return true;
        }
    
        // Caso 2: Si el status es 'Open' Y closureInProgress es true → isOverdue debe ser true
        if (status === 'Open' && closureInProgress === true) {
            return true;
        }
    
        // Caso 3: Si flag es true → isOverdue debe ser true
        if (this.flag === true) {
            clearInterval(this.pollInterval);
            return true;
        }
    
        // En cualquier otro caso → isOverdue es false
        return false;
    }

    async handleButtonClick(event) {
        const buttonValue = event.target.value;
        let message = buttonValue === 'Accept' ? 'aceptada' : 'rechazada';
        message = 'La oferta ha sido ' + message;

        const wOffer = {
            fields: {
                Id: this.recordId,
                WOM_Acceptance_Status__c: buttonValue
            }
        };

        let error;

        try {
            await updateRecord(wOffer);
            //await refreshApex(this._wiredSAsIds);
        }
        catch (e) {
            error = e;
        }

        if (error === undefined || error?.errorType === 'networkAdapterError') {
            await LightningAlert.open({
                message: message,
                theme: buttonValue === 'Accept' ? 'success' : 'error',
                label: buttonValue === 'Accept' ? 'Aceptada' : 'Rechazada',
            });

            const pageRef = {  //opcional sin redirección en Web
                "type": "standard__recordPage",
                "attributes": {
                    "recordId": `${this.recordId}`,
                    "actionName": 'view'
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
    
    // #region end new code CAM ++++++++++++++++++++++++++++++++++++++++
}