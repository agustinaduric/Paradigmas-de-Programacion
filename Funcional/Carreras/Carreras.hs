-- PUNTO 1 --

data Auto = Auto{
    color :: String,
    velocidad :: Int,
    distancia :: Int
}

type Carrera = [Auto]

--- a)

estaCerca :: Auto -> Auto -> Bool
estaCerca unAuto otroAuto = 
    sonDistintos unAuto otroAuto && ((<=10) . distanciaEntre unAuto $ otroAuto)

sonDistintos :: Auto -> Auto -> Bool
sonDistintos unAuto = (/= color unAuto) . color

distanciaEntre :: Auto -> Auto -> Int
distanciaEntre unAuto = abs . subtract ( distancia unAuto ) . distancia 

--- b) 

vaTranquilo :: Auto -> Bool
vaTranquilo unAuto =
    (not . tieneAutosCerca $ unAuto) && vaGanando unAuto

tieneAutosCerca :: Auto -> Bool
tieneAutosCerca unAuto = any (estaCerca unAuto) autosEnCarrera

vaGanando :: Auto -> Bool
vaGanando unAuto = all (recorrioMasDistancia unAuto) autosEnCarrera

recorrioMasDistancia :: Auto -> Auto -> Bool
recorrioMasDistancia unAuto = (< distancia unAuto) . distancia

--- c)

obtenerPuesto :: Auto -> Int
obtenerPuesto = (+1) . length . autosPasados 

autosPasados :: Auto -> [Auto]
autosPasados unAuto =
    filter (recorrioMasDistancia unAuto)  autosEnCarrera

-- PUNTO 2 --

--- a)

type Distancia = Int

aumentarDistancia :: Distancia -> Auto -> Auto
aumentarDistancia unaDistancia unAuto = 
    unAuto{distancia = distancia unAuto + unaDistancia}

type Tiempo = Int

correr :: Tiempo -> Auto -> Auto
correr unTiempo unAuto = 
    aumentarDistancia (velocidad unAuto * unTiempo) unAuto

--- b) 

---- i)

modificarVelocidad :: (Int -> Int) -> Auto -> Auto
modificarVelocidad unModificador unAuto =
    unAuto{velocidad = unModificador . velocidad $ unAuto}

---- ii)

bajarVelocidad :: Int -> Auto -> Auto
bajarVelocidad unaCantidad =
   modificarVelocidad (max 0 . subtract unaCantidad)

-- PUNTO 3 --

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista
  = (map efecto . filter criterio) lista ++ filter (not.criterio) lista

type PowerUp = Auto -> Carrera -> Carrera 

--- a) 

terremoto :: PowerUp
terremoto unAuto =
    afectarALosQueCumplen (estaCerca unAuto) (modificarVelocidad (subtract 50)) 
    
--- b)

miguelitos :: Tiempo -> PowerUp
miguelitos unaCantidad unAuto =
    afectarALosQueCumplen (recorrioMasDistancia unAuto) (modificarVelocidad (subtract unaCantidad))

--- c) 

jetPack :: Tiempo -> PowerUp
jetPack cantidadTiempo unAuto =
    afectarALosQueCumplen (sonDistintos unAuto) (usarJetPack cantidadTiempo)

usarJetPack :: Tiempo -> Auto -> Auto
usarJetPack cantidadTiempo unAuto =
    modificarVelocidad (const . velocidad $ unAuto) . correr cantidadTiempo . 
    modificarVelocidad (*2) $ unAuto

-- PUNTO 4 --

type Evento = Carrera -> Carrera

type Puesto =  Int

type Color = String

type TablaPosiciones = [(Puesto, Color)]

--- a) 

simularCarrera :: Carrera -> [Evento] -> TablaPosiciones
simularCarrera unosAutos unosEventos =
     map generarTablaPosiciones (aplicarEvento unosEventos unosAutos)

aplicarEvento :: [Evento] -> Carrera -> Carrera
aplicarEvento  [] unaCarrera = unaCarrera 
aplicarEvento (evento1:eventoN) unaCarrera = aplicarEvento eventoN (evento1 unaCarrera)

generarTablaPosiciones :: Auto -> (Int, String)
generarTablaPosiciones unAuto = (obtenerPuesto unAuto , color unAuto)

--- b) 

---- i)

correnTodos :: Tiempo -> [Auto] -> [Auto]
correnTodos unTiempo = map (correr unTiempo) 

---- ii)

usarPowerUp :: Color -> PowerUp-> Carrera -> Carrera
usarPowerUp unColor unPowerUp unaCarrera= 
    unPowerUp  (head . filter ((== unColor) . color ) $ unaCarrera)  unaCarrera

--- c)

auto1 :: Auto
auto1 = Auto "Rojo" 120 0

auto2 :: Auto
auto2 = Auto "Blanco" 120 0

auto3 :: Auto
auto3 = Auto "Azul" 120 0

auto4 :: Auto
auto4 = Auto "Negro" 120 0

autosEnCarrera :: Carrera
autosEnCarrera = [auto1,auto2,auto3,auto4]

eventosSimulacion :: [Evento]
eventosSimulacion = 
    [correnTodos 30, usarPowerUp "Azul" (jetPack 3), usarPowerUp "Blanco" terremoto,
    correnTodos 40, usarPowerUp "Blanco" (miguelitos 20), usarPowerUp "Negro" (jetPack 6), correnTodos 10]

carreraSimulada :: TablaPosiciones
carreraSimulada = simularCarrera autosEnCarrera eventosSimulacion