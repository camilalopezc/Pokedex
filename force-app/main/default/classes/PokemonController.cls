public with sharing class PokemonController {
    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> getPokemons(String nombre, 
                                               String generacion, 
                                               String tipo1, 
                                               String tipo2) {
        String name = '%'+nombre+'%';
        String query = 'SELECT Generacion__c, Imagen__c, Name, ExtId__c, Tipo__c FROM Pokemon__c WHERE ';
        String condicion ='';

        if (String.isNotBlank(nombre)){
            condicion = 'Name LIKE :name';
        }
        if (String.isNotBlank(generacion)) {
            if (String.isNotBlank(condicion)){
                condicion +=' AND Generacion__c = ' + generacion +'';
            } else {
                condicion +=' Generacion__c = ' + generacion +'';
            }
        }
        if (String.isNotBlank(tipo1)) {
            if(String.isNotBlank(condicion)) {
                condicion += ' AND Tipo__c INCLUDES (\'' +tipo1 +'\')';
            } else {
                condicion += ' Tipo__c INCLUDES (\'' +tipo1 +'\')';
            }
        }
        if (String.isNotBlank(tipo2)) {
            if(String.isNotBlank(condicion)) {
                condicion += ' AND Tipo__c INCLUDES (\'' +tipo2 +'\')';
            } else {
                condicion += ' Tipo__c INCLUDES (\'' +tipo2 +'\')';
            }
        }
        if (String.isNotBlank(condicion)) {
            query = query + condicion + ' ORDER BY ExtId__c';     

            List<Pokemon__c> pokemons = Database.query(query); 
            
            return pokemons;
        } else {
            return[
                SELECT Generacion__c, Imagen__c, Name, ExtId__c, Tipo__c 
                FROM Pokemon__c
                ORDER BY ExtId__c
            ];
        }  
    }
}