@isTest
public class HabilidadApiTest {
    
    @isTest
    public static void deberiaDevolverHabilidad(){
        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                             'Complete',
                                                             '{"name": "battle-armor","effect_entries": [{"language": {"name": "en"},"short_effect": "Protects against critical hits."}]}',
                                                             null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Test.startTest();
        HabilidadApi habi = new HabilidadApi();
        Id batchId = Database.executeBatch(habi,1);
        Test.stopTest();
        
        Habilidad__c habil = [SELECT Id, Name, ExtId__c, Efecto__c 
                              FROM Habilidad__c 
                              LIMIT 1];
        
        System.assertEquals('Battle-armor', habil.Name );
        System.assertEquals(1, habil.ExtId__c);    
                
    }
    
    @isTest
    public static void noDeberiaDevolverHabilidad(){
        String error;
        SingleRequestMock fakeResponse = new SingleRequestMock(500,
                                                             'Error',
                                                             'Error',
                                                             null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        Test.startTest();
        try{
        	HabilidadApi habi = new HabilidadApi();
        	Id batchId = Database.executeBatch(habi,1);
        }catch(Exception ex){
            error = ex.getMessage();
        }
        Test.stopTest();
        
        system.assertEquals(null, error,'el error no es el esperado, es: ' + error);
        
    }

}