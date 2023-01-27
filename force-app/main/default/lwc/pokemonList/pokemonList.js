import { LightningElement, wire } from 'lwc';
import getPokemons from '@salesforce/apex/PokemonController.getPokemons';

export default class PokemonList extends LightningElement {
    searchText = '';
    searchGeneration = '';
    searchType1 = '';
    searchType2 = '';
    numberOfPokemons;
    pokemons = [];
    
    //Método para traer pokemons al que le paso los parámetros obtenidos en los combobox e input.
    @wire(getPokemons, {nombre: '$searchText', generacion: '$searchGeneration', tipo1: '$searchType1', tipo2: '$searchType2' })    

    //Contador de pokemons
    pokemonsCounter({error, data}){
        if(data){
            this.pokemons = data;
            this.error = undefined;
        }else if(error){
            this.error = data;
            this.pokemons = undefined;
        }
        this.numberOfPokemons = this.pokemons.length;
    }

    //Trae los pokemons filtrando por la primer letra que se ingresa en el input
    handlerInputChange(event){
        const searchTextAux = event.target.value;
        if(searchTextAux.length >= 1 || searchTextAux == ''){
            this.searchText = searchTextAux; 
        }
    }

    //Setea los valores de las combobox de tipo
   typeOptions = [
            
            { 
                value: 'todos', 
                label: 'Mostrar todos los tipos' 
            },
            { 
                value: 'normal', 
                label: 'Normal' 
            },
            {
                value: 'fighting',
                label: 'Fighting'
            },
            {
                value: 'flying',
                label: 'Flying'
            },
            { 
                value: 'poison', 
                label: 'Poison' 
            },
            {
                value: 'ground',
                label: 'Ground'
            },
            {
                value: 'rock',
                label: 'Rock'
            },
            { 
                value: 'bug', 
                label: 'Bug' 
            },
            {
                value: 'ghost',
                label: 'Ghost'
            },
            {
                value: 'steel',
                label: 'Steel'
            },
            { 
                value: 'fire', 
                label: 'Fire' 
            },
            {
                value: 'water',
                label: 'Water'
            },
            {
                value: 'grass',
                label: 'Grass'
            },
            { 
                value: 'electric', 
                label: 'Electric' 
            },
            {
                value: 'psychic',
                label: 'Psychic'
            },
            {
                value: 'ice',
                label: 'Ice'
            },
            { 
                value: 'dragon', 
                label: 'Dragon' 
            },
            {
                value: 'dark',
                label: 'Dark'
            },
            {
                value: 'fairy',
                label: 'Fairy'
            },
    ];

    //Setea los valores de la combobox de generaciones
    generacionOptions = [
            
        { 
            value: 'todas', 
            label: 'Mostrar todas las generaciones' 
        },
        { 
            value: '1', 
            label: 'Generación 1' 
        },
        {
            value: '2',
            label: 'Generación 2'
        },
        {
            value: '3',
            label: 'Generación 3'
        },
        { 
            value: '4', 
            label: 'Generación 4' 
        },
        {
            value: '5',
            label: 'Generación 5'
        },
        {
            value: '6',
            label: 'Generación 6'
        },
        { 
            value: '7', 
            label: 'Generación 7' 
        },
        {
            value: '8',
            label: 'Generación 8'
        },
    ];
    
    //Los siguientes 3 handle se utilizan para realizar filtros (de forma conjunta o independiente). Todos los valores obtenidos se pasaran respectivamente a la función
    //getPokemons trayendo al/los pokemon/s que se relacionen con los parámetros pasados.
    handleComboboxChange1(event) {
        const searchType = event.target.value;
        if(searchType == 'todos'){
            this.searchType1 = '';
        }else{
            this.searchType1 = searchType; 
        }
                     
    }
    handleComboboxChange2(event) { 
        const searchType = event.target.value;       
        if(searchType == 'todos'){
            this.searchType2 = '';
        }else{
            this.searchType2 = searchType; 
        }              
    }
    handleComboboxChange3(event) {        
        const searchGeneration = event.target.value;
        if(searchGeneration == 'todas'){
            this.searchGeneration = '';
        }else{
            this.searchGeneration = searchGeneration;  
        }              
    }   
    
}