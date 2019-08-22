///
struct Matrix(N, size_t height, size_t width)
{
    N M;
    N[width][height] arr;

    this(N[width][height] arr, N M = 0) {
        this.arr = arr;
        this.M = M;
    }

    pure nothrow @nogc
    Matrix!(N, height, rhs_width) opBinary(string op, size_t rhs_width)(Matrix!(N, width, rhs_width) rhs) {
        static if (op == "*") {
            N[rhs_width][height] res;
            foreach (y; 0..height) {
                foreach (x; 0..rhs_width) {
                    foreach (i; 0..width) {
                        auto s = this.arr[y][i] * rhs.arr[i][x];
                        if (this.M) s %= this.M;
                        res[y][x] += s;
                        if (this.M) res[y][x] %= this.M;
                    }
                }
            }
            return Matrix!(N, height, rhs_width)(res, this.M);
        } else static if (op == "+") {
            N[rhs_width] res;
            foreach (y; 0..height) {
                foreach (x; 0..rhs_width) {
                    res[y][x] = this.arr[y][x] + rhs.arr[y][x];
                    if (this.M) res[y][x] %= this.M;
                }
            }
            return Matrix!(N, height, rhs_width)(res, this.M);
        } else {
            static assert(0, "Operator "~op~" not implemented");
        }
    }

    pure nothrow @nogc
    Matrix!(N, height, width) opBinary(string op)(N n) {
        static if (op == "^^" && height == width) {
            N[width][height] rr;
            foreach (i; 0..width) rr[i][i] = 1;
            auto r = Matrix!(height, width)(rr, M);
            auto x = this;
            while (n) {
                if (n%2 == 1) r = r * x;
                x = x * x;
                n /= 2;
            }
            return r;
        } else {
            static assert(0, "Operator "~op~" not implemented");
        }
    }
}

Matrix!(N, h, w) matrix(N, size_t h, size_t w)(N[w][h] arr, N M = 0)
{
    return Matrix!(h, w)(arr, M);
}