% Base de conocimiento %

% comida(comida, precio).
comida(hamburguesa, 2000).
comida(panchito, 1500).
comida(lomito, 2500).
comida(caramelo, 0).

% atraccion(tipo, caracteristicas(atraccion, apto)).
atraccion(tranquila, caracteristicas(autitosChocadores, chicosYAdultos)).
atraccion(tranquila, caracteristicas(casaEmbrujada, chicosYAdultos)).
atraccion(tranquila, caracteristicas(laberinto, chicosYAdultos)).
atraccion(tranquila, caracteristicas(tobogan, chicos)).
atraccion(tranquila, caracteristicas(calesita, chicos)).

% atraccion(tipo, caracteristicas(atraccion, coeficiente).
atraccion(intensa, caracteristicas(barcoPirata, 14)).
atraccion(intensa, caracteristicas(tazasChinas, 6)).
atraccion(intensa, caracteristicas(simulador, 2)).

% atraccion(tipo, caracteristicas(nombre, giros, duracion)).
atraccion(montaniaRusa, caracteristicas(abismoMortalRecargada, 3, 134)).
atraccion(montaniaRusa, caracteristicas(paseoPorElBodque, 0, 45)).

% atraccion(tipo, nombre).
atraccion(acuatica, caracteristicas(torpedoSalpicon)).
atraccion(acuatica, caracteristicas(esperoQueHayasTraidoUnaMudaDeRopa)).

% visitante(nombre, detalles(edad, plata), hambre, aburrimiento).
visitante(eusebio, detalles(80, 3000), 50, 0 ).
visitante(carmela, detalles(80, 0), 0, 25).
visitante(tomas, detalles(28, 500), 0, 0).
visitante(morena, detalles(36, 1000), 40, 30).

% grupo(nombre, grupo).
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
    forall(comida(Comida), not((puedePagar(Visitante, Comida), Comida \= caramelo))).

satisfaceSegun(_, _, lomito).

satisfaceSegun(_, Hambre, hamburguesa) :-
    Hambre =< 50.

satisfaceSegun(detalles(Edad, _), _, panchito) :-
    Edad < 18.

% Punto 4 % 

lluviaDeHamburguesas(Visitante, Atraccion) :-
    puedePagar(Visitante, hamburguesa),
    atraccionHamburguesa(Visitante, Atraccion).

atraccionHamburguesa(_, Atraccion) :-
    atraccion(intensa, caracteristicas(Atraccion, Lanzamiento)),
    Lanzamiento > 10.

atraccionHamburguesa(_, tobogan).

atraccionHamburguesa(Visitante, Atraccion) :-
    visitante(Visitante, detalles(Edad, _), _, _),
    montaniaPeligrosa(Visitante, Edad, Atraccion).

montaniaPeligrosa(_, Edad, Atraccion) :-
    Edad > 18,
    atraccion(montaniaRusa, caracteristicas(Atraccion, Giros, _)),
    not((atraccion(montaniaRusa, caracteristicas(OtraAtraccion, OtrosGiros, _)), OtraAtraccion \= Atraccion, OtrosGiros > Giros)).

montaniaPeligrosa(Visitante, Edad, _) :-
    Edad > 18,
    not(bienestar(Visitante, necesitaEntretenerse)).

montaniaPeligrosa(_, Edad, Atraccion) :-
    Edad =< 18, 
    atraccion(montaniaRusa, caracteristicas(Atraccion, _, Duracion)),
    Duracion >= 60.

% TODO: Fix repetición de lógica en Edad =< 18 y Edad > 18.
% TODO: Fix repetición de lógica en manejo Montaña rusa Punto 4.
% TODO: Punto 5.