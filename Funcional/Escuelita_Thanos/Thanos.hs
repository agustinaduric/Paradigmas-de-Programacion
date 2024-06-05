import Data.List()
import Text.Show.Functions()
import Distribution.Compat.CharParsing (CharParsing(string))

-- PUNTO 1 --

data Personaje = Personaje {
    nombre :: String,
    edad :: Int,
    energia :: Int,
    planeta :: String, 
    habilidades :: [String]
}

data Guantelete = Guantelete {
    material :: String,
    gemas :: [Gema]
}

iroMan :: Personaje
iroMan = Personaje "Iron Man" 35 100 "" []

drStrange :: Personaje
drStrange = Personaje "drStrange" 45 100 "" []

groot :: Personaje
groot = Personaje "Groot" 25 60 "" []

wolverine :: Personaje 
wolverine = Personaje "wolverine" 30 80 "" []

viudaNegra :: Personaje
viudaNegra = Personaje "Viuda Negra" 40 70 "" []

type Universo = [Personaje]
universo :: Universo
universo = [iroMan, drStrange,groot, wolverine,viudaNegra]

esPosibleChasquear :: Guantelete -> Bool
esPosibleChasquear unGuantelete = 
    esGuanteCompleto unGuantelete && esDeMaterial "uru" unGuantelete

esGuanteCompleto :: Guantelete -> Bool
esGuanteCompleto  = (6==) . length . gemas 

type Material = String

esDeMaterial :: Material -> Guantelete -> Bool
esDeMaterial unMaterial  = (== unMaterial) . material

chasquearUniverso :: Guantelete -> Universo 
chasquearUniverso unGuantelete 
    | esPosibleChasquear unGuantelete = efectoChasquido universo
    | otherwise = universo

efectoChasquido :: Universo -> Universo
efectoChasquido unUniverso = 
     take (flip div 2 $ length unUniverso) unUniverso

-- PUNTO 2 --

-- A) 

esUniversoAptoPendex :: Universo -> Bool
esUniversoAptoPendex = esUniversoApto 45 

esUniversoApto :: Edad -> Universo -> Bool
esUniversoApto unaEdad = any ((<unaEdad).edad) 

-- B) 

type Energia = Int

energiaTotalDelUniverso :: Universo -> Energia
energiaTotalDelUniverso  = sum . map energia 

-- PUNTO 3 --

type Gema = Personaje -> Personaje

type Habilidad = String

type Planeta = String

type Edad = Int

modificarUnPersonaje :: (Personaje -> a) -> (a -> a) -> (a -> Personaje -> Personaje) -> Personaje -> Personaje
modificarUnPersonaje unaCaracteristica unModificador aplicadorModificacion unPersonaje = 
  aplicadorModificacion (unModificador . unaCaracteristica $ unPersonaje) unPersonaje

mente :: Int -> Gema 
mente valor  = modificarUnPersonaje energia (subtract valor) modificadorEnergia 

modificadorEnergia :: Energia -> Personaje -> Personaje
modificadorEnergia nuevaEnergia unPersonaje = unPersonaje {energia = nuevaEnergia}

alma :: Habilidad -> Gema
alma unaHabilidad unPersonaje = 
   modificadorHabilidad (eliminarHabilidad unaHabilidad unPersonaje) (mente 10 unPersonaje)

eliminarHabilidad :: Habilidad -> Personaje -> [Habilidad]
eliminarHabilidad unaHabilidad  unPersonaje= 
    filter (/=unaHabilidad ) ( habilidades unPersonaje)

modificadorHabilidad :: [Habilidad] -> Personaje -> Personaje
modificadorHabilidad nuevaHabilidad unPersonaje = unPersonaje { habilidades = nuevaHabilidad}

espacio :: Planeta -> Gema
espacio unPlaneta unPersonaje =  nuevoPlaneta (mente 20 unPersonaje) unPlaneta

nuevoPlaneta :: Personaje -> Planeta -> Personaje
nuevoPlaneta unPersonaje unPlaneta = unPersonaje { planeta = unPlaneta}

poder :: Gema
poder unPersonaje = eliminarNhabilidades 2 (modificadorEnergia 0 unPersonaje )

eliminarNhabilidades :: Int -> Personaje -> Personaje
eliminarNhabilidades unNumero unPersonaje 
    | unNumero <= (length . habilidades $ unPersonaje ) = modificadorHabilidad [] unPersonaje
    | otherwise = unPersonaje

tiempo :: Gema 
tiempo unPersonaje = (mente 50 unPersonaje) { edad = reductorEdad . edad $ unPersonaje}

reductorEdad :: Edad -> Edad
reductorEdad unaEdad
    | ((>= 18) . div unaEdad ) 2 = div unaEdad 2
    | otherwise = 18

loca :: Gema -> Gema
loca unaGema = unaGema . unaGema 

-- PUNTO 4 --

guanteleteEjemplo :: String -> Guantelete
guanteleteEjemplo "usar Mjolnir" = 
    Guantelete  "uru" [tiempo, alma "usar Mjolnir" , loca . alma $ "Programacion en Haskell"] 

-- PUNTO 5 --

ejecutarPoder ::  [Gema] -> Personaje -> Personaje
ejecutarPoder unasGemas unPersonaje = foldl (flip ($)) unPersonaje unasGemas

-- PUNTO 6 --

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa unGuantelete  =
    sacaMasEnergia (gemas unGuantelete) 

sacaMasEnergia :: [Gema] -> Personaje -> Gema
sacaMasEnergia [gema1] _ = gema1
sacaMasEnergia (gema1:gema2:otrasGemas) unPersonaje
    | (energia . gema1 $ unPersonaje) < (energia . gema2 $ unPersonaje) = sacaMasEnergia (gema1:otrasGemas) unPersonaje
    | otherwise = sacaMasEnergia (gema2 : otrasGemas) unPersonaje