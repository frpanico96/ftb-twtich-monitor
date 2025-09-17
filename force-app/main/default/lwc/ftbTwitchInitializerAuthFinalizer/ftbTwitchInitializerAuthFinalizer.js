import { LightningElement, wire, api } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';

export default class FtbTwitchInitializerAuthFinalizer extends NavigationMixin(LightningElement) {

  @api code;

  @wire(CurrentPageReference)
  getStateParams(currentPageReference){
    console.log('@@@Reading reference')
    if(currentPageReference){
      this.code = currentPageReference.state.c__code;
      if(this.code){
        const pageRef = {
          type: 'standard__namedPage',
          attributes: {
            pageName: 'home',
          },
          state: {
            c__code: this.code
          }
        }
        setTimeout(() => {
          this[NavigationMixin.Navigate](pageRef);
        }, 1500)
      }
    }
  }

  connectedCallback(){
  }


}