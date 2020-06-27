module MokuMoku.Cmd where

import           RIO

import           MokuMoku.Env

cmd :: RIO Env ()
cmd = showNotImpl

showNotImpl :: MonadIO m => m ()
showNotImpl = hPutBuilder stdout "not yet implement command.\n"
