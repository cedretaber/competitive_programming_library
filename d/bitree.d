
/// ..), 0-origin
struct BITree(alias _fun, alias E, T)
if (is(typeof(E) : T))
{
    import std.functional : binaryFun;
    alias OP = binaryFun!_fun;

    ///
    this(size_t n, T[] ts) {
        this.n = n;
        this.tree.length = n+1;
        foreach (ref e; this.tree) e = E;
        foreach (i, t; ts) this.update(i, t);
    }

    /// This method does not replace the element but applies old one and new one to the `OP`.
    void update(size_t i, T e) {
        i += 1;
        while (i <= this.n) {
            this.tree[i] = OP(this.tree[i], e);
            i += i & -i;
        }
    }

    ///
    T query(size_t i) {
        auto r = E;
        while (i > 0) {
            r = OP(r, this.tree[i]);
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
auto bitree(alias fun, alias init, T)(size_t n, T[] ts = [])
{
    return BITree!(fun, init, T)(n, ts);
}

///
auto bitree(alias fun, alias init, T)(T[] ts)
{
    return BITree!(fun, init, T)(ts.length, ts);
}

auto sum_bitree(T)(size_t n, T[] ts = [])
{
    return bitree!("a + b", cast(T)0, T)(n, ts);
}

auto sum_bitree(T)(T[] ts)
{
    return sum_bitree!T(ts.length, ts);
}

auto max_bitree(T)(size_t n, T[] ts = [])
{
    return bitree!("a > b ? a : b", T.min, T)(n, ts);
}

auto max_bitree(T)(T[] ts)
{
    return max_bitree!T(ts.length, ts);
}

auto min_bitree(T)(size_t n, T[] ts = [])
{
    return bitree!("a < b ? a : b", T.max, T)(n, ts);
}

auto min_bitree(T)(T[] ts)
{
    return min_bitree!T(ts.length, ts);
}

unittest
{
    auto arr = [1,2,3,4,5,6,7,8,9];
    auto tree = bitree!("a + b", 0)(arr);

    assert(tree.query(9) == 45);
    assert(tree.query(2) == 3);
    assert(tree.query(1) == 1);
    assert(tree.query(4) == 10);
    assert(tree.query(5) == 15);
    assert(tree.query(6) == 21);

    tree.update(4, 5);
    assert(tree.query(9) == 50);
    assert(tree.query(4) == 10);
    assert(tree.query(5) == 20);

    tree.update(4, -5);
    assert(tree.query(9) == 45);
    assert(tree.query(4) == 10);
    assert(tree.query(5) == 15);
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

    tree.update(1, 1);
    assert(tree.query(1) == 5);
    assert(tree.query(2) == 1);
    assert(tree.query(3) == 1);

    tree.update(1, 0);
    assert(tree.query(1) == 5);
    assert(tree.query(2) == 0);
    assert(tree.query(3) == 0);

    tree.update(1, 1);
    assert(tree.query(1) == 5);
    assert(tree.query(2) == 0);
    assert(tree.query(3) == 0);
}

unittest
{
    auto arr = [1,2,3,4,3,4,5];
    
    auto s1 = sum_bitree(arr);
    assert(s1.query(3) == 6);
    assert(s1.query(7) == 22);

    auto s2 = max_bitree(arr);
    assert(s2.query(3) == 3);
    assert(s2.query(5) == 4);
    assert(s2.query(7) == 5);

    arr = [5,4,3,5,4,1,2,3];
    auto s3 = min_bitree(arr);
    assert(s3.query(5) == 3);
    assert(s3.query(8) == 1);
}