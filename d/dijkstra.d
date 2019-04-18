
/**
 * ダイクストラ法を用いたグラフの最短経路探索の実装
 * 使い方:
 * V頂点E辺のグラフに対して、
 * 1. コンストラクタ引数には頂点数Nを与えます（必要であれば ∞ を意味する「コストの最大値」を与えます）
 * 2. add メソッドで元、先、重みを与えて辺を追加します
 * 3. run メソッドに始点と終点を与えて、最短経路のコストを計算します
 *    run メソッドは状態を破壊的に変更するので、1度しか使えません
 */
struct Dijkstra(N = int) {

private:
    alias To = Tuple!(N, "to", N, "cost", N, "min_cost");

    To[][] TS;
    N max_size;

public:
    this(N size, N max_size) {
        this.TS.length = size;
        this.max_size = max_size;
    }

    this(N size) {
        this(size, N.max);
    }

    void add(N from, N to, N cost) {
        this.TS[from] ~= To(to, cost, this.max_size);
    }

    N run(N start, N goal) {

        import std.container : heapify;

        foreach (ref node; this.TS[start]) {
            node = To(node.to, node.cost, node.cost);
        }
        auto store = this.TS[start];
        auto Q = heapify!"a.min_cost > b.min_cost"(store, store.length);
        while (!Q.empty) {
            auto head = Q.front;
            if (head.to == goal) {
                return head.min_cost;
            }
            Q.popFront();
            foreach (ref next; TS[head.to]) {
                if (next.min_cost > head.min_cost + next.cost) {
                    next = To(next.to, next.cost, head.min_cost + next.cost);
                    Q.insert(next);
                }
            }
        }
        return -1;
    }
}