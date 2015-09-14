{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, UndecidableInstances #-}

import Control.Monad.Trans.Class

-- defining a monad transformer
newtype MaybeT m a = MaybeT {
    runMaybeT :: m (Maybe a)
  }

bindMT, altBindMT :: (Monad m) => MaybeT m a -> (a -> MaybeT m b) -> MaybeT m b
x `bindMT` f = MaybeT $
  runMaybeT x >>= \unwrapped ->
    case unwrapped of
      Nothing -> return Nothing
      Just y -> runMaybeT (f y)
x `altBindMT` f = MaybeT $
  runMaybeT x >>= maybe (return Nothing) (runMaybeT . f)

failMT, returnMT :: (Monad m) => a -> MaybeT m a
returnMT = MaybeT . return . Just
failMT _ = MaybeT $ return Nothing

-- make it a monad
instance (Monad m) => Monad (MaybeT m) where
  return = returnMT
  (>>=) = bindMT
  fail = failMT

-- make it a Monad Transformer
instance MonadTrans MaybeT where
  lift m = MaybeT (Just `liftM` m)

instance (MonadIO m) => MonadIO (MaybeT m) where
  liftIO m = lift (liftIO m)

instance (MonadState s m) => MonadState s (MaybeT m) where
  get = lift get
  put k = lift (put k)

