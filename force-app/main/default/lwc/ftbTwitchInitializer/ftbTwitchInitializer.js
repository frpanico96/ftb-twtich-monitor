import { LightningElement, track} from 'lwc';
import connectApp from '@salesforce/apex/FtbTwitchControllerInitializer.connectApp';

export default class FtbTwitchInitializer extends LightningElement {

  @track isLoading = false;
  @track twUsername = '';

  async connectedCallback(){
    console.log('@@@ Initializing App Auth...');
    // const authOutcome = await invokeAppAuthentication().catch((error) => console.log(error));
    // console.log('@@@ AuthOutcome >>>', authOutcome);
  }

  async initializeConnection(e) {
    e.preventDefault();
    console.log('@@@ Connecting App...');
    console.log('@@@ Username >>>', this.twUsername);
  }

  handleValueChange(e) {
    this.twUsername = e.target.value;
  }

}
  
  const invokeAppAuthentication = async () => {
    return (await connectApp());
  }