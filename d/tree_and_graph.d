
int[][] read_tree_without_cost(int N) {
    auto T = new int[][N];
    foreach (_; 1..N) {
        auto ab = readln.split.to!(int[]);
        auto A = ab[0]-1;
        auto B = ab[1]-1;
        T[A] ~= B;
        T[B] ~= A;
    }
    return T;
}

int calc_diametor(int N, int[][] T) {
    alias S = Tuple!(int, "i", int, "c");

    auto DP = new int[](N);
    DP[] = int.max/3;
    DP[0] = 0;
    auto Q = heapify!"a.c < b.c"([S(0, 0)]);
    while (!Q.empty) {
        auto i = Q.front.i;
        auto c = Q.front.c;
        Q.popFront();
        if (DP[i] < c) continue;
        foreach (j; T[i]) if (DP[j] > c + 1) {
            DP[j] = c + 1;
            Q.insert(S(j, c + 1));
        }
    }
    int s, max_c;
    foreach (i, c; DP) if (c > max_c) {
        s = i.to!int;
        max_c = c;
    }
    Q.insert(S(s, 0));
    DP[] = int.max/3;
    DP[s] = 0;
    while (!Q.empty) {
        auto i = Q.front.i;
        auto c = Q.front.c;
        Q.popFront();
        if (DP[i] < c) continue;
        foreach (j; T[i]) if (DP[j] > c + 1) {
            DP[j] = c + 1;
            Q.insert(S(j, c + 1));
        }
    }
    return DP[].maxElement();
}

int[][] read_graph_without_cost!(directed = false)(int N, int M) {
    auto G = new int[][N];
    foreach (_; 0..M) {
        auto ab = readln.split.to!(int[]);
        auto A = ab[0]-1;
        auto B = ab[1]-1;
        G[A] ~= B;
        static if (!directed) G[B] ~= A;
    }
    return G;
}

alias Path = Tuple!(int, "to", long, "c");
int[][] read_graph!(directed = false)(int N, int M) {
    auto G = new Path[][N];
    foreach (_; 0..M) {
        auto abc = readln.split.to!(int[]);
        auto A = abc[0]-1;
        auto B = abc[1]-1;
        long C = abc[2];
        G[A] ~= P(B, C);
        static if (!directed) G[B] ~= P(A, C);
    }
    return G;
}