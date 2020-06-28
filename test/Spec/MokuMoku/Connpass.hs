module Spec.MokuMoku.Connpass
    ( specWith
    ) where

import           RIO

import           Data.Extensible
import           MokuMoku.Connpass as Connpass
import           Test.Helper       (shouldResponseAs)
import           Test.Tasty
import           Test.Tasty.Hspec

specWith :: Client c => c -> IO TestTree
specWith client = testSpec "MokuMoku.Connpass" $ do
  describe "search" $
    it "should return events" $
      Connpass.search client vacancy `shouldResponseAs` "test/fixture/connpass/events.json"
