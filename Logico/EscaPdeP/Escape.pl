% Base de conocimiento

% persona(Apodo, Edad, Peculiaridades).
persona(rolo, 12, []).
persona(ale, 15, [claustrofobia, cuentasRapidas, amorPorLosPerros]).
persona(agus, 25, [lecturaVeloz, ojoObservador, minuciosidad]).
persona(fran, 30, [fanDeLosComics]).

% esSalaDe(NombreSala, Empresa).
esSalaDe(elPayasoExorcista, salSiPuedes).
esSalaDe(socorro, salSiPuedes).
esSalaDe(guerrasEstelares, escapepepe).
esSalaDe(fundacionDelMulo, escapepepe).
esSalaDe(linternas, elLaberintoso).
esSalaDe(estrellasDePelea, supercelula).
esSalaDe(miseriaDeLaNoche, sKPista).

% sala(Nombre, Experiencia).
% terrorifica(CantidadDeSustos, EdadMinima).
% familiar(Tematica, CantidadDeHabitaciones).
% enigmatica(Candados).
sala(fundacionDelMulo, enigmatica([combinacionAlfanumerica, deLlave, deBoton])).
sala(linternas, familiar(comics, 5)).
sala(guerrasEstelares, familiar(futurista, 7)).
sala(estrellasDePelea, familiar(videojuegos, 7)).
sala(elPayasoExorcista, terrorifica(100, 18)).
sala(socorro, terrorifica(20, 12)).
sala(miseriaDeLaNoche, terrorifica(150, 22)).

% PUNTO 1 %
% nivelDeDificultadDeLaSala/2

nivelDeDificultadDeLaSala(Sala, Dificultad) :-
    sala(Sala, Categoria),
    dificultadTematica(Categoria, Dificultad).

dificultadTematica(terrorifica(Sustos, Edad), Dificultad) :-
    Dificultad is Sustos - Edad.

dificultadTematica(familiar(futurista, _), 15).

dificultadTematica(familiar(Tematica, Dificultad), Dificultad) :-
    Tematica \= futurista.

dificultadTematica(enigmatica(Candados), Dificultad) :-
    length(Candados, Dificultad).

% PUNTO 2 % 
% PuedeSalir/2

puedeSalir(Sala, Persona) :-
    persona(Persona),
    sala(Sala),
    not(es(Persona, claustrofobia)),
    nivelDeDificultadDeLaSala(Sala, 1).

puedeSalir(Sala, Persona) :-
    persona(Persona),
    not(es(Persona, claustrofobia)),
    mayorA(Persona, 13), 
    nivelDeDificultadDeLaSala(Sala, Dificultad),
    Dificultad < 5.

es(Persona, Caracteristica) :-
    persona(Persona, _ , Peculiaridades),
    member(Caracteristica, Peculiaridades).

mayorA(Persona, EdadMinima) :-
    persona(Persona, Edad, _),
    Edad > EdadMinima.

persona(Persona) :-
    persona(Persona, _, _).

sala(Sala) :-
    sala(Sala, _).

% PUNTO 3 %
% tieneSuerte/2

tieneSuerte(Sala, Persona) :-
    persona(Persona, _, []),
    sala(Sala),
    puedeSalir(Sala, Persona).

% PUNTO 4 %
% esMacabra/1

esMacabra(Empresa) :-
    empresa(Empresa),
    forall(esSalaDe(Sala, Empresa), sala(Sala, terrorifica(_, _))).

empresa(Empresa) :-
    esSalaDe(_, Empresa).

% PUNTO 5 %
% empresaCopada/1

empresaCopada(Empresa) :-
    empresa(Empresa),
    not(esMacabra(Empresa)),
    dificultadTotal(Empresa, Dificultad),
    Dificultad < 10.

dificultadTotal(Empresa, NivelDeDificultad) :-
    empresa(Empresa),
    findall(Dificultad, (esSalaDe(Sala, Empresa), nivelDeDificultadDeLaSala(Sala, Dificultad)), Dificultades),
    sum_list(Dificultades, NivelDeDificultad).