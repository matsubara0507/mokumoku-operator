module Main where

import           RIO

import qualified Spec.MokuMoku.Connpass
import qualified Test.Connpass.Client   as Connpass
import           Test.MockServer        (runMockServer)
import           Test.Tasty

main :: IO ()
main = runMockServer $ defaultMain =<< spec

spec :: IO TestTree
spec = testGroup "MokuMoku" <$> sequence
  [ Spec.MokuMoku.Connpass.specWith Connpass.TestClient
  ]
