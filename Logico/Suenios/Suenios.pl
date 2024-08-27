% Punto 1 %

% Base de conocimiento

cree(gabriel, campanita).
cree(gabriel,  magoDeOz).
cree(gabriel, cavenaghi).
cree(juan, conejoPascua).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

suenio(gabriel, ganarLoteria(5)).
suenio(gabriel, ganarLoteria(9)).
suenio(gabriel, futbolista(arsenal)).
suenio(juan, cantante(_, 100000)).
suenio(macarena, cantante(erucaSativa,10000)).

equipo(arsenal, chico).
equipo(aldosivi, chico).

enfermo(campanita).
enfermo(conejoPascua).
enfermo(reyesMagos).

amistad(campanita, reyesMagos).
amistad(campanita, conejoPascua).
amistad(conejoPascua, cavenaghi).

% Punto 2 %

ambiciosa(Persona) :-
    persona(Persona),
    findall(Dificultad, (suenio(Persona, Suenio), dificultad(Suenio, Dificultad)), Dificultades),
    sum_list(Dificultades, DificultadTotal),
    DificultadTotal > 20.

dificultad(cantante(_, 500000), 6).
dificultad(cantante(_, Discos), 4) :-
    Discos \= 500000.
dificultad(futbolista(Equipo), 3) :-
    equipo(Equipo, chico).
dificultad(futbolista(Equipo), 16) :-
    equipo(Equipo),
    not(equipo(Equipo, chico)).
dificultad(ganarLoteria(_), 10).

persona(Persona) :-
    cree(Persona, _).

equipo(Equipo) :-
    equipo(Equipo, _).

% Punto 3 %

quimica(Persona, Personaje) :-
    cree(Persona, Personaje),
    sueniosPuros(Persona),
    not(ambiciosa(Persona)).
quimica(Persona, campanita) :-
    cree(Persona, campanita),
    suenio(Persona, Suenio),
    dificultad(Suenio, Dificultad), 
    Dificultad < 5.

sueniosPuros(Persona) :-
    persona(Persona),
    forall(suenio(Persona, Suenio), puro(Suenio)).
    
puro(futbolista(_)).
puro(cantante(_, Discos)) :-
    Discos < 200000.

personaje(Personaje) :-
    cree(_, Personaje).

% Punto 4 %

alegrar(Persona, Personaje) :-
    suenio(Persona, _),
    quimica(Persona, Personaje),
    saludable(Personaje).

saludable(Personaje) :-
    personaje(Personaje),
    sano(Personaje).
saludable(Personaje) :-
    amistadBackUp(Personaje, AmigoBackUp),
    sano(AmigoBackUp).

sano(Personaje) :-
    personaje(Personaje),
    not(enfermo(Personaje)).

amistadBackUp(Personaje, AmigoBackUp) :-
    amistad(Personaje, Amigo),
    amistadBackUp(Amigo, AmigoBackUp).