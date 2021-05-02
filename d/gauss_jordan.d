import std.bitmanip;

struct BitMatrix
{
    int H, W;
    BitArray[] val;

    this(int n, int m) {
        H = n;
        W = m;
        val.length = H;
        foreach (ref row; val) {
            row = BitArray(new bool[W]);
        }
    }

    ref BitArray opIndex(size_t i) {
        return val[i];
    }
}

int gauss_jordan(ref BitMatrix A, bool is_extended = false)
{
    int rank = 0;

    foreach (col; 0..A.W) {
        if (is_extended && col == A.W - 1) break;
        int pivot = -1;
        foreach (row; rank..A.H) {
            if (A[row][col]) {
                pivot = row;
                break;
            }
        }
        if (pivot == -1) continue;

        swap(A[pivot], A[rank]);

        foreach (row; 0..A.H) {
            if (row != rank && A[row][col]) A[row] ^= A[rank];
        }
        ++rank;
    }

    return rank;
}

int linear_equation(BitMatrix A, int[] b, out int[] res)
{
    auto n = A.H, m = A.W;
    auto M = BitMatrix(n, m + 1);

    foreach (i; 0..n) {
        foreach (j; 0..m) M[i][j] = A[i][j];
        M[i][m] = b[i];
    }

    auto rank = gauss_jordan(M, true);

    foreach (row; rank..n) if (M[row][m]) return false;

    res.length = n;
    res[] = 0;
    foreach (i; 0..rank) res[i] = M[i][m];
    return rank;
}