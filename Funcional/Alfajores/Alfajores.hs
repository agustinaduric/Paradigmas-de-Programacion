import Data.List(genericLength, isInfixOf)
import Text.Show.Functions()

-- PARTE 1 --

data Alfajor = Alfajor {
    nombre :: String,
    relleno :: [Relleno],
    peso :: Float,
    dulzor :: Float
}

data Relleno = DulceDeLeche | Mousse | Fruta deriving Eq

--- A)

jorgito :: Alfajor
jorgito = Alfajor "Jorgito" [DulceDeLeche]  80 8

havanna :: Alfajor
havanna = Alfajor "Havanna" [Mousse, Mousse] 60 12

capitanDelEspacio :: Alfajor
capitanDelEspacio = Alfajor "Capitán del espacio" [DulceDeLeche] 40 12

--- B) 

coeficienteDeDulzor :: Alfajor -> Float
coeficienteDeDulzor unAlfajor = (/ dulzor unAlfajor) . peso $ unAlfajor 

precioDeAlfajor :: Float -> Alfajor -> Float
precioDeAlfajor precioRelleno unAlfajor  = 
     ((* precioRelleno). cantidadDeCapas $ unAlfajor) + ((* 2) . peso $ unAlfajor)

cantidadDeCapas :: Alfajor -> Float
cantidadDeCapas = genericLength . relleno

precioDulceDeLEche :: Alfajor -> Float
precioDulceDeLEche = precioDeAlfajor 12

precioMousse :: Alfajor -> Float
precioMousse = precioDeAlfajor 15

precioFruta :: Alfajor -> Float
precioFruta = precioDeAlfajor 10

esPotable :: Alfajor -> Bool
esPotable unAlfajor = 
   ( (1>=). cantidadDeCapas $ unAlfajor) && capasMismoSabor unAlfajor && ((0.1>= ) . dulzor $ unAlfajor)

capasMismoSabor :: Alfajor -> Bool
capasMismoSabor unAlfajor = all (== primeraCapa unAlfajor) (relleno unAlfajor)

-- PARTE 2 --

bajarPeso :: Float -> Alfajor -> Alfajor
bajarPeso unPeso unAlfajor = 
    unAlfajor{peso = subtract unPeso (peso unAlfajor )}


sacarDulzor :: Float -> Alfajor -> Alfajor
sacarDulzor unDulzor unAlfajor = 
    unAlfajor{dulzor = dulzor unAlfajor - unDulzor}

--- A) 

abaratarAlfajor :: Alfajor -> Alfajor
abaratarAlfajor  = bajarPeso 10 . sacarDulzor 7

--- B)

renombrarAlfajor :: String -> Alfajor -> Alfajor
renombrarAlfajor nuevoNombre unAalfajor=
    unAalfajor{nombre = nuevoNombre}

--- C) 

agregarRelleno :: a -> [a] -> [a]
agregarRelleno nuevoRelleno = (nuevoRelleno :)

agregarCapa :: Alfajor -> Relleno -> Alfajor
agregarCapa unAlfajor unaCapa =
     unAlfajor{relleno = agregarRelleno unaCapa (relleno unAlfajor) }

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
    | unGrado /= 0= premiumGradoN (unGrado - 1) (efectoPremium unAlfajor)
    | otherwise = unAlfajor

--- F)

jorgitito :: Alfajor
jorgitito = renombrarAlfajor "Jorgitito" . abaratarAlfajor $ jorgito

jorgelin :: Alfajor
jorgelin = renombrarAlfajor "Jorgelín" . flip agregarCapa DulceDeLeche $ jorgito

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
tieneCapaDe unSabor unAlfajor = 
    elem unSabor (relleno unAlfajor)

--- A)

emi ::  Cliente
emi  = Cliente 120 [] [alfajorTieneNombreCon "CapitanDelEspacio"]

tomi :: Cliente
tomi = Cliente 100 [] [alfajorTieneNombreCon "Premium", coeficienteDulzorMayorA 0.15]

dante :: Cliente
dante = Cliente 200 [] [not . tieneCapaDe DulceDeLeche, not . esPotable]

juan :: Cliente
juan = Cliente 500 [] [alfajorTieneNombreCon "jorgito", not . tieneCapaDe Mousse]

--- B) 

--alfajoresRicosSegun :: Cliente -> [Alfajor]-> [Alfajor]

--- C)

agregarAlfajor :: a -> [a] -> [a]
agregarAlfajor = agregarRelleno

puedeComprar :: Cliente -> Float -> Alfajor -> Bool
puedeComprar unCliente precioRelleno unAlfajor= 
    precioDeAlfajor precioRelleno unAlfajor < dinero unCliente

comprarUnAlfajor :: Alfajor -> Float -> Cliente -> Cliente
comprarUnAlfajor unAlfajor precioRelleno unCliente
    | puedeComprar unCliente precioRelleno unAlfajor = 
       clienteTrasPagar (gastarDinero (precioDeAlfajor precioRelleno unAlfajor) unCliente) unAlfajor
    | otherwise = unCliente

setAlfajores :: Cliente -> [Alfajor] -> Cliente
setAlfajores unCliente unosAlfajores =
    unCliente{alfajoresComprados = unosAlfajores}

gastarDinero :: Float -> Cliente -> Cliente
gastarDinero unDinero unCliente = unCliente{dinero = subtract unDinero (dinero unCliente) }

clienteTrasPagar :: Cliente -> Alfajor -> Cliente
clienteTrasPagar unCliente unAlfajor =
     setAlfajores unCliente (agregarAlfajor unAlfajor (alfajoresComprados unCliente))

--- D) 