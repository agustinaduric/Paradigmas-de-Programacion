% base de conocimiento

tipo(pikachu, electrico).
tipo(charizard, fuego).
tipo(venusaur, planta).
tipo(blastoise, agua).
tipo(totodile, agua).
tipo(snorlax, normal).
tipo(rayquaza, dragon).
tipo(rayquaza, volador).

entrenador(ash, pikachu).
entrenador(ash, charizard).
entrenador(brock, snorlax).
entrenador(misty, blastoise).
entrenador(misty, venusaur).

movimiento(mordedura, caracteristica(fisico, 95)).
movimiento(impactrueno, caracteristica(especial, 40)).
movimiento(garraDragon, caracteristica(especial, 100)).
movimiento(proteccion, caracteristica(defensivo, 10)).
movimiento(placaje, caracteristica(fisico, 50)).

usa(pikachu, mordedura).
usa(pikachu, impactrueno).
usa(charizard, garraDragon).
usa(charizard, mordedura).
usa(blastoise, proteccion).
usa(blastoise, placaje).

basico(fuego).
basico(agua).
basico(planta).
basico(normal).

% tipoMultiple/1

tipoMultiple(Pokemon) :-
    pokemon(Pokemon),
    tiposDiferentes(Pokemon).

pokemon(Pokemon) :-
    tipo(Pokemon, _).

tiposDiferentes(Pokemon) :-
    tipo(Pokemon, Tipo1),
    tipo(Pokemon, Tipo2),
    Tipo1 \= Tipo2.

% legendario/1

legendario(Pokemon) :-
    pokemon(Pokemon),
    tipoMultiple(Pokemon),
    not(entrena(Pokemon)).

% misterioso/1

misterioso(Pokemon) :-
    pokemon(Pokemon),
    unico(Pokemon),
    not(entrena(Pokemon)).

unico(Pokemon) :-
    tipo(Pokemon, Tipo),
    not((tipo(OtroPokemon, Tipo), OtroPokemon \= Pokemon)).

entrena(Pokemon) :-
    entrenador(_, Pokemon).

% ataque/3 

ataque(Pokemon, Movimiento, Danio) :-
    movimiento(Movimiento, Caracteristicas),
    usa(Pokemon, Movimiento),
    tipo(Pokemon, Tipo),
    ataqueSegun(Tipo, Caracteristicas, Danio).

ataqueSegun(_, caracteristica(fisico, Danio), Danio).

ataqueSegun(_, caracteristica(defensivo, _), 0).

ataqueSegun(Tipo, caracteristica(especial, Potencia), Danio) :-
    basico(Tipo),
    Danio is Potencia * 1.5.

ataqueSegun(dragon, caracteristica(especial, Potencia), Danio) :- 
    Danio is Potencia * 3.

ataqueSegun(Tipo, caracteristica(especial, Danio), Danio) :-
    Tipo \= dragon,
    not(basico(Tipo)).

% ofensa/2

ofensa(Pokemon, Capacidad) :-
    pokemon(Pokemon),
    findall(Danio, (usa(Pokemon, Movimiento), ataque(Pokemon, Movimiento, Danio)), Ataques),
    sum_list(Ataques, Capacidad).

% picante/1

picante(Entrenador) :-
    entrenador(Entrenador),
    forall(entrenador(Entrenador, Pokemon), condicionPicante(Pokemon)).

condicionPicante(Pokemon) :-
   ofensa(Pokemon, Capacidad), 
   Capacidad >=200.

condicionPicante(Pokemon) :-
    misterioso(Pokemon).

entrenador(Entrenador) :-
    entrenador(Entrenador, _).