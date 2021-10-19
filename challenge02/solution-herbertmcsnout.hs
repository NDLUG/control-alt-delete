----------------------------------------
-- Challenge 02: Firmware
----------------------------------------
-- Compile with:
-- ghc -no-keep-hi-files -no-keep-o-files solution-herbertmcsnout.hs
----------------------------------------

module Main where
import Data.String (lines)

----------------------------------------
-- Helpers
----------------------------------------

data InstrType = ACC | JMP | NOP
--type Instruction = (InstrType, Int)

type Prog = (Int, Int)
defaultProg = (0, 0)

--($$) :: Prog -> Instruction -> Prog
(acc, pc) $$ (ACC, i) = (acc + i, pc + 1)
(acc, pc) $$ (JMP, i) = (acc + 0, pc + i)
(acc, pc) $$ (NOP, i) = (acc + 0, pc + 1)

--(|?|) :: Maybe a -> Maybe a -> Maybe a
(|?|) = maybe id (const . Just)

--adjustNth :: Functor m => Int -> (a -> m a) -> [a] -> m [a]
adjustNth n f as =
  let (before, (a : after)) = splitAt n as in
    (\ a' -> before ++ (a' : after)) <$> f a

--swapInstr' :: InstrType -> Maybe InstrType
swapInstr' ACC = Nothing
swapInstr' JMP = Just NOP
swapInstr' NOP = Just JMP

--swapInstr :: Instruction -> Maybe Instruction
swapInstr (t, j) = flip (,) j <$> swapInstr' t


----------------------------------------
-- Parsing
----------------------------------------

--bitToInt :: Char -> Int
bitToInt '0' = 0
bitToInt '1' = 1

--sign :: Char -> Int
sign '0' =  1
sign '1' = -1

--bitstrToInt :: Int -> String -> Int
bitstrToInt acc "" = acc
bitstrToInt acc (b : bs) = bitstrToInt (bitToInt b + 2 * acc) bs

--instrType :: Char -> Char -> InstrType
instrType '0' '0' = NOP
instrType '0' '1' = ACC
instrType '1' '0' = JMP

--bitstrToInstruction :: String -> Instruction
bitstrToInstruction (b0 : b1 : s : vs) = (instrType b0 b1, sign s * bitstrToInt 0 vs)


----------------------------------------
-- Execution
----------------------------------------

--exec :: [Instruction] -> Either ([Int], Int) Int
exec is = exec_h defaultProg is []

--exec_h :: Prog -> [Instruction] -> [Int] -> Either ([Int], Int) Int
exec_h (acc, pc) is hist =
  if pc >= length is
    then Right acc
    else if pc `elem` hist
      then Left (hist, acc)
      else exec_h ((acc, pc) $$ (is !! pc)) is (pc : hist)

--execFix :: [Instruction] -> Int -> Maybe Int
execFix is i =
  adjustNth i swapInstr is >>= \ is' ->
  either (const Nothing) Just (exec is')

--execFixes :: [Instruction] -> [Int] -> Maybe Int
execFixes is = foldr (\ i m -> execFix is i |?| m) Nothing


----------------------------------------
-- Main and I/O
----------------------------------------

--main :: IO ()
main =
  getContents >>= \ input ->
  let instrs = map bitstrToInstruction (lines input)
      Left (hist, acc) = exec instrs
      Just ans = execFixes instrs hist in
    putStrLn ("Part A: " ++ show acc) >>
    putStrLn ("Part B: " ++ show ans)

