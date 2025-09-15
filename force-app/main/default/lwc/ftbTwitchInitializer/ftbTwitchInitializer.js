import { LightningElement, track} from 'lwc';
import Toast from 'lightning/toast';
import connectApp from '@salesforce/apex/FtbTwitchControllerInitializer.connectApp';
import getTwitchUser from '@salesforce/apex/FtbTwitchControllerInitializer.getTwitchUser';

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
      const appConnRes = await invokeAppAuthentication();
      if(appConnRes === 'ERROR'){
        await sendErorrToast();
        this.isLoading = false;
        return;
      }
      this.loadingText = 'Finding User...';
      const userRes = await invokeGetTwitchUser(this.twUsername);
      if(userRes === 'ERROR'){
        await sendErorrToast();
        this.isLoading = false;
        return;
      }
      this.loadingText = 'Starting Twitch Authorization...';
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

  const invokeGetTwitchUser = async (user) => {
    return (await getTwitchUser({user}));
  }

  const sendErorrToast = async () => {
        await Toast.show({
        label: `An Error Occurred During The Operation`,
        message: 'Please try again! If the problem persists, contact your administrator.', 
        variant: 'error',
        mode: 'dismissible'
      })
    }