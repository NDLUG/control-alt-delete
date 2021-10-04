{- Challenge 01: Cipher -}
-- Compile with:
-- ghc -no-keep-hi-files -no-keep-o-files solution-herbertmcsnout.hs 

module Main where
import Data.Char

-- decrypt :: Int -> String -> String -> String
decrypt letters key input =
  [chr (ord 'A' + (letters + ord c - ord k) `mod` letters) | (k, c) <- zip (cycle key) input]

-- interactPrompt :: Int -> String -> String -> (String -> String)
interactPrompt letters key prefix s =
  let (sPrefix, sSuffix) = splitAt (length prefix) s in
    if prefix == sPrefix
      then prefix ++ decrypt letters key sSuffix
      else error "Invalid input"

-- modifyStream :: (String -> String) -> IO ()
modifyStream f = getLine >>= (putStrLn . f)

-- main :: IO ()
main =
  let letters = 26; key = "UNIX" in
    modifyStream (interactPrompt letters key "Username: ") >>
    modifyStream (interactPrompt letters key "Password: ")
