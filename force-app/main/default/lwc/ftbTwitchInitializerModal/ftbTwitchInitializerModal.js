import LightningModal from 'lightning/modal';
import { api, track } from 'lwc';

export default class FtbTwitchInitializerModal extends LightningModal {
  
  @api twitchUrl;

  @track closeBtnDisabled = true;

  handleClose(e){
    e.preventDefault();
    this.close('SUCCESS');
  }

  enableBtn(){
    this.closeBtnDisabled = false;
  }

}