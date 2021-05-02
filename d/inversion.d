struct FenwickTree(T)
{
    import std.traits : isSigned, Unsigned;

    static if (isSigned!T)
    {
        alias U = Unsigned!T;
    }
    else
    {
        alias U = T;
    }
public:
    this(int n)
    {
        _n = n;
        data = new U[](n);
    }

    void add(int p, T x)
    {
        assert(0 <= p && p < _n);
        p++;
        while (p <= _n)
        {
            data[p - 1] += cast(U) x;
            p += p & -p;
        }
    }

    T sum(int l, int r)
    {
        assert(0 <= l && l <= r && r <= _n);
        return sum(r) - sum(l);
    }

private:
    int _n;
    U[] data;

    U sum(int r)
    {
        U s = 0;
        while (r > 0)
        {
            s += data[r - 1];
            r -= r & -r;
        }
        return s;
    }
}

long inversion(int[] arr)
{
    auto aa = arr.dup;
    sort(aa);
    int[int] am;
    foreach (i, a; aa) am[a] = i.to!int;

    alias E = Tuple!(int, "i", int, "n");
    E[] es;
    foreach (i, a; arr) es ~= E(i.to!int, am[a]);
    sort!"a.n > b.n"(es);

    auto bit = FenwickTree!int(arr.length.to!int);
    long res;
    foreach (e; es) {
        res += bit.sum(0, e.i);
        bit.add(e.i, 1);
    }
    return res;
}