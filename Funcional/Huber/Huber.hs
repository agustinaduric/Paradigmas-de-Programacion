import Data.List()
import Text.Show.Functions()

-- PUNTO 1 --

data Chofer = Chofer {
    nombreChofer :: String,
    kilometraje :: Float,
    viajesTomados :: [Viaje],
    condicion :: Viaje -> Bool
}

data Viaje = Viaje{
    fecha :: String,
    cliente :: Cliente,
    costo :: Float
}

data Cliente = Cliente {
    nombreCliente :: String,
    vivienda :: String
}

-- PUNTO 2 --

sinRestricciones :: Viaje -> Bool
sinRestricciones _ = True

restriccionEnCosto :: Viaje -> Bool
restriccionEnCosto = (>=200) . costo

restriccionNombreCliente :: Int -> Viaje -> Bool
restriccionNombreCliente cantidadLetras  = 
   (>= cantidadLetras) . length . nombreCliente . cliente

type Zona = String

restriccionZona :: Zona -> Viaje -> Bool
restriccionZona unaZona =
    (/=unaZona) . vivienda . cliente

-- PUNTO 3 --

--- a)

clienteLucas :: Cliente
clienteLucas = Cliente "Lucas" "Victoria"

--- b) 

choferDaniel :: Chofer
choferDaniel =
    Chofer "Daniel" 23500 [Viaje "20/04/2017" clienteLucas 150]  (restriccionZona "Olivos")

--- c)

choferAlejandra :: Chofer
choferAlejandra =
    Chofer "Alejandra" 180000 [] sinRestricciones

-- PUNTO 4 --

puedeTomarViaje :: Chofer -> Viaje -> Bool
puedeTomarViaje unChofer = condicion unChofer

-- PUNTO 5 --

liquidacionDeChofer :: Chofer -> Float
liquidacionDeChofer  = sum . map costo . viajesTomados 

-- PUNTO 6 --

agregarViaje :: Viaje -> Chofer -> Chofer
agregarViaje viajeNuevo unChofer  = 
    unChofer{ viajesTomados = viajeNuevo : viajesTomados unChofer}

realizarViaje :: Viaje -> [Chofer] -> Chofer
realizarViaje unViaje =
     efectuar unViaje . choferConMenosViaje . choferesQueCumplen unViaje 

--- a)

choferesQueCumplen :: Viaje -> [Chofer] -> [Chofer]
choferesQueCumplen unViaje  = filter (flip puedeTomarViaje unViaje) 

--- b)

choferConMenosViaje :: [Chofer] -> Chofer
choferConMenosViaje [chofer1] = chofer1
choferConMenosViaje (chofer1: chofer2: otrosChoferes)
    | cantidadDeViajes chofer1 <= cantidadDeViajes chofer2 = choferConMenosViaje (chofer1 : otrosChoferes)
    | otherwise = choferConMenosViaje (chofer2 : otrosChoferes)

type ViajesContados = Int

cantidadDeViajes :: Chofer -> ViajesContados
cantidadDeViajes = length . viajesTomados

--- c)

efectuar :: Viaje -> Chofer -> Chofer
efectuar unViajeNuevo = agregarViaje unViajeNuevo 

-- PUNTO 7 --

--- a)

repetirViaje :: Viaje -> [Viaje]
repetirViaje unViaje = unViaje : repetirViaje unViaje

choferNito :: Chofer
choferNito =
    Chofer "Nito Infy" 70000 viajeInfinitoNito (restriccionNombreCliente 3)

viajeInfinitoNito :: [Viaje]
viajeInfinitoNito = repetirViaje (Viaje "11/03/2017" clienteLucas 50)