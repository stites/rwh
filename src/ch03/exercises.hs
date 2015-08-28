-- 8. Using the binary tree type that we defined earlier in this chapter,
-- write a function that will determine the height of the tree. The height is
-- the largest number of hops from the root to an Empty. For example, the tree
-- Empty has height zero; Node "x" Empty Empty has height one; Node "x" Empty
-- (Node "y" Empty Empty) has height two; and so on.

data Tree a = Node a (Tree a) (Tree a) | Empty
              deriving (Show)
treeHeight :: Tree a -> Integer
treeHeight Empty = 0
treeHeight (Node _ a Empty) = 1 + treeHeight a
treeHeight (Node _ Empty a) = 1 + treeHeight a
treeHeight (Node _ a b) = 1 + max ( treeHeight a ) ( treeHeight b )

-- 9. Consider three two-dimensional points a, b, and c. If we look at the
-- angle formed by the line segment from a to b and the line segment from b to
-- c, it either turns left, turns right, or forms a straight line. Define a
-- Direction data type that lets you represent these possibilities.

data Point = Point Integer Integer deriving (Show)
data Direction = DLeft | DStraight | DRight deriving (Eq, Show)

-- 12. Using the code from the preceding three exercises, implement Graham's
-- scan algorithm for the convex hull of a set of 2D points. You can find good
-- description of what a convex hull. is, and how the Graham scan algorithm
-- should work, on Wikipedia.

direction :: Point -> Point -> Point -> Direction
direction p1 p2 p3
        | cross p1 p2 p3 < 0 = DRight
        | cross p1 p2 p3 > 0 = DLeft
        | otherwise          = DStraight
        where cross (Point x1 y1) (Point x2 y2) (Point x3 y3) =
                    (x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)

