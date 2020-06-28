module MokuMoku.Event where

import           RIO
import           RIO.FilePath
import qualified RIO.List               as L
import qualified RIO.Text               as T

import           Data.Extensible
import           Data.Fallible
import qualified Data.Yaml              as Y
import qualified Mix.Plugin.Shell       as MixShell
import qualified MokuMoku.Connpass      as Connpass
import           MokuMoku.Env           (Env)
import qualified Web.Slack              as Slack
import qualified Web.Slack.WebAPI.Users as Users

type EventDate = Text -- ^ YYYY-MM-DD

toFilePath :: EventDate -> RIO Env (Maybe FilePath)
toFilePath date = do
  workDir <- view MixShell.workL
  pure $ case T.unpack <$> T.split (== '-') date of
    [yyyy, mm, dd] -> Just (workDir </> yyyy </> mm ++ dd <.> "yaml")
    _              -> Nothing

type Event = Record
  '[ "owner"    >: Slack.UserID
   , "connpass" >: Text -- ^ connpass event link
   ]

findEvent :: EventDate -> RIO Env (Maybe Event)
findEvent date = evalContT $ do
  path <- lift (toFilePath date) !?? exit (pure Nothing)
  val  <- liftIO (Y.decodeFileEither path) !?? exit (pure Nothing)
  pure (Just val)

fetchOwner :: Event -> RIO Env (Maybe Slack.User)
fetchOwner event = do
  client <- view #slack
  owner  <- Slack.runWebApi $ Users.info client (event ^. #owner) vacancy
  pure $ either (const Nothing) (Just . view #user) owner

fetchConnpass :: Event -> RIO Env (Maybe Connpass.Event)
fetchConnpass event = case toEventID event of
  Just eid -> Connpass.fetchEvent Connpass.newClient eid
  Nothing  -> pure Nothing

toEventID :: Event -> Maybe Connpass.EventID
toEventID event = do
  eid <- L.lastMaybe $ filter (not . T.null) $ T.split (== '/') (event ^. #connpass)
  readMaybe (T.unpack eid)
