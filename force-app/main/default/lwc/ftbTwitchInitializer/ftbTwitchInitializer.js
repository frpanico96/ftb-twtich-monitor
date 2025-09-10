import { LightningElement, track} from 'lwc';

export default class FtbTwitchInitializer extends LightningElement {

  @track isLoading;

  connectedCallback(){
    console.log('Hello 1');
    this.isLoading = true;
  }

}