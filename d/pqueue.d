
///
struct PriorityQueue(alias _fun, T) {
    import std.functional : binaryFun;
    import std.algorithm : swap;
    alias fun = binaryFun!_fun;

    ///
    this(T[] ts) {
        foreach (t; ts) enqueue(t);
    }

    ///
    PriorityQueue!(_fun, T) enqueue(T e) {
        if (this.tree.length == 0) this.tree.length = 1;
        if (this.tree.length == this.n) this.tree.length *= 2;
        this.tree[this.n] = e;
        auto i = this.n;
        this.n += 1;
        while (i) {
            auto j = (i-1)/2;
            if (fun(this.tree[i], this.tree[j])) {
                swap(this.tree[i], this.tree[j]);
                i = j;
            } else break;
        }
        return this;
    }

    alias insertFront = enqueue;
    alias insert = enqueue;

    ///
    T dequeue() {
        auto ret = this.tree[0];
        this.n -= 1;
        this.tree[0] = this.tree[this.n];
        this.tree = this.tree[0..$-1];
        size_t i;
        for (;;) {
            auto l = i*2+1;
            auto r = i*2+2;
            if (l >= this.n) break;
            size_t j;
            if (r >= this.n) {
                j = l;
            } else {
                j = fun(this.tree[r], this.tree[l]) ? r : l;
            }
            if (fun(this.tree[j], this.tree[i])) {
                swap(this.tree[i], this.tree[j]);
                i = j;
            } else break;
        }
        return ret;
    }

    ///
    @property
    T front() {
        return this.tree[0];
    }

    ///
    @property
    bool empty() {
        return this.n == 0;
    }

    ///
    void popFront() {
        this.dequeue();
    }

    alias removeFront = popFront;

    ///
    @property
    size_t length() {
        return this.n;
    }

private:
    size_t n;
    T[] tree;
}

///
PriorityQueue!(fun, T) priority_queue(alias fun, T)(T[] ts = []) {
    return PriorityQueue!(fun, T)(ts);
}

unittest
{
    auto pq = priority_queue!"a < b"([1,4,5,8,2,7,3,9,6]);

    assert(pq.dequeue == 1);
    assert(pq.dequeue == 2);
    assert(pq.dequeue == 3);

    pq.enqueue(1);
    assert(pq.dequeue == 1);
}

unittest
{
    import std.algorithm;
    import std.range;

    auto pq = priority_queue!"a < b"([1,4,5,8,2,7,3,9,6]);
    assert(equal(pq, [1,2,3,4,5,6,7,8,9]));

    auto pq2 = priority_queue!"a > b"([1,4,5,8,2,7,3,9,6]);
    assert(equal(pq2, reverse([1,2,3,4,5,6,7,8,9])));
}

unittest
{
    auto pq = priority_queue!("a < b", int)();
    foreach (int i; 0..10^^6) {
        pq.enqueue(i);
    }

    assert(pq.length == 10^^6);

    foreach (int i; 0..10^^6) {
        assert(pq.dequeue() == i);
    }
}