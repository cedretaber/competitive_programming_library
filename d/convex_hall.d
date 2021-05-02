
///
P[] convex_hull(P[] ps)
{
    auto n = ps.length;
    sort!"a.x == b.x ? a.y < b.y : a.x < b.x"(ps);
    size_t k;
    auto qs = new P[](n*2);

    foreach (i; 0..n) {
        while (k > 1 && (qs[k-1] - qs[k-2]).det(ps[i] - qs[k-1]) < 0) k--;
        qs[k++] = ps[i];
    }

    auto t = k;
    foreach_reverse (i; 0..n-1) {
        while (k > t && (qs[k-1] - qs[k-2]).det(ps[i] - qs[k-1]) < 0) k--;
        qs[k++] = ps[i];
    }

    qs.length = k - 1;
    return qs;
}