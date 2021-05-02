
/** 拡張ユークリッド法
 *  ax + by = gcd(a, b) の解を求める
 *  （一般に、 ax + by = c が解を持つ時、 n を整数として c = n * gcd(a, b) である。）
 *  戻り値のタプルは (x, y, gcd(a, b)) である（ただし gcd(a, b) はマイナスをとり得る）。
 */
Tuple!(long, long, long) ext_gcd(long a, long b)
{
    if (b == 0) {
        return tuple(1L, 0L, a);
    }
    auto res = ext_gcd(b, a % b);
    auto y = res[0];
    auto x = res[1];
    auto d = res[2];
    return tuple(x, y - (a / b) * x, d);
}

long modinv(long a, long m)
{
    long b = m, u = 1, v = 0;
    while (b) {
        auto t = a / b;
        a -= t * b; swap(a, b);
        u -= t * v; swap(u, v);
    }
    u %= m;
    if (u < 0) u += m;
    return u;
}

/// √x 以下の最大の整数
long int_sqrt(long x)
{
    if (x < 0) return -1;
    if (x == 0) return 0;

    long l = 1, r = int.max.to!long + 1;
    while (l + 1 < r) {
        auto m = (l + r) / 2;
        if (m^^2 > x) {
            r = m;
        } else {
            l = m;
        }
    }
    
    return l;
}

/// n 以上の最小の m の倍数
long ceil_to(long n, long m)
{
    if (n >= 0) return (n + m - 1) / m * m;
    return -(-n / m) * m;
}

/// n 以下の最大の m の倍数
long floor_to(long n, long m)
{
    if (n >= 0) return n / m * m;
    return (n - m + 1) / m * m;
}