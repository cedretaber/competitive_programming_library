import std.stdio;

/// [..)
/// 注意！　与える関数は、例えば「最大値を求める」なら "a > b ? a : b" となる。 "a > b" ではない！！
struct SegTree(alias fun, alias E, T)
if (is(typeof(E) : T))
{
    import std.functional : binaryFun;
    alias OP = binaryFun!fun;

    ///
    this(size_t n, T[] ts) {
        this.n = 1;
        while (this.n < n) this.n *= 2;
        this.tree.length = this.n * 2 - 1;
        foreach (ref e; this.tree) e = E;
        foreach (i, e; ts) this.update(i, e);
    }

    ///
    void replace(size_t i, T e) {
        i += this.n - 1;
        this.tree[i] = e;
        while (i > 0) {
            i = (i-1) / 2;
            this.tree[i] = OP(this.tree[i*2+1], this.tree[i*2+2]);
        }
    }

    ///
    void update(size_t i, T e) {
        replace(i, OP(e, tree[i + this.n - 1]));
    }

    ///
    T query(size_t a, size_t b) {
        T impl(size_t i, size_t l, size_t r) {
            if (r <= a || b <= l) return E;
            if (a <= l && r <= b) return this.tree[i];
            return OP(
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
auto seg_tree(alias f, alias E, T)(size_t n, T[] arr = [])
{
    return SegTree!(f, E, T)(n, arr);
}

///
auto seg_tree(alias f, alias E, T)(T[] arr)
{
    return SegTree!(f, E, T)(arr.length, arr);
}

auto sum_seg_tree(T)(size_t n, T[] arr = [])
{
    return seg_tree!("a + b", 0, T)(n, arr);
}

auto sum_seg_tree(T)(T[] arr)
{
    return sum_seg_tree!T(arr.length, arr);
}

auto max_seg_tree(T)(size_t n, T[] arr = [])
{
    return seg_tree!("a > b ? a : b", T.min, T)(n, arr);
}

auto max_seg_tree(T)(T[] arr)
{
    return max_seg_tree!T(arr.length, arr);
}

auto min_seg_tree(T)(size_t n, T[] arr = [])
{
    return seg_tree!("a < b ? a : b", T.max, T)(n, arr);
}

auto min_seg_tree(T)(T[] arr)
{
    return min_seg_tree!T(arr.length, arr);
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

    rmq.replace(4, 0);
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

    ss.replace(4, 0);
    assert(ss.query(4, 7) == 15);
    assert(ss.query(4, 5) == 0);
}

unittest
{
    auto arr = [1,2,3,4,5,6,7,8,9];
    auto ss = seg_tree!("a + b", 0)(arr);

    assert(ss.query(2, 5) == 12);
    ss.update(3, 4);
    assert(ss.query(2, 5) == 16);
}

unittest
{
    import std.stdio;
    auto arr = [1,2,3,1,2,3,4];

    auto s1 = sum_seg_tree(arr);
    assert(s1.query(1, 5) == 8);

    auto s2 = max_seg_tree(arr);
    assert(s2.query(2, 5) == 3);

    auto s3 = min_seg_tree(arr);
    assert(s3.query(2, 5) == 1);
}

/// 遅延セグ木
/// [..)
/// 注意！　与える関数は、例えば「最大値を求める」なら "a > b ? a : b" となる。 "a > b" ではない！！
/**
  * opt: T + T = T
  * opu: U + U = U
  * add: T + U = T
  * MUL: U * U = U
  * E:   T
  */
struct LazySegTree(alias opt, alias opu, alias _add, alias mul, alias E, alias F, T, U)
if (is(typeof(E) : T) && is(typeof(F) : U))
{
    import std.functional : binaryFun;
    alias OPT = binaryFun!opt;
    alias OPU = binaryFun!opu;
    alias ADD = binaryFun!_add;
    alias MUL = binaryFun!mul;

    ///
    this(size_t n, T[] ts) {
        this.n = 1;
        while (this.n < n) this.n *= 2;
        this.tree.length = this.n * 2 - 1;
        foreach (ref e; this.tree) e = E;
        foreach (i, e; ts) this.replace(i, e);
        this.ltree.length = this.n * 2 - 1;
        foreach (ref f; this.ltree) f = F;
    }

    ///
    void replace(size_t i, T e) {
        i += this.n - 1;
        this.tree[i] = e;
        while (i > 0) {
            i = (i-1) / 2;
            this.tree[i] = OPT(this.tree[i*2+1], this.tree[i*2+2]);
        }
    }

    ///
    void update(size_t i, T e) {
        replace(i, OPT(e, tree[i + this.n - 1]));
    }

    void update(size_t a, size_t b, U e) {
        void impl(size_t i, size_t l, size_t r) {
            eval(i, l, r);
            if (r <= a || b <= l) return;
            if (a <= l && r <= b) {
                ltree[i] = OPU(ltree[i], e);
                eval(i, l, r);
                return;
            }
            impl(i*2+1, l, (l+r)/2);
            impl(i*2+2, (l+r)/2, r);
            tree[i] = OPT(tree[i*2+1], tree[i*2+2]);
        }
        impl(0, 0, this.n);
    }

    ///
    T query(size_t a, size_t b) {
        T impl(size_t i, size_t l, size_t r) {
            eval(i, l, r);
            if (r <= a || b <= l) return E;
            if (a <= l && r <= b) return this.tree[i];
            return OPT(
                impl(i*2+1, l, (l+r)/2),
                impl(i*2+2, (l+r)/2, r)
            );
        }
        return impl(0, 0, this.n);
    }

private:
    size_t n;
    T[] tree;
    U[] ltree;

    void eval(size_t i, size_t l, size_t r) {
        if (ltree[i] == F) return;

        import std.conv;
        tree[i] = ADD(tree[i], MUL(ltree[i], (r-l).to!U));
        if (i < this.n - 1) {
            ltree[2*i+1] = OPU(ltree[2*i+1], ltree[i]);
            ltree[2*i+2] = OPU(ltree[2*i+2], ltree[i]);
        }
        ltree[i] = F;
    }
}

///
auto lazy_seg_tree(alias opt, alias opu, alias add, alias mul, alias E, alias F, T, U)(size_t n, T[] arr = [])
{
    return LazySegTree!(opt, opu, add, mul, E, F, T, T)(n, arr);
}

///
auto lazy_seg_tree(alias opt, alias opu, alias add, alias mul, alias E, alias F, T, U)(T[] arr)
{
    return LazySegTree!(opt, opu, add, mul, E, F, T, T)(arr.length, arr);
}

///
auto lazy_sum_seg_tree(T)(size_t n, T[] arr = [])
{
    enum f = "a + b";
    return lazy_seg_tree!(f, f, f, "a * b", 0, 0, T, T)(n, arr);
}

///
auto lazy_sum_seg_tree(T)(T[] arr)
{
    return lazy_sum_seg_tree!T(arr.length, arr);
}

/// In this tree, the `update` methods will replace it's elements by the given argument.
auto lazy_min_seg_tree(T)(size_t n, T[] arr = [])
{
    enum f = "a < b ? a : b";
    return lazy_seg_tree!(f, (_, a) => a, (_, a) => a, (a, _) => a, T.max, 0, T, T)(n, arr);
}

auto lazy_min_seg_tree(T)(T[] arr)
{
    return lazy_min_seg_tree!T(arr.length, arr);
}

unittest
{
    import std.stdio;
    auto arr = [1,2,3,4,5,6];

    auto ss = lazy_sum_seg_tree(arr);
    assert(ss.query(0, 6) == 21);
    assert(ss.query(1, 5) == 14);
    assert(ss.query(0, 3) == 6);
    ss.update(1, 5, 3);
    assert(ss.query(0, 6) == 33);
    assert(ss.query(1, 5) == 26);
    assert(ss.query(0, 3) == 12);
}

unittest
{
    import std.stdio;

    auto arr = [1,2,3,4,1,2,3];

    auto ss = lazy_min_seg_tree(arr);
    assert(ss.query(0, 7) == 1);
    assert(ss.query(2, 4) == 3);
    assert(ss.query(3, 4) == 4);
    ss.update(4, 6, 5);
    assert(ss.query(2, 4) == 3);
    assert(ss.query(4, 7) == 3);
    ss.update(0, 7, 10);
    assert(ss.query(0, 7) == 10);
}