module MokuMoku.Env where

import           RIO

import           Data.Extensible

type Env = Record
  '[ "logger" >: LogFunc
   ]
