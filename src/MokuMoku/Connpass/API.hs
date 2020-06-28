module MokuMoku.Connpass.API where

import           RIO

import           Data.Extensible
import qualified MokuMoku.Connpass.Type as Connpass
import           Network.HTTP.Req
import           Network.Simple         (Client (..), OptionalParams, buildApi,
                                         buildRequestParams)

search :: (MonadHttp m, Client c)
  => c
  -> SearchParams
  -> m (JsonResponse Connpass.Result)
search client =
  buildApi client GET (baseUrl client /: "event" /: "") NoReqBody . buildRequestParams

type SearchParams = OptionalParams
  '[ "event_id"       >: [Connpass.EventID]
   , "keyword"        >: [Text]
   , "keyword_or"     >: [Text]
   , "ym"             >: [Int]
   , "ymd"            >: [Int]
   , "nickname"       >: [Text]
   , "owner_nickname" >: [Text]
   , "series_id"      >: [Int]
   , "start"          >: Int
   , "order"          >: Int
   , "count"          >: Int
   ]
