module MokuMoku.Connpass.Type where

import           RIO

import           Data.Extensible

type Result = Record
  '[ "results_returned"  >: Int
   , "results_available" >: Int
   , "results_start"     >: Int
   , "events"            >: [Event]
   ]

type EventID = Int

type Event = Record
  '[ "event_id"           >: EventID
   , "title"              >: Text
   , "catch"              >: Text
   , "description"        >: Text
   , "event_url"          >: Text
   , "hash_tag"           >: Text
   , "started_at"         >: Text
   , "ended_at"           >: Text
   , "limit"              >: Maybe Int
   , "event_type"         >: Text
   , "series"             >: Maybe Group
   , "address"            >: Maybe Text
   , "place"              >: Maybe Text
   , "lat"                >: Maybe Double
   , "lon"                >: Maybe Double
   , "owner_id"           >: Int
   , "owner_nickname"     >: Text
   , "owner_display_name" >: Text
   , "accepted"           >: Int
   , "waiting"            >: Int
   , "updated_at"         >: Text
   ]

type Group = Record
  '[ "id"    >: Int
   , "title" >: Text
   , "url"   >: Text
   ]
