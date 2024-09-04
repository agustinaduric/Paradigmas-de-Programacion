% Base de conocimiento %
comida(hamburguesa, 2000).
comida(panchito, 1500).
comida(lomito, 2500).
comida(caramelo, 0).

% atraccion(tipo, atraccion, apto)
atraccion(tranquila, caracteristicas(autitosChocadores, chicosYAdultos)).
atraccion(tranquila, caracteristicas(casaEmbrujada, chicosYAdultos)).
atraccion(tranquila, caracteristicas(laberinto, chicosYAdultos)).
atraccion(tranquila, caracteristicas(tobogan, chicos)).
atraccion(tranquila, caracteristicas(calesita, chicos)).

% tipo atraccion coeficiente
atraccion(intensa, caracteristicas(barcoPirata, 14)).
atraccion(intensa, caracteristicas(tazasChinas, 6)).
atraccion(intensa, caracteristicas(simulador, 2)).

% tipo nombre giros duracion
atraccion(montaniaRusa, caracteristicas(abismoMortalRecargada, 3, 134)).
atraccion(montaniaRusa, caracteristicas(paseoPorElBodque, 0, 45)).

% tipo nombre
atraccion(acuatica, caracteristicas(torpedoSalpicon)).
atraccion(acuatica, caracteristicas(esperoQueHayasTraidoUnaMudaDeRopa)).

% nombre edad plata hambre aburrimiento
visitante(eusebio, detalles(80, 3000), 50, 0 ).
visitante(carmela, detalles(80, 0), 0, 25).
visitante(tomas, detalles(28, 500), 0, 0).
visitante(morena, detalles(36, 1000), 40, 30).

% nombre grupo
grupo(eusebio, viejitos).
grupo(carmela, viejitos).

% Punto 2 %

bienestar(Visitante, Estado) :-
    visitante(Visitante, _, Hambre, Felicidad),
    bienestarSegun(Visitante, Hambre, Felicidad, Estado).

bienestarSegun(Visitante, 0, 0, felicidadPlena) :-
    visitante(Visitante),
    grupo(Visitante, _).

bienestarSegun(_, Hambre, Aburrimiento, podriaEstarMejor) :-
    sentimientosEntre(Hambre, Aburrimiento, 0, 50).

bienestarSegun(Visitante, 0, 0, podriaEstarMejor) :-
    visitante(Visitante),
    not(grupo(Visitante, _)).

bienestarSegun(_, Hambre, Aburrimiento, necesitaEntretenerse) :-
    sentimientosEntre(Hambre, Aburrimiento, 51, 99).

bienestarSegun(_, Hambre, Aburrimiento, seQuiereIr) :-
    sentimientosEntre(Hambre, Aburrimiento, 100, 1000).
    
visitante(Visitante) :-
    visitante(Visitante, _, _, _).

sentimientosEntre(Hambre, Aburrimiento, Minimo, Maximo) :-
    Suma is Hambre + Aburrimiento,
    between(Minimo, Maximo, Suma).

% Punto 3 %

satisfecho(Grupo, Comida) :-
    grupo(Grupo),
    comida(Comida),
    forall(grupo(Visitante, Grupo), (puedePagar(Visitante, Comida), sacaHambre(Visitante, Comida))).

grupo(Grupo) :-
    grupo(_, Grupo).

comida(Comida) :-
    comida(Comida, _).

puedePagar(Visitante, Comida) :-
    visitante(Visitante, detalles(_, Plata), _, _),
    comida(Comida, Precio),
    Plata >= Precio.

sacaHambre(Visitante, Comida) :-
    visitante(Visitante, Detalles, Hambre, _),
    satisfaceSegun(Detalles, Hambre, Comida).

sacaHambre(Visitante, caramelo) :-
    visitante(Visitante),
    not(puedePagar(Visitante, _)).

satisfaceSegun(_, _, lomito).
satisfaceSegun(_, Hambre, hamburguesa) :-
    Hambre =< 50.
satisfaceSegun(detalles(Edad, _), _, panchito) :-
    Edad < 18.