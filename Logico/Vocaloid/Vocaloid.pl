% Base de conocimiento

vocaloid(megurineLuka, canta(nightFever, 4)).
vocaloid(megurineLuka, canta(forEverYoung, 5)).
vocaloid(hatsuneMiku, canta(tellYourWorld, 4)).
vocaloid(gumi, canta(forEverYoung, 4)).
vocaloid(gumi, canta(tellYourWorld, 5)).
vocaloid(seeU, canta(novemberRain, 6)).
vocaloid(seeU, canta(nightFever, 5)).

concierto(mikuExpo, estadosUnidos, gigante(2, 6), 2000).
concierto(magicalMirai, japon, gigante(3, 10), 3000).
concierto(vocalektVisions, estadosUnidos, mediano(9), 1000).
concierto(mikuFest, argentina, requisito(4), 100).

conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).

% novedoso/1

novedoso(Vocaloid) :-
    vocaloid(Vocaloid, canta(Tema1, Duracion1)),
    vocaloid(Vocaloid, canta(Tema2, Duracion2)),
    Tema1 \= Tema2,
    duracionMaxima(Duracion1, Duracion2, 15).

duracionMaxima(Duracion1, Duracion2, DuracionPermitida) :-
    DuracionTotal is Duracion1 + Duracion2,
    DuracionTotal < DuracionPermitida.

% acelerado/1

acelerado(Vocaloid) :-
    vocaloid(Vocaloid, canta(_, Duracion)),
    Duracion > 4.

% participa/2

participa(hatsuneMiku, _).

participa(Vocaloid, Concierto) :-
    vocaloid(Vocaloid),
    Vocaloid \= hatsuneMiku,
    concierto(Concierto, _, Requisitos, _),
    cumpleRequisitos(Vocaloid, Requisitos).

vocaloid(Vocaloid) :-
    vocaloid(Vocaloid, _).

cumpleRequisitos(Vocaloid, gigante(MinimoCanciones, DuracionMinima)) :-
    vocaloid(Vocaloid),
    sabe(Vocaloid, Canciones, TiempoTotal),
    minimo(Canciones, MinimoCanciones),
    minimo(TiempoTotal, DuracionMinima).

cumpleRequisitos(Vocaloid, mediano(Maximo)) :-
    vocaloid(Vocaloid),
    sabe(Vocaloid, _, TiempoTotal),
    maximo(TiempoTotal, Maximo).

cumpleRequisitos(Vocaloid, pequenio(Minutos)) :-
    vocaloid(Vocaloid, canta(_, Minutos)).

sabe(Vocaloid, Canciones, Tiempo) :-
    vocaloid(Vocaloid),
    cancionesTotales(Vocaloid, Canciones),
    minutosTotales(Vocaloid, Tiempo).

minutosTotales(Vocaloid, TiempoTotal) :-
    vocaloid(Vocaloid),
    findall(Tiempo, vocaloid(Vocaloid, canta(_, Tiempo)), Tiempos),
    sum_list(Tiempos, TiempoTotal).

cancionesTotales(Vocaloid, CuantasSabe) :-
    vocaloid(Vocaloid),
    findall(Cancion, vocaloid(Vocaloid, canta(Cancion, _)), Canciones),
    length(Canciones, CuantasSabe).

minimo(Valor, Minima) :-
    Valor >= Minima.

maximo(Valor, Maximo) :-
    Valor =< Maximo.

% masFamoso/1

masFamoso(Vocaloid) :-
    vocaloid(Vocaloid),
    nivelFama(Vocaloid, Fama), 
    not((nivelFama(OtroVocaloid, OtraFama), OtroVocaloid\= Vocaloid, OtraFama > Fama)).

nivelFama(Vocaloid, Fama) :-
    vocaloid(Vocaloid),
    famaConciertos(Vocaloid, FamaParcial),
    cancionesTotales(Vocaloid, CuantasSabe),
    Fama is FamaParcial * CuantasSabe.

famaConciertos(Vocaloid, Nivel) :-
    vocaloid(Vocaloid),
    findall(Fama, (participa(Vocaloid, Concierto), concierto(Concierto, _,  _, Fama)), FamaListada),
    sum_list(FamaListada, Nivel).

% unico/2

unico(Vocaloid, Concierto) :-
    participa(Vocaloid, Concierto),
    not((cadenaDeConococidos(Vocaloid, OtroVocaloid), participa(OtroVocaloid, Concierto), OtroVocaloid \= Vocaloid)).

cadenaDeConococidos(Vocaloid, Conocido) :-
    conoce(Vocaloid, OtroVocaloid),
    cadenaDeConococidos(OtroVocaloid, Conocido).

cadenaDeConococidos(Vocaloid, Conocido) :-
    conoce(Vocaloid, Conocido).