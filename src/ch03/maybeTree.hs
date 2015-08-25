data MaybeTree a = Node a
  (Maybe (MaybeTree a))
  (Maybe (MaybeTree a))
  deriving (Show)

data MayTree a = MayTree (Maybe (a, MayTree a, MayTree a)) deriving (Show)

empty  = MayTree Nothing
left   = MayTree (Just("left", empty, empty))
right  = MayTree (Just("right", empty, empty))
parent = MayTree (Just("parent", left, right))

