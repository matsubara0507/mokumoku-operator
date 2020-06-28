module MokuMoku.Connpass.Client
  ( Client (..)
  , ApiClient
  , newClient
  ) where

import           RIO

import           Network.HTTP.Req      (Scheme (..), (/:))
import qualified Network.HTTP.Req      as Req
import           Network.Simple.Client (Client (..))

data ApiClient = ApiClient

instance Client ApiClient where
  type ClientScheme ApiClient = 'Https
  baseUrl = const (Req.https "connpass.com" /: "api" /: "v1")
  mkHeader ApiClient = Req.header "User-Agent" "mokumoku-operator"

newClient :: ApiClient
newClient = ApiClient
