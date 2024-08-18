% PARTE 1 %

% Base de conocimiento %

% mago/3
% mago(nombre, sangre, []).

mago(harry, mestiza, [amistad, coraje, inteligencia, orgullo]).
mago(draco, pura, [inteligencia, orgullo]).
mago(hermaione, impura, [inteligencia, orgullo, responsabilidad]). % agg: amistad para probar punto 4

% odia/2
% odia(mago, casa).

odia(harry, slytherin).
odia(draco, hufflepuff).

% apropiado/2
% apropiado(casa, valor).

apropiado(gryffindor, coraje).
apropiado(slytherin, orgullo).
apropiado(slytherin, inteligencia).
apropiado(ravenclaw, inteligencia).
apropiado(ravenclaw, responsiblidad).
apropiado(hufflepuff, amistad).

% Punto 1 %
% puedeEntrar/2 %

puedeEntrar(Mago, slytherin) :-
    mago(Mago),
    not(mago(Mago, impura, _)).

puedeEntrar(Mago, Casa) :-
    mago(Mago),
    casa(Casa),
    Casa \= slytherin.

mago(Mago) :-
    mago(Mago, _, _).

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

quedaSeleccionado(hermaione, gryffindor).

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