/// ModInt
struct ModInt(long P)
{
    import std.traits : isNumeric;
    import std.conv : to;

    long n;
    alias n this;

    this(T)(T n)
    if (isNumeric!T)
    {
        this.n = n.to!long % P;
    }

    invariant() {
        assert(this.n % P == this.n);
    }

    nothrow
    ModInt!P opUnary(string op)()
    if (op == "++") {
        this.n = (this.n + 1) % P;
        return this;
    }
    nothrow
    ModInt!P opUnary(string op)()
    if (op == "--") {
        this.n = (this.n - 1) % P;
        return this;
    }

    pure nothrow
    ModInt!P opUnary(string op)()
    if (op != "++" && op != "--") {
        static if (op == "+") {
            return this;
        } else static if (op == "-") {
            return ModInt!P((-n) % P);
        } else static if (op == "~") {
            return ModInt!P((~n) % P);
        } else {
            static assert("Invali unary operator: " ~ op);
        }
    }

    nothrow
    ModInt!P opOpAssign(string op, T)(T rhs)
    if (isNumeric!T && op == "^^") {
        long x = this.n;
        long y = 1;
        long m = rhs.to!long;
        while (m) {
            if (m%2 == 1) y = y * x % P;
            x = x^^2 % P;
            m /= 2;
        }
        this.n = y;
        return this;
    }

    nothrow
    ModInt!P opOpAssign(string op, T)(T rhs)
    if (isNumeric!T && op != "^^") {
        mixin("this.n " ~ op ~ "= rhs.to!long;");
        this.n %= P;
        return this;
    }

    nothrow
    ModInt!P opOpAssign(string op)(ModInt!P rhs) {
        this.opOpAssign!op(rhs.n);
        return this;
    }

    pure nothrow
    ModInt!P opBinary(string op, T)(T rhs)
    if (isNumeric!T) {
        auto res = this;
        res.opOpAssign!op(rhs);
        return res;
    }

    pure nothrow
    ModInt!P opBinary(string op)(ModInt!P rhs) {
        return this.opBinary!op(rhs.n);
    }

    @property nothrow pure
    ModInt!P inv() {
        return this ^^ (P-2);
    }
}

enum P = 10L^^9+7;

unittest
{
    alias N = ModInt!P;
    auto n = N(42);
    assert(+n == 42);
    assert(-n == -42);
    assert(n+N(1) == 43);
    assert(n+1 == 43);
    assert(n-1 == 41);
    assert(n+P == n);
    assert(n*2 == 84);
    assert(n/2 == 21);

    ++n;
    assert(n == 43);
    --n;
    assert(n == 42);
    assert(n-- == 42);
    assert(n == 41);
    assert(n++ == 41);
    assert(n == 42);
}

unittest
{
    alias N = ModInt!P;
    auto n = N(42);
    assert(n^^3 == 74088);
    assert(n^^100 == 767668661);
}

unittest
{
    alias N = ModInt!P;
    auto n = N(42);
    assert(n * n.inv == 1);
    auto m = N(2);
    assert(n * m.inv == n / m);
}

unittest
{
    alias N = ModInt!5;
    auto n = N(42);
    assert(n == 2);
    assert(n+3 == 0);
    assert(n+4 == 1);   
}