
/**
 * 最大マッチング用二部グラフのD言語実装
 * 増加路を探索し、無くなった時点で最大マッチングとするアルゴリズムを採用しています。
 * 使い方:
 * 1. コンストラクタ引数には、二部グラフの左右の要素の要素数を入れます
 * 2. add_edgeメソッドで要素と要素の間に経路を張ります
 * 3. maximum_matchingメソッドでその二部グラフの最大マッチングを求めます
 */
struct Graph(T)
{
    /// 二部グラフの左右の要素のそれぞれの数
    T L, R;
    /// 二部グラフの経路
    T[][] adj;

    /// 左右の要素数を指定してグラフを作る
    this(T L, T R)
    {
        this.L = L;
        this.R = R;
        adj.length = L + R;
    }

    /// グラフに経路を追加する
    void add_edge(T u, T v)
    {
        adj[u] ~= v+L;
        adj[v+L] ~= u;
    }

    /// グラフの最大マッチングを求める
    T maximum_matching()
    {
        T[] visited, meta;
        visited.length = L;
        meta.length = L + R;
        meta[] = -1;

        bool augment(T u) {
            if (visited[u]) return false;
            visited[u] = true;
            foreach (w; adj[u]) {
                auto v = meta[w];
                if (v < 0 || augment(v)) {
                    meta[u] = w;
                    meta[w] = u;
                    return true;
                }
            }
            return false;
        }

        auto match = 0;
        foreach (u; 0..L) {
            visited[] = 0;
            if (augment(u)) ++match;
        }
        return match;
    }
}