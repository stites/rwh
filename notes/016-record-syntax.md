With data up till now, we've had to write our own accessors for each of the
components. This sucks and record syntax comes with some extra sugar to save the
day!

Record syntax for data looks like this:

    data CustomerType = Customer {
      customerID      :: Integer,
      customerName    :: String,
      customerAddress :: [String]
    } deriving (Show)

this creates a data type, `CustomerType`, a value constructor, `Customer`, and
accessors: `customerId`, `customerName`, and `customerAddress`. These
accessors are just normal haskell functions attached to their parent scope.

This makes the value constructor a little more weighty w.r.t. construction, but
it could also be argued to be more readable, and flexible since ordering is not
required for the components:

    customer2 = Customer {
      customerID = 271828,
      customerAddress = [
        "1048576 Disk Drive",
        "Milpitas, CA 95134",
        "USA"
      ],
      customerName = "Jane Q. Citizen"
    }

