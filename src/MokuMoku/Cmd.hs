module MokuMoku.Cmd where

import           RIO

import           Data.Fallible
import           MokuMoku.Env
import           MokuMoku.Event

cmd :: EventDate -> RIO Env ()
cmd date = evalContT $ do
  event <- lift (findEvent date) !?? notFound "event file" date
  owner <- lift (fetchOwner event) !?? notFound "owner" (event ^. #owner)
  connpass <- lift (fetchConnpass event) !?? notFound "connpass event" (tshow $ event ^. #connpass)
  logInfo (display $ "owner: " <> owner ^. #name)
  logInfo (display $ "connpass: " <> connpass ^. #title)
  where
    notFound name idx = exit (logError $ display $ name <> " not found: " <> idx)

showNotImpl :: MonadIO m => m ()
showNotImpl = hPutBuilder stdout "not yet implement command.\n"
