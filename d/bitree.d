
/// [..), 1-origin
struct BITree(alias _fun, alias init, T)
if (is(typeof(init) : T))
{
    import std.functional : binaryFun;
    alias fun = binaryFun!_fun;

    ///
    this(size_t n, T[] ts) {
        this.n = n;
        this.tree.length = n+1;
        foreach (ref e; this.tree) e = init;
        foreach (i, t; ts) this.put(i+1, t);
    }

    /// This method does not replace the element but applies old one and new one to the `fun`.
    void put(size_t i, T e) {
        while (i <= this.n) {
            this.tree[i] = fun(this.tree[i], e);
            i += i & -i;
        }
    }

    ///
    T query(size_t i) {
        auto r = init;
        while (i > 0) {
            r = fun(r, this.tree[i]);
            i -= i & -i;
        }
        return r;
    }

private:
    size_t n;
    T[] tree;
}

/// The `init` value is used for the `query` method as first value,
/// so you can not use this argument to initialise the tree.
/// In other words, this is identity element.
BITree!(fun, init, T) bitree(alias fun, alias init, T)(size_t n, T[] ts = [])
{
    return BITree!(fun, init, T)(n, ts);
}

///
BITree!(fun, init, T) bitree(alias fun, alias init, T)(T[] ts)
{
    return BITree!(fun, init, T)(ts.length, ts);
}

unittest
{
    auto arr = [1,2,3,4,5,6,7,8,9];
    auto tree = bitree!("a + b", 0)(arr);

    assert(tree.query(9) == 45);
    assert(tree.query(2) == 3);
    assert(tree.query(1) == 1);
    assert(tree.query(5) == 15);
    assert(tree.query(6) == 21);
}

unittest
{
    auto arr = [5,2,3,9,8,0,7,3,4,1];
    auto tree = bitree!("a < b ? a : b", int.max)(arr);

    assert(tree.query(1) == 5);
    assert(tree.query(2) == 2);
    assert(tree.query(3) == 2);
    assert(tree.query(5) == 2);
    assert(tree.query(6) == 0);
    assert(tree.query(8) == 0);
    assert(tree.query(10) == 0);
}