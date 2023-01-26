import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';


export default class PokemonTile extends NavigationMixin(LightningElement) {
    @api pokemon;
    
    navigateToRecordViewPage() {
        
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.pokemon.Id,
                objectApiName: 'Pokemon__c',
                actionName: 'view'
            }
        });
    }
    
}