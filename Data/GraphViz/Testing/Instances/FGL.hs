{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE FlexibleInstances #-}

{- |
   Module      : Data.GraphViz.Testing.Instances.FGL
   Description : 'Arbitrary' instances for FGL graphs.
   Copyright   : (c) Ivan Lazar Miljenovic
   License     : 3-Clause BSD-style
   Maintainer  : Ivan.Miljenovic@gmail.com

   This module defines the 'Arbitrary' instances for FGL 'DynGraph'
   graphs.  Note that this instance cannot be in
   "Data.GraphViz.Testing.Instances", as this instance requires the
   FlexibleInstances extension, which makes some of the other
   'Arbitrary' instances fail to type-check.
-}
module Data.GraphViz.Testing.Instances.FGL() where

import Test.QuickCheck

import Data.Graph.Inductive.Graph(Graph, mkGraph, nodes, delNode)
import Data.List(nub)
import Control.Monad(liftM, liftM3)

-- -----------------------------------------------------------------------------
-- Arbitrary instance for FGL graphs.

instance (Graph g, Arbitrary n, Arbitrary e) => Arbitrary (g n e) where
  arbitrary = do ns <- liftM nub arbitrary
                 let nGen = elements ns
                 lns <- mapM makeLNode ns
                 les <- listOf $ makeLEdge nGen
                 return $ mkGraph lns les
    where
      makeLNode n = liftM ((,) n) arbitrary
      makeLEdge nGen = liftM3 (,,) nGen nGen arbitrary

  shrink gr = map (flip delNode gr) (nodes gr)