% Base de conocimiento

rata(remy, gusteaus).
rata(emile, chezMilleBar).
rata(django, pizzeriaJeSuis).

humano(linguini, prepara(ratatouille, 3)).
humano(linguini, prepara(sopa, 5)).
humano(colette, prepara(salmon, 9)).
humano(horst, prepara(ensaladaRusa, 8)).

trabaja(linguini, gusteaus).
trabaja(colette, gusteaus).
trabaja(horst, gusteaus).
trabaja(skinner, gusteaus).
trabaja(amelie, cafeDesMoulins).

tutor(amelie, skinner).
tutor(linguini, Rata) :-
    rata(Rata),
    trabaja(linguini, Lugar),
    rata(Rata, Lugar).

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(frutillasConCrema, postre(265)).

% Punto 1 % 

menu(Restaurante, Plato) :-
    plato(Plato),       
    trabaja(Cocinero, Restaurante),
    humano(Cocinero, prepara(Plato, _)).

restaurante(Restaurante) :-
    trabaja(_, Restaurante).

cocinero(Cocinero) :-
    trabaja(Cocinero, _).

plato(Plato) :-
    humano(_, prepara(Plato, _)).

% Punto 2 %

cocinaBien(remy, Plato) :-
    plato(Plato).

cocinaBien(Cocinero, Plato) :-
    bueno(Cocinero, Plato).

cocinaBien(Cocinero, Plato) :-
    humano(Cocinero, _),
    tutor(Tutor, Cocinero),
    bueno(Tutor, Plato).

bueno(Chef, Plato) :-
    humano(Chef, prepara(Plato, Experiencia)),
    Experiencia > 7.

rata(Rata) :-
    rata(Rata, _).

% Punto 3 %

chef(Cocinero, Restaurante) :-
    trabaja(Cocinero, Restaurante),
    findall(Experiencia, (humano(Cocinero, prepara(Plato, Experiencia)), menu(Restaurante, Plato)), ListaExperiencia),
    sum_list(ListaExperiencia, ExperienciaTotal),
    ExperienciaTotal >= 20.

chef(Cocinero, Restaurante) :-
    trabaja(Cocinero, Restaurante),
    cocinaPerfecto(Cocinero).

cocinaPerfecto(Cocinero) :-
    trabaja(Cocinero, Restaurante),
    forall((humano(Cocinero, prepara(Plato,_)), menu(Restaurante, Plato)), cocinaBien(Cocinero, Plato)).

% Punto 4 %

encargada(Persona, Plato) :-
    cocinero(Persona),
    plato(Plato),
    experto(Persona, Plato).

experto(Cocinero, Plato) :-
    plato(Plato),
    humano(Cocinero, prepara(Plato, Experiencia)),
    forall((humano(OtroCocinero, prepara(Plato, OtraExperiencia)), OtroCocinero \= Cocinero), Experiencia >= OtraExperiencia).

% Punto 5 %

saludable(Plato) :-
    plato(Plato, _),
    calorias(Plato, Calorias), 
    Calorias < 75.

calorias(Plato, Calorias) :-
    plato(Plato, Detalles),
    caloriasPorTipo(Detalles, Calorias).

calorias(pure, 20).
calorias(papas, 50).
calorias(ensalada, 0).
    
caloriasPorTipo(entrada(Ingredientes), Calorias) :-
    length(Ingredientes, Cantidad),
    Calorias is Cantidad * 15.
    
caloriasPorTipo(principal(Guarnicion, Minutos), Calorias) :-
    calorias(Guarnicion, CaloriasExtra),
    CaloriasPlato is Minutos * 5,
    Calorias is CaloriasPlato + CaloriasExtra.
    
caloriasPorTipo(postre(Calorias), Calorias).
    
% Punto 6 %

reseniaPositiva(Restaurante, Critico) :-
    restaurante(Restaurante),
    critico(Critico),
    not(ratas(Restaurante)),
    requisito(Critico, Restaurante).

requisito(antonEgo, Restaurante) :-
    especialista(Restaurante, ratatouille).

requisito(colmillot, Restaurante) :-
    restaurante(Restaurante),
    forall((trabaja(Empleado, Restaurante), humano(Empleado, prepara(Plato, _))), saludable(Plato)).

requisito(martiniano, Restaurante) :-
    chef(Empleado, Restaurante),
    chef(Empleado, Restaurante).

critico(Critico) :-
    requisito(Critico, _).

ratas(Restaurante) :-
    rata(_, Restaurante).

especialista(Restaurante, Comida) :-
    restaurante(Restaurante),
    forall(trabaja(Cocinero, Restaurante), cocinaBien(Cocinero, Comida)).