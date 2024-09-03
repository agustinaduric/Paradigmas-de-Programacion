% Base de Conocimiento

% disco(artista, nombreDelDisco, cantidad, año).
disco(floydRosa, elLadoBrillanteDeLaLuna, 1000000, 1973).
disco(tablasDeCanada, autopistaTransargentina, 500, 2006).
disco(rodrigoMalo, elCaballo, 5000000, 1999).
disco(rodrigoMalo, loPeorDelAmor, 50000000, 1996).
disco(rodrigoMalo, loMejorDe, 50000000, 2018).
disco(losOportunistasDelConurbano, ginobili, 5, 2018).
disco(losOportunistasDelConurbano, messiMessiMessi, 5, 2018).
disco(losOportunistasDelConurbano, marthaArgerich, 15, 2019).

manager(floydRosa, habitual(15)).
manager(tablasDeCanada, internacional(cachito, canada)).
manager(rodrigoMalo, trucho(tito)).

% clasico/1

clasico(Artista) :-
    disco(Artista, Disco, Ventas, _),
    cumple(Artista, Disco, Ventas).

cumple(_, loMejorDe, _).
cumple(_, _, Discos) :-
    Discos > 100000.

artista(Artista) :-
    disco(Artista, _, _, _).

% cantidadesVendidas/2

cantidadesVendidas(Artista, Vendido) :-
    artista(Artista),
    findall(Venta, disco(Artista, _, Venta,_), VentasParciales),
    sum_list(VentasParciales, Vendido).

% derechosAutor/2

derechosAutor(Artista, Importe) :-
    manager(Artista, Manager),
    descuentoSegunManager(Manager, Descuento),
    ganancia(Artista, SueldoParcial),
    Importe is SueldoParcial * (1 - Descuento / 100).

derechosAutor(Artista, Importe) :-
    artista(Artista),
    not(manager(Artista, _)),
    ganancia(Artista, Importe).

ganancia(Artista, Importe) :-
    artista(Artista),
    cantidadesVendidas(Artista, VentasTotales),
    Importe is VentasTotales * 100.

descuentoSegunManager(trucho(_), 100).

descuentoSegunManager(internacional(_, Lugar), Porcentaje) :-
    descuentoSegunLugar(Lugar, Porcentaje).

descuentoSegunLugar(canada, 5).
descuentoSegunLugar(mexico, 15).

% namberuan/1

namberuan(Artista, Anio):-
    ventasSinManager(Artista, Anio, Ventas),
    not((ventasSinManager(OtroArtista, Anio, OtraVentas), OtroArtista \= Artista, ventaSuperior(OtraVentas, Ventas))).

ventaSuperior(Venta1, Venta2) :-
    Venta1 > Venta2.

ventasSinManager(Artista, Anio, Ventas) :-
    disco(Artista, _, Ventas, Anio),
    not(manager(Artista, _)).