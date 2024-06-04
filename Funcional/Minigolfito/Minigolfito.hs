import Data.List()
import Text.Show()

-- Modelo inicial

data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo

bart :: Jugador
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd :: Jugador
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa :: Jugador
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int

-- PUNTO 1 --

--- A) 

type Palo = Habilidad -> Tiro

putter :: Palo
putter unaHabilidad = 
    UnTiro 10 (modificarEn precisionJugador (*2) unaHabilidad ) 0

madera :: Palo
madera unaHabilidad = 
    UnTiro 100 (modificarEn precisionJugador (`div` 2) unaHabilidad) 5

hierro :: Int -> Palo
hierro n unaHabilidad = 
    UnTiro (modificarEn fuerzaJugador (*n) unaHabilidad) 
    (modificarEn precisionJugador (flip div n) unaHabilidad) 
    (max 0 (n-3))

modificarEn ::  (a -> b) -> (b -> b) -> a -> b
modificarEn unAspecto modificador = modificador . unAspecto

--- B) 

palos :: [Palo]
palos = [putter, madera] ++ map hierro [1..10]

-- PUNTO 2 --

type Golpe = Jugador -> Palo -> Tiro

golpeDeUnJugador :: Golpe
golpeDeUnJugador unJugador unPalo =
    unPalo . habilidad $ unJugador

-- PUNTO 3 --

-- Encontrar lo que es igual, parametrizar lo que es distinto

type Obstaculo = Tiro -> Tiro

data UnObstaculo = UnObstaculo{
  puedeSuperar :: Tiro -> Bool,
  efectoObstaculo :: Tiro -> Tiro
}

tiroAfectado :: (Tiro -> Bool) -> (Tiro -> Tiro) -> Tiro -> Tiro
tiroAfectado unaCondicion unEfecto unTiro
    | unaCondicion unTiro = unEfecto unTiro
    | otherwise = tiroDetenido

tiroDetenido :: Tiro
tiroDetenido = UnTiro 0 0 0

--- A)

tunelConRampita :: Obstaculo
tunelConRampita = tiroAfectado superaTunel efectoTunel

superaTunel :: Tiro -> Bool
superaTunel = (> 90) . precision 

efectoTunel :: Tiro -> Tiro
efectoTunel unTiro = 
    UnTiro (modificarEn velocidad (*2) unTiro) 100 0

-- B)

between n m x = elem x [n .. m]

laguna :: Int -> Obstaculo
laguna unLargoLaguna = tiroAfectado superaLaguna (efectoLaguna unLargoLaguna)

superaLaguna :: Tiro -> Bool
superaLaguna unTiro = ((<80). velocidad $ unTiro) && between 1 5 (altura unTiro)

efectoLaguna :: Int -> Tiro -> Tiro
efectoLaguna largoLaguna unTiro = unTiro{ altura = div (altura unTiro) largoLaguna}

-- C)

hoyo :: Obstaculo 
hoyo = tiroAfectado superaHoyo efectoHoyo

superaHoyo :: Tiro -> Bool
superaHoyo unTiro = between 5 20 (velocidad unTiro) && ((90<). precision $ unTiro)

efectoHoyo :: Tiro -> Tiro
efectoHoyo unTiro = tiroDetenido

-- PUNTO 4 --

--- A) 

palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles unJugador unObstaculo = filter (sonPalosUtiles unObstaculo unJugador) palos

sonPalosUtiles ::  Obstaculo -> Jugador -> Palo -> Bool
sonPalosUtiles unObstaculo unJugador =
   (/= tiroDetenido) . unObstaculo . golpeDeUnJugador unJugador

--- B) 

obstaculosSuperados :: [UnObstaculo] -> Tiro -> Int
obstaculosSuperados [] unTiro = 0
obstaculosSuperados (unObstaculo : unosObstaculos) unTiro
  | puedeSuperar unObstaculo unTiro = obstaculosSuperados unosObstaculos unTiro + 1
  | otherwise = 0
  
-- C)

maximoSegun f = foldl1 (mayorSegun f)

mayorSegun f a b
  | f a > f b = a
  | otherwise = b

paloMasUtil :: Jugador -> [UnObstaculo] -> Palo
paloMasUtil unJugador unosObstaculos =
  maximoSegun (obstaculosSuperados unosObstaculos . golpeDeUnJugador unJugador) palos

-- PUNTO 5 --

type PuntosTotales = (Jugador , Puntos)

padreDelNinioQueNoGano :: [PuntosTotales] -> [String]
padreDelNinioQueNoGano listaFinalTorneo =
  map ( padre . fst) (filter ( not . esJugadorGanador listaFinalTorneo) listaFinalTorneo)

esJugadorGanador :: [PuntosTotales] -> PuntosTotales -> Bool
esJugadorGanador listaJugadores unJugador =
  (all ((<snd unJugador) . snd ). filter (/=unJugador)) listaJugadores