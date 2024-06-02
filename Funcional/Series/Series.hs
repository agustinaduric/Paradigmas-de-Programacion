import Data.List()
import Text.Show()

-- PUNTO 1 --

data Serie = Serie {
    denominacion :: String,
    elenco :: [Actor],
    presupuesto :: Int, 
    temporadasEstimadas :: Int,
    rating :: Float,
    cancelada :: Bool
}

data Actor = Actor {
    nombre :: String,
    sueldo :: Int,
    retricciones :: [Restriccion]
}

type Restriccion = String

paulRudd :: Actor
paulRudd = Actor "Paul Rudd" 41000000 ["No actuar en bata", "Comer ensalada de rucula"]

--- A)

estaSerieEnRojo :: Serie -> Bool
estaSerieEnRojo unaSerie = (<) (presupuesto unaSerie) (cuantoCobranLosActores unaSerie)

cuantoCobranLosActores :: Serie -> Int
cuantoCobranLosActores = sum . map sueldo . elenco 

--- B)

tieneMasDeNRestricciones :: Int -> Actor -> Bool
tieneMasDeNRestricciones n = (>n) . length . retricciones 

esSerieProblematica :: Serie -> Bool
esSerieProblematica  = (>3) . actoresConRestricciones

-- PUNTO 2 --

type Productor = Serie -> Serie

type ActoresFavoritos = [Actor]

modificarUnaSerie :: (Serie -> a) -> (a -> a) -> (a -> Serie -> Serie) -> Serie -> Serie
modificarUnaSerie unCriterio unModificador aplicarModificacion unaSerie =
    aplicarModificacion (unModificador (unCriterio unaSerie)) unaSerie

cambiarElenco :: [Actor] -> Serie -> Serie
cambiarElenco nuevoElenco unaSerie = unaSerie{ elenco = nuevoElenco}

conFavoritismos :: ActoresFavoritos -> Productor
conFavoritismos unosActores = 
    modificarUnaSerie elenco ((unosActores ++) . drop  2) cambiarElenco 

-- Tim Burton

johnnyDepp :: Actor
johnnyDepp = Actor "Johnny Depp" 20000000 []

helenaBonham :: Actor
helenaBonham = Actor "helena bonham" 50000000 []

listaDeActoresFavoritos :: ActoresFavoritos
listaDeActoresFavoritos = [johnnyDepp, helenaBonham]

timButon :: Productor
timButon  = conFavoritismos listaDeActoresFavoritos 

-- Gatopardeitor

gatopardeitor :: Productor
gatopardeitor unaSerie = unaSerie

-- Estireitor

type Temporada = Int

estireitor :: Productor
estireitor  = 
    modificarUnaSerie temporadasEstimadas (*2) cambiarTemporadas 

cambiarTemporadas :: Temporada -> Serie -> Serie
cambiarTemporadas nuevaTemporada unaSerie = 
    unaSerie { temporadasEstimadas = nuevaTemporada}

-- Desespereitor

desespereitor :: Productor -> Productor -> Serie -> Serie
desespereitor idea1 idea2 = idea1 . idea2 

-- Canceleitor

type Raiting = Float

canceleitor :: Raiting -> Productor
canceleitor unRaiting unaSerie
    | cumpleCriterioCancelada unRaiting unaSerie = cancelarSerie unaSerie
    | otherwise = unaSerie

cancelarSerie :: Serie -> Serie
cancelarSerie  = cambiarcancelada False 

cambiarcancelada :: Bool -> Serie -> Serie
cambiarcancelada unValor unaSerie = unaSerie { cancelada = unValor}

tieneRaitingBajo :: Float -> Serie -> Bool
tieneRaitingBajo raitingBajo = (raitingBajo >) . rating

cumpleCriterioCancelada :: Raiting -> Serie -> Bool
cumpleCriterioCancelada unRaiting unaSerie = 
    estaSerieEnRojo unaSerie || tieneRaitingBajo unRaiting unaSerie

-- PUNTO 3 --

bienestar :: Serie -> Int
bienestar serie
  | cancelada serie = 0
  | otherwise = bienestarSegunLongitud serie + bienestarSegunReparto serie

bienestarSegunLongitud :: Serie -> Int
bienestarSegunLongitud unaSerie
  | ((> 4) . temporadasEstimadas ) unaSerie = 5
  | otherwise = (*2) . (subtract 10 . temporadasEstimadas) $ unaSerie

bienestarSegunReparto :: Serie -> Int
bienestarSegunReparto unaSerie
  | (<10) . length . elenco $ unaSerie = 3
  | otherwise = max 2 . subtract 10 . actoresConRestricciones $ unaSerie

actoresConRestricciones :: Serie -> Int
actoresConRestricciones unaSerie = length (filter (tieneMasDeNRestricciones 1) (elenco unaSerie))

-- PUNTO 4 --