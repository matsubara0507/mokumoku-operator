module MokuMoku.Env where

import           RIO

import           Data.Extensible
import           Mix.Plugin.Logger ()
import           Web.Slack         (SlackApiClient)


type Env = Record
  '[ "logger" >: LogFunc
   , "work"   >: FilePath
   , "slack"  >: SlackApiClient
   ]
