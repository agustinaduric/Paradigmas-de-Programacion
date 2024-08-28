% Base de conocimiento

% juego(tipo, nombre, precio).
juego(accion, subwaySurfers, 50000).
juego(accion, counterStrike, 55600).
juego(rol, rocket, 30000).
juego(rol, minecraft, 49000).
juego(puzzle, sims4, 25500).

% informacion(nombre, caracteristica).
informacion(sims4, caracteristica( 10, facil)).
informacion(rocket, caracteristica(20000000)).

posee(usuario1, minecraft).
posee(usuario1, subwaySurfers).
posee(usuario2, sims4).
posee(usuario2, rocket).
posee(usuario3, sims4).

quiere(usuario1, minecraft, regalar(usuario2)).
quiere(usuario2, subwaySurfers, simismo).
quiere(usuario2, counterStrike, regalar(usuario1)).

% oferta(nombreJuego, descuento)
oferta(juego1, 30).
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
    Porcentaje is Descuento/10,
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

buenosAmigos(Usuario1, Usuario2) :-
    regaloPopular(Usuario1,Usuario2),
    regaloPopular(Usuario2, Usuario1).

regaloPopular(Usuario1, Usuario2) :-
    quiere(Usuario1, Juego, regalar(Usuario2)),
    popular(Juego).

% gastara/2

gastara(Usuario, Dinero) :-
    usuario(Usuario),
    findall(Precio, (quiere(Usuario, Juego, _), precio(Juego, Precio)), Precios),
    sum_list(Precios, Dinero).