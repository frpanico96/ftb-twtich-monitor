import { api, LightningElement } from 'lwc';

export default class FtbUtilitySpinner extends LightningElement {

  @api loadingText = 'Loading...';
  @api isLoading = false;

}