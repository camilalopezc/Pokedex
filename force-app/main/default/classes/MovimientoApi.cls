global class MovimientoApi implements Database.Batchable<Integer>, Database.Stateful,Database.AllowsCallouts{
    global Iterable<Integer> start(Database.BatchableContext BC){
        List<Integer> lista = new List<Integer>();
        for(Integer i = 1; i<=826; i++){
          lista.add(i);
        }
        return lista; 
   }

   global void execute(Database.BatchableContext BC, List<Integer> lista){
        List<Movimiento__c> movimientos = new List<Movimiento__c>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');        
        Map<String, Object> result  = new Map <String,Object>(); 
        for(Integer i : lista ){
            request.setEndpoint('https://pokeapi.co/api/v2/move/' + i);
                   HttpResponse response = http.send(request);
                    if(response.getStatusCode() == 200 ){
                        result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                        List<Object> effectEntries = ((List<Object>)result.get('effect_entries')); 
                        Movimiento__c movimiento = new Movimiento__c (Name = ((String)result.get('name')).capitalize(), 
                                                                      ExtId__c = i,
                                                                      Punteria__c = (Integer)result.get('accuracy'),
                                                                      Pp__c = (Integer)result.get('pp'),
                                                                      Prioridad__c = (Integer)result.get('priority'),
                                                                      Poder__c = (Integer)result.get('power'),
                                                                      Chance_de_Efecto__c = (Integer)result.get('effect_chance'),
                                                                      Objetivo__c = (String)((Map<String, Object>)result.get('target')).get('name'),
                                                                      Tipo__c = (String)((Map<String, Object>)result.get('type')).get('name'));
                       for(Object obj:effectEntries){
                            Map<String,Object> objMap = (Map<String,Object>)obj;
                            movimiento.Efecto__c = (String)objMap.get('short_effect');
                        }
                        movimientos.add(movimiento);
                    }
                }
       insert movimientos;
    }             
    
   global void finish(Database.BatchableContext BC){
       PokemonApi poke = new PokemonApi();
	   Id batchJobId = Database.executeBatch(new PokemonApi(), 1);
   }
}