-- PUNTO 1 --

data Turista = Turista {
    nivelCansacio :: Int,
    nivelEstres :: Int,
    acompaniado :: Bool,
    idiomas :: [String]
}

modificarEstres :: (Int -> Int) -> Turista -> Turista
modificarEstres unModificador unTurista =
    unTurista{ nivelEstres = unModificador . nivelEstres $ unTurista}

modificarCansacio :: (Int -> Int) -> Turista -> Turista
modificarCansacio unModificador unTurista =
    unTurista{ nivelCansacio = (unModificador . nivelCansacio) unTurista}

type Idioma = String

sumarIdioma :: Idioma -> Turista -> Turista
sumarIdioma unIdioma unTurista = 
    unTurista { idiomas = unIdioma : idiomas unTurista }

turistaAcompaniado :: Turista -> Turista
turistaAcompaniado unTurista = 
    unTurista { acompaniado = True}

type Excursion = Turista -> Turista

irALaPlaya :: Excursion
irALaPlaya unTurista
    | acompaniado unTurista = modificarEstres (subtract 1) unTurista
    | otherwise = modificarCansacio (subtract 5) unTurista

type Elemento = String

apreciarUn :: Elemento -> Excursion
apreciarUn unElemento = modificarEstres ((subtract . length) unElemento)

salirAHablar :: Idioma -> Turista -> Turista
salirAHablar unIdioma = turistaAcompaniado . sumarIdioma unIdioma

type Minutos = Int

caminar :: Minutos -> Excursion
caminar unosMinutos =
    modificarEstres (subtract . nivelIntesidad $ unosMinutos) . modificarCansacio (+ nivelIntesidad unosMinutos )

type Intensidad = Int

nivelIntesidad ::  Minutos -> Intensidad
nivelIntesidad minutos = div minutos 4

data Marea = Fuerte | Moderada | Tranquila deriving Eq

paseoEnBarco :: Marea -> Excursion
paseoEnBarco unaMarea unTurista 
    | unaMarea == Fuerte = modificarEstres (+6) . modificarCansacio (+10) $ unTurista
    | unaMarea == Tranquila = salirAHablar "Alemán" . apreciarUn "Mar" . caminar 10 $ unTurista
    | otherwise = unTurista

ana :: Turista
ana = Turista 0 21 True ["Español"]

beto :: Turista
beto = Turista 15 15 False ["Alemán"]

cathi :: Turista
cathi = sumarIdioma "Catalán" beto 

-- PUNTO 2 --

--- A)

hacerUnaExcursion :: Excursion -> Turista -> Turista
hacerUnaExcursion unaExcursion unTurista = 
    modificarEstres (subtract . obtenerPorcentajeDe nivelEstres $ unTurista) . unaExcursion $ unTurista

obtenerPorcentajeDe :: Indice -> Turista -> Int
obtenerPorcentajeDe unAspecto = flip div 100 . unAspecto 

--- B)

type Indice = Turista -> Int

deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

deltaExcursionSegun :: Indice-> Turista -> Excursion -> Int
deltaExcursionSegun unIndice turistaOriginal unaExcursion =
    deltaSegun unIndice (unaExcursion turistaOriginal) turistaOriginal

--- C)

esExcursionEducativa :: Turista -> Excursion -> Bool
esExcursionEducativa unTurista unaExcursion =
    0 /= deltaExcursionSegun (length . idiomas) unTurista unaExcursion

excursionesDesestresantes :: Turista -> [Excursion] -> [Excursion]
excursionesDesestresantes unTurista  =
    filter (esDesestresante unTurista) 

esDesestresante :: Turista -> Excursion -> Bool
esDesestresante unTurista = 
    (>=3) . abs . deltaExcursionSegun nivelEstres unTurista 

-- PUNTO 3 --

type Tour = [Excursion]

tourCompleto :: Tour
tourCompleto =
    [apreciarUn "Cascada" . caminar 20 , caminar 20, salirAHablar "Melmacquiano"]

ladoB :: Excursion -> Tour
ladoB unaExcursion = [unaExcursion . paseoEnBarco Tranquila, caminar 120]

islaVecina :: Marea -> Tour
islaVecina unaMarea
    | unaMarea == Fuerte = [paseoEnBarco unaMarea, apreciarUn "Lago", paseoEnBarco unaMarea]
    | otherwise = [paseoEnBarco unaMarea, irALaPlaya, paseoEnBarco unaMarea]

--- A)

hacerUnTour :: Tour -> Turista -> Turista
hacerUnTour unTour unTurista = 
    foldr hacerUnaExcursion (modificarEstres (+ cantidadExcursiones unTour) unTurista) unTour

cantidadExcursiones :: Tour -> Int
cantidadExcursiones = length 

--- B) 

existeTourConviniente :: Turista -> Tour -> Bool
existeTourConviniente unTurista  = any (esConveniente unTurista)  

esConveniente :: Turista -> Excursion -> Bool
esConveniente unTurista unaExcursion= 
    esDesestresante unTurista unaExcursion && consigueCompania unTurista unaExcursion

consigueCompania ::Turista ->  Excursion ->  Bool
consigueCompania unTurista  =
    acompaniado . flip hacerUnaExcursion unTurista

--- C) 

type Efectividad = Int

efectividadDeUnTour :: Tour -> [Turista] -> Efectividad
efectividadDeUnTour unTour unosTuristas =
    sum (map (`espiritualidadDeUnTurista` unTour) unosTuristas)

type Espiritualidad = Int

espiritualidadDeUnTurista :: Turista -> Tour -> Espiritualidad
espiritualidadDeUnTurista unTurista unTour
    | existeTourConviniente unTurista unTour = 
        sum (perdidaDe nivelCansacio unTurista unTour ++ perdidaDe nivelEstres unTurista unTour)
    | otherwise = 0

perdidaDe  :: Indice -> Turista -> Tour -> [Int]
perdidaDe unIndice unTurista = map (deltaExcursionSegun unIndice unTurista) 

-- PUNTO 4 --

visitarInfinitasPlayas :: Tour
visitarInfinitasPlayas = repeat irALaPlaya