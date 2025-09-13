import { LightningElement, track} from 'lwc';
import connectApp from '@salesforce/apex/FtbTwitchControllerInitializer.connectApp';
import Toast from 'lightning/toast';

export default class FtbTwitchInitializer extends LightningElement {

  @track isLoading = false;
  @track loadingText = '';
  @track twUsername = '';

  async connectedCallback(){
  }

  async initializeConnection(e) {
    e.preventDefault();
    this.loadingText = 'Connecting to Twitch App...';
    this.isLoading = true;
    try{
      const res = await invokeAppAuthentication();
      if(res === 'ERROR'){
        await sendErorrToast();
        this.isLoading = false;
        return;
      }
      this.loadingText = 'Finding User...';
    }catch(e){
      await sendErorrToast();
      this.isLoading = false;
    }
  }

  handleValueChange(e) {
    this.twUsername = e.target.value;
  }

}
  
  const invokeAppAuthentication = async () => {
    return (await connectApp());
  }

  const sendErorrToast = async () => {
        await Toast.show({
        label: `An Error Occurred During Authentication`,
        variant: 'error',
        mode: 'dismissible'
      })
    }