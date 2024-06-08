import Data.List(genericLength, isInfixOf)
import Text.Show.Functions()

-- PARTE 1 --

data Alfajor = Alfajor {
    nombre :: String,
    relleno :: [Relleno],
    peso :: Float,
    dulzor :: Float
}

data Relleno = Relleno {
    sabor :: Sabor,
    precio :: Float
} deriving Eq

data Sabor = DulceDeLeche | Mousse | Fruta deriving Eq

--- A)

jorgito :: Alfajor
jorgito = Alfajor "Jorgito" [Relleno DulceDeLeche  12]  80 8

havanna :: Alfajor
havanna = Alfajor "Havanna" [Relleno Mousse 15, Relleno Mousse 15] 60 12

capitanDelEspacio :: Alfajor
capitanDelEspacio = Alfajor "Capitán del espacio" [Relleno DulceDeLeche  12] 40 12

--- B) 

coeficienteDeDulzor :: Alfajor -> Float
coeficienteDeDulzor unAlfajor = (/ dulzor unAlfajor) . peso $ unAlfajor 

precioDeAlfajor :: Alfajor -> Float
precioDeAlfajor unAlfajor  = 
     (2 * peso unAlfajor) + (sum . map precio . relleno $ unAlfajor)

cantidadDeCapas :: Alfajor -> Float
cantidadDeCapas = genericLength . relleno

precioDulceDeLEche :: Alfajor -> Float
precioDulceDeLEche = precioDeAlfajor 

precioMousse :: Alfajor -> Float
precioMousse = precioDeAlfajor 

precioFruta :: Alfajor -> Float
precioFruta = precioDeAlfajor 

esPotable :: Alfajor -> Bool
esPotable unAlfajor = 
   ( (1>=). cantidadDeCapas $ unAlfajor) && capasMismoSabor unAlfajor && ((0.1>= ) . dulzor $ unAlfajor)

capasMismoSabor :: Alfajor -> Bool
capasMismoSabor unAlfajor = all (== primeraCapa unAlfajor) (relleno unAlfajor)

-- PARTE 2 --

bajarPeso :: Float -> Alfajor -> Alfajor
bajarPeso unPeso unAlfajor = 
    unAlfajor{ peso = subtract unPeso (peso unAlfajor )}


sacarDulzor :: Float -> Alfajor -> Alfajor
sacarDulzor unDulzor unAlfajor = 
    unAlfajor{ dulzor = subtract unDulzor (dulzor unAlfajor)}

--- A) 

abaratarAlfajor :: Alfajor -> Alfajor
abaratarAlfajor  = bajarPeso 10 . sacarDulzor 7

--- B)

renombrarAlfajor :: String -> Alfajor -> Alfajor
renombrarAlfajor nuevoNombre unAalfajor=
    unAalfajor{ nombre = nuevoNombre}

--- C) 

agregarRelleno :: Relleno -> [Relleno] -> [Relleno]
agregarRelleno nuevoRelleno = (nuevoRelleno :)

agregarCapa :: Alfajor -> Relleno -> Alfajor
agregarCapa unAlfajor unaCapa =
     unAlfajor{ relleno = agregarRelleno unaCapa (relleno unAlfajor) }

--- D)

alfajorPremium :: Alfajor -> Alfajor
alfajorPremium unAlfajor 
    | esPotable unAlfajor = efectoPremium unAlfajor
    | otherwise = unAlfajor

efectoPremium :: Alfajor -> Alfajor
efectoPremium unAlfajor = 
    agregarMismoRelleno ( renombrarAlfajor (nombre unAlfajor ++ " premium") unAlfajor)

agregarMismoRelleno :: Alfajor -> Alfajor
agregarMismoRelleno unAlfajor = agregarCapa unAlfajor (primeraCapa unAlfajor)

primeraCapa :: Alfajor -> Relleno
primeraCapa = head . relleno

--- E) 

premiumGradoN :: Int -> Alfajor -> Alfajor
premiumGradoN unGrado unAlfajor 
    | unGrado /= 0 = premiumGradoN (unGrado - 1) (efectoPremium unAlfajor)
    | otherwise = unAlfajor

--- F)

jorgitito :: Alfajor
jorgitito = renombrarAlfajor "Jorgitito" . abaratarAlfajor $ jorgito

jorgelin :: Alfajor
jorgelin = renombrarAlfajor "Jorgelín" . flip agregarCapa (Relleno DulceDeLeche 12)  $ jorgito

capitanDelEspacioCostaACosta :: Alfajor
capitanDelEspacioCostaACosta = 
    renombrarAlfajor "Capitán del Espacio Costa A Costa" . premiumGradoN 4 . abaratarAlfajor $ capitanDelEspacio

-- PARTE 3 --

data Cliente = Cliente {
    dinero :: Float,
    alfajoresComprados :: [Alfajor],
    criterios :: [Alfajor -> Bool]
}

alfajorTieneNombreCon :: String -> Alfajor -> Bool
alfajorTieneNombreCon unasLetras = isInfixOf unasLetras. nombre 

coeficienteDulzorMayorA :: Float -> Alfajor -> Bool
coeficienteDulzorMayorA unaCifra = (>unaCifra) . dulzor  


tieneCapaDe :: Relleno -> Alfajor -> Bool
tieneCapaDe unRelleno unAlfajor = all (unRelleno ==) (relleno unAlfajor)

--- A)

emi ::  Cliente
emi  = 
    Cliente 120 [] [alfajorTieneNombreCon "CapitanDelEspacio"]

tomi :: Cliente
tomi = 
    Cliente 100 [] [alfajorTieneNombreCon "Premium", coeficienteDulzorMayorA 0.15]

dante :: Cliente
dante = 
    Cliente 200 [] [not . tieneCapaDe (Relleno DulceDeLeche 12), not . esPotable]

juan :: Cliente
juan = 
    Cliente 500 [] [alfajorTieneNombreCon "jorgito", not . tieneCapaDe (Relleno Mousse 15)]

--- B) 

alfajoresRicosSegun :: Cliente -> [Alfajor] -> [Alfajor]
alfajoresRicosSegun unCliente =
    filter (cumpleCriterio . criterios $ unCliente)

cumpleCriterio :: [Alfajor -> Bool] -> Alfajor -> Bool
cumpleCriterio unosCriterios unAlfajor = all ($ unAlfajor) unosCriterios 

--- C)


comprarAlfajor :: Cliente -> Alfajor -> Cliente
comprarAlfajor unCliente unAlfajor
    | puedeComprar unAlfajor unCliente = efectoCompra unAlfajor unCliente
    | otherwise = unCliente

puedeComprar :: Alfajor -> Cliente -> Bool
puedeComprar unAlfajor unCliente = 
    precioDeAlfajor unAlfajor <= dinero unCliente

efectoCompra :: Alfajor -> Cliente -> Cliente
efectoCompra unAlfajor unCliente =
     flip setAlfajores unCliente. agregarAlfajor unAlfajor . pagarAlfajor unAlfajor $ unCliente

agregarAlfajor :: Alfajor -> Cliente -> [Alfajor]
agregarAlfajor unAlfajor = (unAlfajor :) . alfajoresComprados 

setAlfajores :: [Alfajor] -> Cliente -> Cliente
setAlfajores unosAlfajores unCliente = unCliente{ alfajoresComprados = unosAlfajores}

pagarAlfajor :: Alfajor -> Cliente -> Cliente
pagarAlfajor unAlfajor unCliente =
    unCliente{ dinero = dinero unCliente - precioDeAlfajor unAlfajor}

--- D) 

comprarAlfajoresRicos :: Cliente -> [Alfajor] -> Cliente
comprarAlfajoresRicos unCliente unosAlfajores = 
    foldl comprarAlfajor unCliente (alfajoresRicosSegun unCliente unosAlfajores)