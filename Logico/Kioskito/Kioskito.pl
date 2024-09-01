% Base de conocimiento

trabaja(dodain, lunes, horario(9, 15)).
trabaja(dodain, miercoles, horario(9, 15)).
trabaja(dodain, viernes, horario(9, 15)).
trabaja(lucas, martes, horario(10, 20)).
trabaja(juanC, sabado, horario(18, 22)).
trabaja(juanC, domingo, horario(18, 22)).
trabaja(juanFdS, jueves, horario(10, 20)).
trabaja(juanFdS, viernes, horario(12, 20)).
trabaja(leoC, lunes, horario(14, 18)).
trabaja(leoC, miercoles, horario(14, 18)).
trabaja(martu, miercoles, horario(23, 24)).

trabaja(vale, Dia, Horario) :-
    trabaja(dodain, Dia, Horario).
trabaja(vale, Dia, Horario) :-
    trabaja(juanC, Dia, Horario).

venta(dodain, lunes, 1, detalle(golosina), 1200).
venta(dodain, lunes, 2, detalle(cigarrillo, jockey), 50).
venta(dodain, lunes, 3, detalle(golosina), 50).
venta(dodain, miercoles, 1, detalle(bebida, alcoholica, 8), 10).
venta(dodain, miercoles, 2, detalle(bebida, sinAlcohol, 1), 10).
venta(dodain, miercoles, 3, detalle(golosina), 10).
venta(martu, miercoles, 1, detalle(golosina), 1000).
venta(lucas, martes, 1, detalle(golosina), 600).

% atiende/3

atiende(Persona, Dia, Hora) :-
    trabaja(Persona, Dia, horario(Entrada, Salida)),
    between(Entrada, Salida, Hora).

% foreverAlone/3

foreverAlone(Persona, Dia, Horario) :-
    persona(Persona),
    atiende(Persona, Dia, Horario),
    not((atiende(Companiero, Dia, Horario), Persona \= Companiero)).

persona(Persona) :-
    trabaja(Persona, _, _).

% posibleAtencion/2

posibleAtencion(Personas, Dia) :-
    dia(Dia),
    findall(Persona, trabaja(Persona, Dia, _), Personas).

dia(Dia) :-
    trabaja(_, Dia, _).

% suertuda/1

suertuda(Persona) :-
    venta(Persona, _, _, _, _),
    forall(venta(Persona, Dia, 1, Detalle, Precio), ventaImportante(Persona, Detalle, Precio)).

ventaImportante(_, detalle(golosina), Precio) :-
    Precio > 100.

ventaImportante(_, detalle(bebida, alcoholica, _), _).

ventaImportante(_, detalle(bebida, sinAlcohol, Cantidad), _) :-
    Cantidad > 5.

ventaImportante(Persona, _, _) :-
    persona(Persona),
    findall(Marca, (venta(Persona, _, _,(cigarrillo, Marca), _)), Marcas ),
    length(Marcas, CantidadMarcas),
    CantidadMarcas > 2.