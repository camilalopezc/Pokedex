@isTest
public class PokemonApiTest {
    @testSetup 
    static void habilidadData() {
        List<Habilidad__c> habi = new List<Habilidad__c>();
        Habilidad__c habi1 = new Habilidad__c( Name ='overgrow');
        Habilidad__c habi2 = new Habilidad__c( Name ='chlorophyll');
        habi.add(habi1);
        habi.add(habi2);
        insert habi;
        
        List<Movimiento__c> movi = new List<Movimiento__c>();
        Movimiento__c movi1 = new Movimiento__c(Name = 'razor-wind');
        Movimiento__c movi2 = new Movimiento__c(Name = 'swords-dance');
        Movimiento__c movi3 = new Movimiento__c(Name = 'cut');
        Movimiento__c movi4 = new Movimiento__c(Name = 'bind');
        movi.add(movi1);
        movi.add(movi2);
        movi.add(movi3);
        movi.add(movi4);
        insert movi;
	}
    
    @isTest
    public static void deberiaDevolverPokemos(){      
      
        SingleRequestMock fakePokemonResponse1 = new SingleRequestMock(200,
                                                                     'Complete',                                                                     
                                                                     '{"name": "bulbasaur","height": 7,"weight": 69,"sprites" : {"front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"},"types": [{"type": {"name": "grass"}},{"type": {"name": "poison"}}],"stats": [{"base_stat": 45, "stat": {"name": "hp"}},{"base_stat": 49,"stat": {"name": "attack"}},{"base_stat": 49,"stat": {"name": "defense"}},{"base_stat": 45,"stat": {"name": "speed"}}],"abilities": [{"ability": {"name": "overgrow"}},{"ability": {"name": "chlorophyll"}}],"moves": [{"move": {"name": "razor-wind"}},{"move": {"name": "swords-dance"}},{"move": {"name": "cut"}},{"move": {"name": "bind"}}]}',
                                                                     null);
		Test.setMock(HttpCalloutMock.class, fakePokemonResponse1);      
        
        Test.startTest();
        PokemonApi poke = new PokemonApi();
        Id batchId = Database.executeBatch(poke,1);
        Test.stopTest();
        
        List<Pokemon__c> pokeList = [SELECT Name FROM Pokemon__c];
        system.assertEquals(pokeList.size(),1);
        
    }
    
    @isTest
    public static void noDeberiaDevolverPokemos(){
        String error;
        SingleRequestMock fakeResponse = new SingleRequestMock(500,
                                                             'Error',
                                                             'Error',
                                                             null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        Test.startTest();
        try{
        	PokemonApi poke = new PokemonApi();
        	Id batchId = Database.executeBatch(poke,1);
        }catch(Exception ex){
            error = ex.getMessage();
        }
        Test.stopTest();
        
        system.assertEquals(null, error,'el error no es el esperado, es: ' + error);        
    }

}