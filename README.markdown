# Punycode conversion Framework for IDN domains.

This is a wrapper for [libidn](http://www.gnu.org/software/libidn/) witch is required to build the framework.

## Build Instructions (libida)

1\. Get the [source](http://ftp.gnu.org/gnu/libidn/)

2\. Unpack it and cd in to the source

3\. Compile and install:

    ./configure --enable-static --disable-shared
    make
    make install

## Paths

Make sure you have *libidn.a* in /usr/local/lib/ and *punycode.h* in /usr/local/include

## License

Do whatever you want with it..