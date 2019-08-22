
/// 二分探索を行う関数
/// 渡す関数は「左側に入る条件」
/// 返り値は「境界の左側の index 」
/// 空配列を渡した場合、全て右側に入る場合は -1 を返す
/// 全て左側に入る場合は配列の最後の要素の添字を返す
template bsearch(alias fun) {

    import std.functional: unaryFun;
    alias f = unaryFun!fun;

    int bsearch(T)(T[] arr) {
        if (arr.empty) return -1;

        if (!f(arr[0])) return -1;

        if (f(arr[$-1])) return arr.length.to!int - 1;

        int l, r = arr.length.to!int - 1;
        while (l+1 < r) {
            auto m = (l+r)/2;
            if (f(arr[m])) {
                l = m;
            } else {
                r = m;
            }
        }
        return l;
    }
}