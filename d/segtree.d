
/// [..)
struct SegTree(alias _fun, alias def, T)
if (is(typeof(def) : T))
{
    import std.functional : binaryFun;
    alias fun = binaryFun!_fun;

    ///
    this(size_t n, T[] ts) {
        this.n = 1;
        while (this.n < n) this.n *= 2;
        this.tree.length = this.n * 2 - 1;
        foreach (ref e; this.tree) e = def;
        foreach (i, e; ts) this.put(i, e);
    }

    ///
    void put(size_t i, T e) {
        i += this.n - 1;
        this.tree[i] = e;
        while (i > 0) {
            i = (i-1) / 2;
            this.tree[i] = fun(this.tree[i*2+1], this.tree[i*2+2]);
        }
    }

    ///
    T query(size_t a, size_t b) {
        T impl(size_t i, size_t l, size_t r) {
            if (r <= a || b <= l) return def;
            if (a <= l && r <= b) return this.tree[i];
            return fun(
                impl(i*2+1, l, (l+r)/2),
                impl(i*2+2, (l+r)/2, r)
            );
        }
        return impl(0, 0, this.n);
    }

private:
    size_t n;
    T[] tree;
}

///
SegTree!(f, def, T) seg_tree(alias f, alias def, T)(size_t n, T[] arr = [])
{
    return SegTree!(f, def, T)(n, arr);
}

///
SegTree!(f, def, T) seg_tree(alias f, alias def, T)(T[] arr)
{
    return SegTree!(f, def, T)(arr.length, arr);
}

unittest
{
    import std.stdio;
    auto arr = [1,2,3,0,9,8,7,3,4,1];
    auto rmq = seg_tree!("a < b ? a : b", int.max)(arr);

    assert(rmq.query(0, 10) == 0);
    assert(rmq.query(0, 3) == 1);
    assert(rmq.query(1, 3) == 2);
    assert(rmq.query(4, 7) == 7);
    assert(rmq.query(4, 5) == 9);

    rmq.put(4, 0);
    assert(rmq.query(4, 7) == 0);
    assert(rmq.query(4, 5) == 0);
}

unittest
{
    auto arr = [1,2,3,0,9,8,7,3,4,1];
    auto ss = seg_tree!("a + b", 0)(arr);

    assert(ss.query(0, 10) == 38);
    assert(ss.query(0, 3) == 6);
    assert(ss.query(1, 3) == 5);
    assert(ss.query(4, 7) == 24);
    assert(ss.query(4, 5) == 9);

    ss.put(4, 0);
    assert(ss.query(4, 7) == 15);
    assert(ss.query(4, 5) == 0);
}