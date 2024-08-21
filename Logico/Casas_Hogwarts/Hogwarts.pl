% Base de conocimiento %

% PARTE 1 %

% mago/3

mago(harry, mestiza, [amistad, coraje, inteligencia, orgullo]).
mago(draco, pura, [inteligencia, orgullo]).
mago(hermione, impura, [inteligencia, orgullo, responsabilidad]). % agg: amistad para probar punto 4 - parte 1

% odia/2

odia(harry, slytherin).
odia(draco, hufflepuff).

% apropiado/2

apropiado(gryffindor, coraje).
apropiado(slytherin, orgullo).
apropiado(slytherin, inteligencia).
apropiado(ravenclaw, inteligencia).
apropiado(ravenclaw, responsiblidad).
apropiado(hufflepuff, amistad).

% Parte 2 %

% accion/3

accion(mala, andarDeNoche, -50).
accion(mala, irAlBosque, -50).
accion(mala, irABilblioteca, -10).
accion(mala, piso3, -75).
accion(buena, usarIntelecto, 50).
accion(buena, ganarAVoldemort, 60).
accion(mala, ganarAjedrez, 50).
pregunta(buena, respuestaA(dondeEstaBezoar, snape), 20). % punto 4, parte 2
pregunta(buena, respuestaA(comoLevitarPluma, flitwick), 25). % punto 4, parte 2 

% hizo/2

hizo(harry, andarDeNoche).
hizo(harry, irAlBosque).
hizo(harry, irABilblioteca).
hizo(harry, ganarAVoldemort).
hizo(ron, ganarAjedrez).
hizo(hermione, piso3).
hizo(hermione, irABilblioteca).
hizo(hermione, usarIntelecto).
hizo(hermione, respuestaA(dondeEstaBezoar, snape)). % punto 4, parte 2
hizo(hermione, respuestaA(comoLevitarPluma, flitwick)). % punto 4, parte 2

% esDe/2

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% Resolución PARTE 1 %

% Punto 1 %

% puedeEntrar/2 %

puedeEntrar(Mago, slytherin) :-
    mago(Mago),
    not(mago(Mago, impura, _)).

puedeEntrar(Mago, Casa) :-
    mago(Mago),
    casa(Casa),
    Casa \= slytherin.

casa(Casa) :-
    apropiado(Casa, _).

% Punto 2 %

% caracterApropiado/2

caracterApropiado(Mago, Casa) :-
    casa(Casa),
    mago(Mago, _, Caracteristicas),
    forall(apropiado(Casa, Caracteristica), member(Caracteristica, Caracteristicas)).

% Punto 3 %

% quedaSeleccionado/2

quedaSeleccionado(Mago, Casa) :-
    caracterApropiado(Mago, Casa),
    puedeEntrar(Mago, Casa),
    not(odia(Mago, Casa)).

quedaSeleccionado(hermione, gryffindor).

% Punto 4 %

cadenaDeAmistades(Magos) :-
    todosAmistosos(Magos),
    cadenaDeCasas(Magos).

todosAmistosos(Magos) :-
    forall(member(Mago, Magos), amistoso(Mago)).

amistoso(Mago) :-
    mago(Mago, _, Caracteristicas),
    member(amistad, Caracteristicas).

cadenaDeCasas(Magos) :-
    forall(cadenaDeMagos(Mago1, Mago2, Magos), compartenCasa(Mago1, Mago2)).

cadenaDeMagos(Mago1, Mago2, Magos) :-
    nth1(IndiceMago1, Magos, Mago1),
    nth1(IndiceMago2, Magos, Mago2),
    IndiceMago1 is IndiceMago2 - 1.

compartenCasa(Mago, OtroMago) :-
    quedaSeleccionado(Mago, Casa),
    quedaSeleccionado(OtroMago, Casa).

% Resolución PARTE 2 %

% Punto 1 %
% A

buenAlumno(Mago) :-
    mago(Mago),
    forall(hizo(Mago, Accion), buena(Accion)).

buena(Accion) :-
    accion(buena, Accion, _).

mago(Mago) :-
    esDe(Mago, _).

% B

recurrente(Accion) :-
    hizo(Mago1, Accion),
    hizo(Mago2, Accion),
    Mago1 \= Mago2.

% Punto 2 %

puntaje(Casa, Puntos) :-
    esDe(_, Casa),
    findall(PuntosIndividuales, (esDe(Mago, Casa), puntosDeUnMago(Mago, PuntosIndividuales)), Puntajes),
    sum_list(Puntajes, Puntos).
    
puntosDeUnMago(Mago, PuntosIndividuales) :-
    mago(Mago),
    findall(Puntaje, puntajeAccion(Mago,Puntaje), ListaPuntosIndividuales),
    sum_list(ListaPuntosIndividuales, PuntosIndividuales).

% Punto 3 %

casaGanadora(Casa) :-
    casa(Casa),
    mejorPuntaje(Casa).

mejorPuntaje(Casa) :-
    puntaje(Casa, PuntosCasa),
    forall((puntaje(OtraCasa, PuntosOtraCasa), Casa \= OtraCasa), PuntosCasa > PuntosOtraCasa).

% Punto 4 % 

puntajeAccion(Mago, Puntaje) :-
    hizo(Mago, Accion),
    accion(_, Accion, Puntaje).

puntajeAccion(Mago, PuntajeAjustado) :-
    hizo(Mago, respuestaA(_, Profesor)),
    pregunta(_, respuestaA(_, Profesor), PuntajeBase),
    factorPuntos(Profesor, Factor),
    PuntajeAjustado is PuntajeBase * Factor.

% factorPuntos/2

factorPuntos(snape, 0.5).
factorPuntos(Profesor, 1):-
    Profesor \= snape.