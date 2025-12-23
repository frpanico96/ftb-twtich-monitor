import { api, track } from 'lwc';
import getTwitchScopeForBoxList from '@salesforce/apex/FtbTwitchScopePickerController.getTwitchScopeForBoxList';

import LightningModal from 'lightning/modal';

export default class FtbTwitchScopePicker extends LightningModal {

    @track isLoading = true;
    @track selectedScopes = [];
    @track selectedScope = {
      label: 'No Scope Selected',
      description: '',
    }
    @track scopes = [];
    @track scopeMap = {};
    @track minScopes = 1;

    @api header = 'Fallback Header';

    async connectedCallback(){
        try{
            const scopes = await getTwitchScopeForBoxList();
            console.log(scopes);
            this.scopeMap = {...scopes['organizedScopes']};
            const suggestedScopes = scopes['suggestedScopes'];
            const options = scopes['boxListScopes'];
            this.scopes.push(...options)
            this.selectedScopes.push(...suggestedScopes);
            this.isLoading = false;
        }catch(e){
            this.isLoading = false;
            console.log('@@@ Error', e);
        }
    }


    handleClick(e){
        e.preventDefault();
        // console.log('@@@ Click event current target', JSON.stringify(e?.currentTarget?.value))
        this.populateDescription(e?.currentTarget?.value);
        return;
    }

    handleChange(e){
        // console.log('@@@ Click Event', JSON.stringify(e?.target?.value));
        return;
    }

    populateDescription(value){
      if(!value || !value?.length){
        return;
      }
      const currentScope = this.scopeMap[value[value.length - 1]];
      if(!currentScope){
        return;
      }
      this.selectedScope = {
        label: currentScope['label'],
        description: currentScope['description'],
      }
    }

    handleConfirm(){
      this.close({scopes: this.selectedScopes});
    }

}