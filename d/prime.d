enum PCNT = 10^^6;

bool[PCNT+1] PS;

void prime_init()
{
    PS[] = true;
    PS[0] = false;
    PS[1] = false;
    foreach (i; 2..PCNT+1) {
        if (PS[i]) {
            auto x = i*2;
            while (x <= PCNT) {
                PS[x] = false;
                x += i;
            }
        }
    }
}

Tuple!(N, N)[] prime_division(N)(N n)
{
    auto nn = n;
    Tuple!(N, N)[] res;
    for (N i = 2; i^^2 <= nn; ++i) {
        if (n%i == 0) {
            N cnt;
            while (n%i == 0) {
                ++cnt;
                n /= i;
            }
            res ~= tuple(i, cnt);
        }
    }
    if (n != cast(N)1) res ~= tuple(n, cast(N)1);
    return res;
}

N[] all_divisors(N)(N n)
{
    N[] ds;
    for (N r = 1; r^^2 <= n+1; ++r) if (n%r == 0) {
        ds ~= r;
        ds ~= n/r;
    }
    sort(ds);
    return ds;
}