import { LightningElement, track, wire} from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import Toast from 'lightning/toast';
import connectApp from '@salesforce/apex/FtbTwitchControllerInitializer.connectApp';
import getTwitchUser from '@salesforce/apex/FtbTwitchControllerInitializer.getTwitchUser';
import getTwitchLoginUrl from '@salesforce/apex/FtbTwitchControllerInitializer.getTwitchLoginUrl';
import upsertAdditionalScopes from '@salesforce/apex/FtbTwitchControllerInitializer.upsertAdditionalScopes';
import connectUser from '@salesforce/apex/FtbTwitchControllerInitializer.connectUser';

import FtbTwitchScopePicker from 'c/ftbTwitchScopePicker';

export default class FtbTwitchInitializer extends NavigationMixin(LightningElement) {

  @track isLoading = false;
  @track loadingText = '';
  @track twUsername = '';

  async connectedCallback(){
  }

  @wire(CurrentPageReference)
  async getStateParams(currentPageReference){
    console.log('@@@Reading reference')
    if(currentPageReference){
      console.log(currentPageReference.state.c__code);
      const code = currentPageReference.state.c__code;
      if(code){
        this.loadingText = 'Finalizing Authentication...';
        this.isLoading = true;
        const twitchUserId = await connectUser({code});
        if(!twitchUserId || twitchUserId === 'ERROR'){
          await sendErorrToast();
          this.isLoading = false;
          return;
        }
        this.isLoading = false;
        console.log(twitchUserId);
        this.navigateToRecord(twitchUserId);
      }
    }
  }

  async initializeConnection(e) {
    e.preventDefault();
    this.loadingText = 'Connecting to Twitch App...';
    this.isLoading = true;

    
    
    try{
      const appConnRes = await invokeAppAuthentication();
      console.log('@@@ App Connection Result', appConnRes);
      if(appConnRes === 'ERROR'){
        await sendErorrToast();
        this.isLoading = false;
        return;
      }
      this.loadingText = 'Finding User...';
      const userRes = await invokeGetTwitchUser(this.twUsername);
      console.log('@@@ UserRes', userRes);
      if(userRes === 'ERROR'){
        await sendErorrToast();
        this.isLoading = false;
        return;
      }
      if(userRes !== 'SUCCESS'){
        this.navigateToRecord(userRes);
        return;
      }
      const result = await FtbTwitchScopePicker.open({
        size: 'large',
        header: 'Select Twitch Permissions'
      });
      if(!result?.scopes) {
        console.log('@@@ No scopes selected, aborting process');
        this.isLoading = false;
        return;
      }  
      const additionalScopes = (result?.scopes).join(' ');
      console.log('@@@ Selected Scopes', additionalScopes);
      this.loadingText = 'Starting Twitch Authorization...';
      const loginUrl = await getTwitchLoginUrl({additionalScopes});
      if(!loginUrl){
        await sendErorrToast();
        this.isLoading = false;
        return;
      }
      await upsertAdditionalScopes({additionalScopes});
      window.open(loginUrl, '_self');
    }catch(e){
      console.log(e);
      console.log(e.message);
      console.log(JSON.stringify(e));
      await sendErorrToast();
      this.isLoading = false;
    }
  }

  handleValueChange(e) {
    this.twUsername = e.target.value;
  }
  
  navigateToRecord(recordId) {
    console.log('@@@ Navigating to record', recordId);
    const pageRef = {
        type: 'standard__recordPage',
        attributes: {
          recordId: recordId,
          actionName: 'view',
        }
      }
    this[NavigationMixin.Navigate](pageRef);
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