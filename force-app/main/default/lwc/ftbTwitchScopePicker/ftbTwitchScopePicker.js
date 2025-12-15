import { LightningElement, track } from 'lwc';
import getTwitchScopeForBoxList from '@salesforce/apex/FtbTwitchScopePickerController.getTwitchScopeForBoxList';

export default class FtbTwitchScopePicker extends LightningElement {

    @track isLoading = true;
    @track selectedScopes = [];
    @track selectedScope = {
      label: 'No Scope Selected',
      description: '',
    }
    @track scopes = [];
    @track scopeMap = {};
    @track minScopes = 1;
    
    async connectedCallback(){
        try{
            const scopesString = await getTwitchScopeForBoxList()
            const scopes = JSON.parse(scopesString);
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

}