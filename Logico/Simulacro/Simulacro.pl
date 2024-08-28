% Base de conocimiento

% juego(tipo, nombre, precio).
juego(accion, subwaySurfers, 50000).
juego(accion, counterStrike, 55600).
juego(rol, rocket, 30000).
juego(rol, minecraft, 49000).
juego(rol, sims4, 25500).
juego(puzzle, candyCrush, 1000).

% informacion(nombre, caracteristica).
% rol: caracteristica(usuarios activos)
% puzzle: caracteristica(niveles, dificultad).
informacion(candyCrush, caracteristica( 10000, facil)).
informacion(sims4, caracteristica(10000)).
informacion(rocket, caracteristica(2000000)).

% posee(usuario, juego)
posee(pepe, minecraft).
posee(pepe, subwaySurfers).
posee(carla, sims4).
posee(carla, rocket).
posee(marta, sims4).

quiere(pepe, minecraft, regalar(carla)).
quiere(carla, subwaySurfers, propio).
quiere(carla, counterStrike, regalar(pepe)).

% oferta(nombreJuego, descuento)
oferta(rocket, 30).
oferta(sims4, 50).
oferta(subwaySurfers, 10).

% precio/2

sale(Juego, Precio) :-
    juego(Juego),
    precio(Juego, Precio).

juego(Juego) :-
    juego(_, Juego, _).

precio(Juego, Precio) :-
    oferta(Juego, Descuento),
    juego(_, Juego, PrecioNormal),
    Porcentaje is Descuento / 100,
    aplicarDescuento(Juego, Porcentaje, Precio).

precio(Juego, Precio) :-
    juego(_, Juego, Precio).

aplicarDescuento(Juego, Porcentaje, PrecioFinal) :-
    juego(_ , Juego, Precio),
    PrecioFinal is Precio * Porcentaje.

% buenDescuento/1 %

buenDescuento(Juego) :-
    oferta(Juego, Descuento),
    Descuento >= 50.

popular(Juego) :-
    juego(Tipo, Juego, _),
    informacion(Juego, Caracteristicas),
    popularSegun(Tipo, Caracteristicas).

popular(minecraft).
popular(counterStrike).

popularSegun(accion, _).

popularSegun(rol, caracteristica(Juego, Usuarios)) :-
    juego(Juego),
    Usuarios > 1000000.

popularSegun(puzzle, caracteristica(25, _)).
popularSegun(puzzle, caracteristica(_, facil)).

% adictoAlDescuento/1

adictoAlDescuento(Usuario) :-
    usuario(Usuario),
    forall(quiere(Usuario, Juego, _), (oferta(Juego, Descuento), Descuento >= 50)).

usuario(Usuario) :-
    posee(Usuario, _).

% fanatico/2

fanatico(Usuario, Genero) :-
    juega(Usuario, Genero, Juego1),
    juega(Usuario, Genero, Juego2),
    Juego1 \= Juego2.

juega(Usuario, Genero, Juego) :-
    posee(Usuario, Juego),
    juego(Genero, Juego, _).

% monotematico/2

monotematico(Usuario, Genero) :-
    usuario(Usuario),
    genero(Genero),
    forall(posee(Usuario, Juego), juego(Genero, Juego, _)).

genero(Genero) :-
    juego(Genero, _ , _).

% buenosAmigos/2

buenosAmigos(pepe, carla) :-
    regaloPopular(pepe,carla),
    regaloPopular(carla, pepe).

regaloPopular(pepe, carla) :-
    quiere(pepe, Juego, regalar(carla)),
    popular(Juego).

% gastara/2

gastara(Usuario, Dinero) :-
    usuario(Usuario),
    findall(Precio, (quiere(Usuario, Juego, _), precio(Juego, Precio)), Precios),
    sum_list(Precios, Dinero).