@isTest
private class PokemonControllerTest {
    @testSetup
    static void setup() {
        Pokemon__c pokemon1 = new Pokemon__c(Name='Bulbasaur', ExtId__c=1, Tipo__c='Poison;Grass');
        insert pokemon1;
        Pokemon__c pokemon2 = new Pokemon__c(Name='Salamence', ExtId__c=373, Tipo__c='Flying;Dragon');
        insert pokemon2;
        Pokemon__c pokemon3 = new Pokemon__c(Name='Azelf', ExtId__c=482, Tipo__c='Psychic');
        insert pokemon3;
        Pokemon__c pokemon4 = new Pokemon__c(Name='Pikachu', ExtId__c=25, Tipo__c='Electric');
        insert pokemon4;
        Pokemon__c pokemon5 = new Pokemon__c(Name='Calyrex', ExtId__c=898, Tipo__c='Grass;Psychic');
        insert pokemon5;
       
        }
    @istest
    static void queryVacia(){
        List<Pokemon__c> pokemons = new List<Pokemon__c>();
        
        Test.startTest();
        pokemons = PokemonController.getPokemons('','','','');
        Test.stopTest();
        
        system.assertEquals(pokemons.size(),5);
    }
    @istest
    static void queryConParametros(){
        List<Pokemon__c> pokemons = new List<Pokemon__c>();
        
        Test.startTest();
        pokemons = PokemonController.getPokemons('a','3','Flying','Dragon');
        Test.stopTest();
        
        system.assertEquals(pokemons.size(),1);        
    }
    @istest
    static void queryConUnTipo(){
        List<Pokemon__c> pokemons = new List<Pokemon__c>();
        
        Test.startTest();
        pokemons = PokemonController.getPokemons('','','','Electric');
        Test.stopTest();
        
        system.assertEquals(pokemons.size(),1);
    }
    @istest
    static void queryConDosParametros(){
        List<Pokemon__c> pokemons = new List<Pokemon__c>();
        
        Test.startTest();
        pokemons = PokemonController.getPokemons('','4','Psychic','');
        Test.stopTest();
        
        system.assertEquals(pokemons.size(),1);
    }
    @istest
    static void queryConGeneracion(){
        List<Pokemon__c> pokemons = new List<Pokemon__c>();
        
        Test.startTest();
        pokemons = PokemonController.getPokemons('','8','','');
        Test.stopTest();
        
        system.assertEquals(pokemons.size(),1);
    }
    @istest
    static void queryConTipos(){
        List<Pokemon__c> pokemons = new List<Pokemon__c>();
        
        Test.startTest();
        pokemons = PokemonController.getPokemons('','','Grass','Poison');
        Test.stopTest();         
        
        system.assertEquals(pokemons.size(),1);
    }
}