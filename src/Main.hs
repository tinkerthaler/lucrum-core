-- Allow data declarations with no constructors.
{-# LANGUAGE EmptyDataDecls #-}
{- This allows us to write class constraints such as (Stream s u Char) =>, where one of the type variables
is defined instead of polymorphic.
 -}
{-# LANGUAGE FlexibleContexts #-}
{-
An alternative syntax for datatypes, giving explicit type signatures for data constructors,
generalized by allowing the arguments of the result type to vary, e.g.
data Term :: * -> * where
    Const :: a -> Term a
    Pair  :: Term a -> Term b -> Term (a,b)
    Fst :: Term (a,b) -> Term a
    Snd :: Term (a,b) -> Term b
 -}
{-# LANGUAGE GADTs #-}
{-
String literals, on the other hand, are always of type String, and are not polymorphic at all.
The OverloadedStrings extension corrects this, making string literals polymorphic over the IsString type class,
which is found in the Data.String module in the base package
 -}
{-# LANGUAGE OverloadedStrings #-}
-- Template Haskell
{-# LANGUAGE QuasiQuotes #-}
-- Template Haskell
{-# LANGUAGE TemplateHaskell #-}
{-
ad-hoc overloading of data types.
Type families are parametric types that can be assigned specialized representations based on the type parameters
they are instantiated with. They are the data type analogue of type classes: families are used to define overloaded data
in the same way that classes are used to define overloaded functions.
 -}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Main where

import                      Control.Monad.IO.Class (liftIO)
import                      Control.Monad.Logger    (runStderrLoggingT)
import                      Database.Persist
--import                      Database.Persist.Sqlite
import                      Database.Persist.Postgresql
import                      Database.Persist.TH

share [mkPersist sqlSettings, mkMigrate "migrateAll"]
  [persistLowerCase|
   Person
     name String
     age Int Maybe
     deriving Show

   BlogPost
     title String
     authorId PersonId
     deriving Show
  |]

connStr = "host=localhost dbname=lucrum user=lucrum_admin port=5432"

main :: IO ()
--main = runSqlite ":memory:" $ do
main =
--  withPostgresqlPool connstr 10 $ \pool -> do
--    runNoLoggingT . flip runSqlPersistMPool pool $ do 
  runStderrLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do
    flip runSqlPersistMPool pool $ do
      runMigration migrateAll
    
      johnId <- insert $ Person "Johm Doe" $ Just 33
      janeId <- insert $ Person "Jane Doe" $ Nothing
  
      insert $ BlogPost "My first post" johnId
      insert $ BlogPost "One more for good measure" johnId
    
      oneJohnPost <- selectList [BlogPostAuthorId ==. johnId] [LimitTo 1]
      liftIO $ print (oneJohnPost :: [Entity BlogPost])
    
      john <- get johnId
      liftIO $ print (john :: Maybe Person)
    
      delete janeId
      deleteWhere [BlogPostAuthorId ==. johnId]

