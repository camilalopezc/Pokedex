global class HabilidadApi implements Database.Batchable<Integer>, Database.Stateful,Database.AllowsCallouts{
    global Iterable<Integer> start(Database.BatchableContext BC){
        List<Integer> lista = new List<Integer>();
        for(Integer i = 1; i<=267; i++){
          lista.add(i);
        }
        return lista; 
   }

   global void execute(Database.BatchableContext BC, List<Integer> lista){
        List<Habilidad__c> habilidades = new List<Habilidad__c>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');        
        Map<String, Object> result  = new Map <String,Object>(); 
        for(Integer i : lista ){
            request.setEndpoint('https://pokeapi.co/api/v2/ability/' + i);
                   HttpResponse response = http.send(request);
                    if(response.getStatusCode() == 200 ){
                        result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                        List<Object> effectEntries = ((List<Object>)result.get('effect_entries'));
                        Habilidad__c habilidad = new Habilidad__c (Name = ((String)result.get('name')).capitalize(), 
                                                                   ExtId__c = i);
                        for(Object obj:effectEntries){
                            Map<String,Object> objMap = (Map<String,Object>)obj;
                            Map<String,Object> idioma = (Map<String,Object>)objMap.get('language');
                            String idiomaIngles = (String)idioma.get('name');
                            if(idiomaIngles == 'en'){
                                habilidad.Efecto__c= (String)objMap.get('short_effect');
                            }							                            
                        }
                        habilidades.add(habilidad);
                    }
                }
       	insert habilidades;
    }             
    
   global void finish(Database.BatchableContext BC){
       MovimientoApi move = new MovimientoApi();
	   Id batchJobId = Database.executeBatch(new MovimientoApi(), 1);
   }
}