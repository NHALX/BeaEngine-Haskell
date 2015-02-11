module BeaEngine.Util where
import Foreign.C.String

fromCSTR = map castCCharToChar . takeWhile (/=0) 
