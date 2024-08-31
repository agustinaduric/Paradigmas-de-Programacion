% Base de conocimiento

viaja(dodain, pehuenia).
viaja(dodain, sanMartin).
viaja(dodain, esquel).
viaja(dodain, camarones).
viaja(dodain, sarmiento).
viaja(dodain, playasDoradas).
viaja(alf, bariloche).
viaja(alf, sanMartin).
viaja(alf, elBolson).
viaja(nico, marDelPlata).
viaja(vale, calafate).
viaja(vale, elBolson).

viaja(martu, Lugar) :-
    viaja(nico, Lugar).
viaja(martu, Lugar) :-
    viaja(alf, Lugar).

atraccion(esquel, parqueNacional, caracteristica(losAlerces)).
atraccion(esquel, excursion, caracteristica(trochita)).
atraccion(esquel, excursion, caracteristica(trevelin)).
atraccion(pehuenia, cerro, caracteristica(bateaMahuida, 2000)).
atraccion(pehuenia, cuerpoAgua, caracteristica(moquehue, pesca, 14)).
atraccion(pehuenia, cuerpoAgua, caracteristica(alumine, pesca, 19)).

costoVida(sarmiento, 100).
costoVida(esquel, 150).
costoVida(pehuenia, 180).
costoVida(sanMartin, 150).
costoVida(camarones, 135).
costoVida(playasDoradas, 170).
costoVida(bariloche, 140).
costoVida(calafate, 240).
costoVida(elBolson, 145).
costoVida(marDelPlata, 140).

% vacacionCopada/2

vacacionesCopada(Persona, Destino) :-
    persona(Persona),
    viaja(Persona, Destino),
    atraccionCopada(Destino, _).

persona(Persona) :-
    viaja(Persona, _).

atraccionCopada(Lugar, Atraccion) :-
    atraccion(Lugar, Atraccion, Caracteristicas).
    copadoSegunLugar(Atraccion, Caracteristicas).

copadoSegunLugar(cerro, caracteristica(_, Metros)) :-
    Metros > 2000.

copadoSegunLugar(cuerpoAgua, caracteristica(_, pesca, _)).

copadoSegunLugar(cuerpoAgua, caracteristica(_, _, Temperatura)) :-
    Temperatura > 20.

copadoSegunLugar(playa, caracteristica(Marea1, Marea2)) :-
    Diferencia is Marea1 - Marea2,
    abs(Diferencia, Absolute),
    Absolute < 5.

copadoSegunLugar(excursion, caracteristica(Nombre)) :-
    atom_length(Nombre, Cantidad),
    Cantidad > 7.

copadoSegunLugar(parqueNacional, _).

% niSeCruzaron/2

niSeCruzaron(Persona1, Persona2) :-
    persona(Persona1),
    persona(Persona2),
    Persona1 \= Persona2,
    not(cruzan(Persona1, Persona2)).

cruzan(Persona1, Persona2) :-
    viaja(Persona1, Lugar),
    viaja(Persona2, Lugar).

%  vacacionesGasoleras/2 

vacacionesGasoleras(Persona, Destino) :-
    persona(Persona),
    forall(viaja(Persona, Destino), gasolero(Destino)).

gasolero(Destino) :-
    costoVida(Destino, Costo),
    Costo < 160.

% itinerario/2

itinerario(Persona, Lugares) :-
    persona(Persona),
    findall(Lugar, viaja(Persona, Lugar), Lugares).

/*
Alternativa con lista permutada:
itinerario(Persona, LugaresPermutados) :-
    persona(Persona),
    findall(Lugar, viaja(Persona, Lugar), Lugares),
    permutation(Lugares, LugaresPermutados).
*/