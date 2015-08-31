`lines` is a function common to most languages. It relies on reading a file in
"text mode" in order to work.

Text mode provides a special behavior when we read and write files depending
on the OS. In Windows it translates "\r\n" to "\n" whent reading a file, and
reverses the process when writing. No special behaviour occurs on Unix-like
systems.

This means that reading a file on one platform that was written on the other
will most likely making some kind of a mess. `lines "a\r\nb"` in Windows returns
`["a", "b"]` while returning `["a\r","b"]` on a unix-like box.

