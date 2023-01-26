global class PokemonApi implements Database.Batchable<Integer>, Database.Stateful,Database.AllowsCallouts{
    global Iterable<Integer> start(Database.BatchableContext BC){
        List<Integer> lista = new List<Integer>();
        for(Integer i = 1; i<=898; i++){
          lista.add(i);
        }
        return lista; 
   }

   global void execute(Database.BatchableContext BC, List<Integer> lista){        
        List<Pokemon__c> pokemons = new List<Pokemon__c>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');        
        Map<String, Object> result  = new Map <String,Object>(); 
        for(Integer i : lista ){
            request.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + i);
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200 ){
            	result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> tipos = ((List<Object>)result.get('types'));
				List<Object> stats = ((List<Object>)result.get('stats'));
                List<Object> habilidad = ((List<Object>)result.get('abilities'));
                List<Object> movimiento = ((List<Object>)result.get('moves'));
				Map<String, Object> sprites = ((Map<String, Object>)result.get('sprites'));                        
                Pokemon__c pokemon = new Pokemon__c(Name = ((String)result.get('name')).capitalize(),
													ExtId__c = i, 
													Altura_Api__c = (Integer)result.get('height'), 
													Peso_Api__c = (Integer)result.get('weight'),
                                                    Imagen__c = (String)sprites.get('front_default'));
				//Traigo los tipos del pokemon
                for(Object obj:tipos){
                	Map<String,Object> objMap = (Map<String,Object>)obj;
                    Map<String,Object> type = (Map<String,Object>)objMap.get('type');
                    String tipo = (String)type.get('name');
                    if(pokemon.Tipo__c == null){
                    	pokemon.Tipo__c = (String)type.get('name');
                   }else{
                        pokemon.Tipo__c = pokemon.Tipo__c +';'+(String)type.get('name');           
                   }							                            
                }
                //Traigo los stats del pokemon
                for(Object obj:stats){
                	Map<String,Object> objMap = (Map<String,Object>)obj;
                    Map<String,Object> stat = (Map<String,Object>)objMap.get('stat');
                    String stat1 = (String)stat.get('name');
                    if(stat1 == 'hp'){
                    	pokemon.Vida__c = (Integer)objMap.get('base_stat');
                    }else{
                    	if(stat1 == 'attack'){
                        	pokemon.Ataque__c = (Integer)objMap.get('base_stat');  
                        }else{
                        	if(stat1 == 'defense'){
                            	pokemon.Defensa__c = (Integer)objMap.get('base_stat');
                            }else{
                            	if(stat1 == 'speed'){
                                	pokemon.Velocidad__c = (Integer)objMap.get('base_stat');
                                }
                            }
                        }                            	           
                     }							                            
                  }
                  //Busco el Id de las habilidades del pokemon en el objeto Habilidad__c
                  for(Object obj:habilidad){
                      Map<String,Object> objMap = (Map<String,Object>)obj;
                      Map<String,Object> habi = (Map<String,Object>)objMap.get('ability');
                      String habilidad1 = (String)habi.get('name');
                      if(pokemon.Habilidad__c == null){
                       Habilidad__c hab = ([SELECT Id, Name 
                                           FROM Habilidad__c 
                                           WHERE Name =:habilidad1]);
                       pokemon.Habilidad__c = hab.Id;   
                      }
                  }
                  //Busco el id de los movimientos del pokemon en el objeto Movimiento__c
                  for(Object obj:movimiento){                            
                      Map<String,Object> objMap = (Map<String,Object>)obj;
                      Map<String,Object> movi = (Map<String,Object>)objMap.get('move');
                      String movimiento1 = (String)movi.get('name');                            
                      if(pokemon.Slot1__c == null){
                          Movimiento__c mov = ([SELECT Id, Name 
                                                FROM Movimiento__c 
                                                WHERE Name =:movimiento1]);
                          pokemon.Slot1__c = mov.Id;  
                      }else{
                          if(pokemon.Slot2__c ==null){
                              Movimiento__c mov = ([SELECT Id, Name 
                                            FROM Movimiento__c 
                                            WHERE Name =:movimiento1]);
                              pokemon.Slot2__c = mov.Id;
                          }else{
                              if(pokemon.Slot3__c ==null){
                                  Movimiento__c mov = ([SELECT Id, Name 
                                                        FROM Movimiento__c 
                                                        WHERE Name =:movimiento1]);
                                  pokemon.Slot3__c = mov.Id;
                              }else{                                        
                                  if(pokemon.Slot4__c ==null){
                                      Movimiento__c mov = ([SELECT Id, Name 
                                                            FROM Movimiento__c 
                                                            WHERE Name =:movimiento1]);
                                     pokemon.Slot4__c = mov.Id;
                                 }
                 			 }
                 		}
                 	}
                 }
                 pokemons.add(pokemon);
                 insert pokemons;
              }
         }
    }             
    
   global void finish(Database.BatchableContext BC){
       system.debug('finish');
   }
}