module MokuMoku.Connpass
  ( module X
  , fetchEvent
  ) where

import           RIO

import           Data.Extensible
import           MokuMoku.Connpass.API    as X
import           MokuMoku.Connpass.Client as X
import           MokuMoku.Connpass.Type   as X
import qualified Network.HTTP.Req         as Req

fetchEvent :: MonadIO m => ApiClient -> EventID -> m (Maybe Event)
fetchEvent c eid = Req.runReq Req.defaultHttpConfig $ do
   resp <- search c (wrench $ #event_id @= [eid] <: nil)
   pure $ listToMaybe (Req.responseBody resp ^. #events)
