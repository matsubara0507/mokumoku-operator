module Test.Connpass.Client
    ( TestClient(..)
    ) where

import           RIO

import           Network.HTTP.Req (Scheme (Http), http, port, (/:))
import           Network.Simple   (Client (..))

data TestClient = TestClient

instance Client TestClient where
  type ClientScheme TestClient = 'Http
  baseUrl _ = http "localhost" /: "connpass"
  mkHeader _ = mconcat [ port 8000 ]
