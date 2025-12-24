import { api, LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

import USER_DISPLAY_NAME from '@salesforce/schema/TwitchUser__c.DisplayName__c';
import USER_DESCRIPTION from '@salesforce/schema/TwitchUser__c.Description__c';
import USER_AVATAR from '@salesforce/schema/TwitchUser__c.LogoUrl__c';
import USER_VIEW_COUNT from '@salesforce/schema/TwitchUser__c.ViewCount__c';
import USER_BROADCASTER_TYPE from '@salesforce/schema/TwitchUser__c.UserType__c';

export default class FtbTwitchUserPageHeader extends LightningElement {

    @api recordId;

    @track streamer = {}
    @track isLoading = true;

    @wire(getRecord, { recordId: '$recordId', fields: [USER_DISPLAY_NAME, USER_DESCRIPTION, USER_AVATAR, USER_VIEW_COUNT, USER_BROADCASTER_TYPE] })
    wiredRecord({ error, data }) {
        if (data) {
            this.streamer = {
                displayName: data.fields.DisplayName__c.value,
                description: data.fields.Description__c.value,
                avatar: data.fields.LogoUrl__c.value,
                viewCount: data.fields.ViewCount__c.value.toString(),
                broadcasterType: data.fields.UserType__c.value
            };
            this.isLoading = false;
        } else if (error) {
            console.error('Error fetching record:', error);
        }
    }

    async connectedCallback() {}
        


}