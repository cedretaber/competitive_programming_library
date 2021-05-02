
enum P = 10^^9L + 7;
long[10^^6 * 2 + 50] F, RF;

long pow(long x, long n) {
    long y = 1;
    while (n) {
        if (n%2 == 1) y = (y * x) % P;
        x = x^^2 % P;
        n /= 2;
    }
    return y;
}

long powmod(long x, long n, long m) {
    long y = 1;
    while (n) {
        if (n%2 == 1) y = (y * x) % m;
        x = x^^2 % m;
        n /= 2;
    }
    return y;
}

long inv(long x)
{
    return pow(x, P-2);
}

/// こちらは a と m とが互いに素でなくとも使える（計算量は同じ）。
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

/**
  * P を法とする階乗、逆元を予め計算しておく。
  */
void init()
{
    F[0] = F[1] = 1;
    foreach (i, ref x; F[2..$]) x = (F[i+1] * (i+2)) % P;

    {
        RF[$-1] = 1;
        auto x = F[$-1];
        auto k = P-2;
        while (k) {
            if (k%2 == 1) RF[$-1] = (RF[$-1] * x) % P;
            x = x^^2 % P;
            k /= 2;
        }
    }
    foreach_reverse(i, ref x; RF[0..$-1]) x = (RF[i+1] * (i+1)) % P;
}

/** 
  * ある数を法とする条件下で組み合わせを求める関数
  * 法とする数 P はグローバル変数として存在しなければならない
  * Params:
  *     n = 全体の数
  *     k = 選び出す数
  */
long comb(N)(N n, N k)
{
    if (k > n) return 0;
    auto n_b = F[n];    // n!
    auto nk_b = RF[n-k]; // 1 / (n-k)!
    auto k_b = RF[k];    // 1 / k!

    auto nk_b_k_b = (nk_b * k_b) % P; // 1 / (n-k)!k!

    return (n_b * nk_b_k_b) % P;  // n! / (n-k)!k!
}

/**
  * 順列を求める
  */
long perm(N)(N n, N k)
{
    if (k > n) return 0;
    auto n_b = F[n];
    auto n_k_b = RF[n-k];
    return (n_b * n_k_b) % P;
}

struct Combination(N, alias P, alias LEN)
{
    long[LEN] F, RF;

    this() {
        F[0] = F[1] = 1;
        foreach (i, ref x; F[2..$]) x = (F[i+1] * (i+2)) % P;

        {
            RF[$-1] = 1;
            auto x = F[$-1];
            auto k = P-2;
            while (k) {
                if (k%2 == 1) RF[$-1] = (RF[$-1] * x) % P;
                x = x^^2 % P;
                k /= 2;
            }
        }
        foreach_reverse(i, ref x; RF[0..$-1]) x = (RF[i+1] * (i+1)) % P;
    }

    long comb(N n, N k) {
        if (k > n) return 0;
        auto n_b = F[n];    // n!
        auto nk_b = RF[n-k]; // 1 / (n-k)!
        auto k_b = RF[k];    // 1 / k!

        auto nk_b_k_b = (nk_b * k_b) % P; // 1 / (n-k)!k!

        return (n_b * nk_b_k_b) % P;  // n! / (n-k)!k!
    }

    long perm(N n, N k) {
        if (k > n) return 0;
        auto n_b = F[n];
        auto n_k_b = RF[n-k];
        return (n_b * n_k_b) % P;
    }
}

Combination!(N, P, LEN) combination(N = long, P = 10^^9+7, LEN = 10^^6+50)()
{
    return Combination!(N, P, LEN)();
}

Combination!(P, LEN) combination(P = 10^^9+7, LEN = 10^^6+50)()
{
    return Combination!(long, P, LEN)();
}
