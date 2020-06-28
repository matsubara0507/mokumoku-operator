{-# OPTIONS_GHC -fno-warn-unused-binds #-}

module Test.MockServer
    ( mockServer
    , runMockServer
    ) where

import           RIO

import           Control.Concurrent
import           Network.Wai.Handler.Warp
import           Servant
import qualified Test.Connpass.API        as Connpass

type API = Connpass.API

api :: Proxy API
api = Proxy

server :: Server API
server = Connpass.server

mockServer :: IO ()
mockServer = run 8000 (serve api server)

runMockServer :: IO () -> IO ()
runMockServer action = do
  _ <- forkIO mockServer
  action
