module Test.Connpass.API where

import qualified MokuMoku.Connpass as Connpass
import           Servant
import           Test.Helper       (returnJsonFile)

type API = "connpass" :> "event" :> Get '[JSON] Connpass.Result

server :: Server API
server = returnJsonFile "test/fixture/connpass/events.json"
