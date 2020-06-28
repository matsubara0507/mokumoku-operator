module Main where

import           Paths_mokumoku_operator (version)
import           RIO

import           Configuration.Dotenv    (defaultConfig, loadFile)
import           Data.Extensible
import           Data.Extensible.GetOpt
import           GetOpt                  (withGetOpt')
import           Mix
import           Mix.Plugin.Logger       as MixLogger
import           Mix.Plugin.Shell        as MixShell
import           MokuMoku.Cmd
import           System.Environment      (getEnv)
import qualified Version
import qualified Web.Slack               as Slack

main :: IO ()
main = withGetOpt' "[options] [event date (YYYY-MM-DD)]" opts $ \r args usage -> do
  _ <- tryIO $ loadFile defaultConfig
  if | r ^. #help    -> hPutBuilder stdout (fromString usage)
     | r ^. #version -> hPutBuilder stdout (Version.build version <> "\n")
     | otherwise      -> runCmd r (fromMaybe "" $ listToMaybe args)
  where
    opts = #help    @= helpOpt
        <: #version @= versionOpt
        <: #verbose @= verboseOpt
        <: #work    @= workOpt
        <: nil

type Options = Record
  '[ "help"    >: Bool
   , "version" >: Bool
   , "verbose" >: Bool
   , "work"    >: FilePath
   ]

helpOpt :: OptDescr' Bool
helpOpt = optFlag ['h'] ["help"] "Show this help text"

versionOpt :: OptDescr' Bool
versionOpt = optFlag [] ["version"] "Show version"

verboseOpt :: OptDescr' Bool
verboseOpt = optFlag ['v'] ["verbose"] "Enable verbose mode: verbosity level \"debug\""

workOpt :: OptDescr' FilePath
workOpt = fromMaybe "." <$> optLastArg ['w'] ["work"] "PATH" "Working directory that exist event files"

runCmd :: Options -> String -> IO ()
runCmd opts date = do
  slackToken <- fromString <$> getEnv "SLACK_TOKEN"
  let plugin = hsequence
             $ #logger <@=> MixLogger.buildPlugin logOpts
            <: #work   <@=> MixShell.buildPlugin (opts ^. #work)
            <: #slack  <@=> pure (Slack.newClient slackToken)
            <: nil
  Mix.run plugin (cmd $ fromString date)
  where
    logOpts = #handle @= stdout <: #verbose @= (opts ^. #verbose) <: nil
