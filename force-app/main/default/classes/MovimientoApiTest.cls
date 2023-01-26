@isTest
public class MovimientoApiTest {
    
    @isTest
    public static void deberiaDevolverMovimiento(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                             'Complete',
                                                             '{"name": "pound","accuracy": 100,"effect_chance": null,"effect_entries": [{"short_effect": "Inflicts regular damage with no additional effect."}],"power": 40,"pp": 35,"priority": 0,"target":{"name": "selected-pokemon"},"type": {"name": "normal"}}',
                                                             null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Test.startTest();
        MovimientoApi movi = new MovimientoApi();
        Id batchId = Database.executeBatch(movi,1);
        Test.stopTest();
        
        Movimiento__c movim = [SELECT Name, ExtId__c 
                               FROM Movimiento__c 
                               WHERE Name = 'Pound'];
        System.assertEquals('Pound',movim.Name);
        system.assertEquals(1,movim.ExtId__c);
        
    }
    
    @isTest
    public static void noDeberiaDevolverMovimiento(){
        String error;
        SingleRequestMock fakeResponse = new SingleRequestMock(500,
                                                             'Error',
                                                             'Error',
                                                             null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        Test.startTest();
        try{
        	MovimientoApi movi = new MovimientoApi();
        	Id batchId = Database.executeBatch(movi,1);
        }catch(Exception ex){
            error = ex.getMessage();
        }
        Test.stopTest();
        
        system.assertEquals(  null, error,'el error no es el esperado, es: ' + error);
        
    }

}