module Test.Helper
  ( shouldResponse
  , shouldResponseAs
  , returnJsonFile
  ) where

import           RIO              hiding (Handler)

import qualified Data.Aeson       as J
import           Network.HTTP.Req (JsonResponse, Req, defaultHttpConfig,
                                   responseBody, runReq)
import           Servant
import           Test.Tasty.Hspec

shouldResponse ::
  (J.FromJSON r, Show r, Eq r) => Req (JsonResponse r) -> r -> Expectation
shouldResponse request resp =
  runReq defaultHttpConfig (responseBody <$> request) `shouldReturn` resp

shouldResponseAs ::
  (J.FromJSON r, Show r, Eq r) =>  Req (JsonResponse r) -> FilePath -> Expectation
shouldResponseAs request path =
  J.eitherDecodeFileStrict path >>= \case
    Right json -> request `shouldResponse` json
    Left err   -> expectationFailure err

returnJsonFile :: J.FromJSON r => FilePath -> Handler r
returnJsonFile path = liftIO (J.eitherDecodeFileStrict path) >>= \case
  Right json -> pure json
  Left err   -> throwError $ err500 { errBody = fromString err }
