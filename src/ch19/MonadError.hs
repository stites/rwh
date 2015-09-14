{-# LANGUAGE MultiParamTypeClasses, FunctionalDependencies #-}

class (Monad m) => MonadError e m | m -> e where
  throwError :: e {- which is the error to throw -} -> m a
  catchError :: m a {-action to run-} -> (e -> m a) {-err-handler-} -> m a

class Error a where
  noMsg :: a -- create an exception with no message
  strMsg :: String -> a -- create an exception with a message
