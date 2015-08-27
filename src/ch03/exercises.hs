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
--
-- 10. Write a function that calculates the turn made by three 2D points and
-- returns a Direction. 59 comments
--
-- 11. Define a function that takes a list of 2D points and computes the
-- direction of each successive triple. Given a list of points [a,b,c,d,e], it
-- should begin by computing the turn made by [a,b,c], then the turn made by
-- [b,c,d], then [c,d,e]. Your function should return a list of Direction.
--
-- 12. Using the code from the preceding three exercises, implement Graham's
-- scan algorithm for the convex hull of a set of 2D points. You can find good
-- description of what a convex hull. is, and how the Graham scan algorithm
-- should work, on Wikipedia.
