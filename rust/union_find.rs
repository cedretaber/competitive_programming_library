struct UnionFind {
    tree: Vec<usize>,
    rank: Vec<usize>,
}

impl UnionFind {
    fn new(n: usize) -> UnionFind {
        UnionFind {
            tree : (0..n).collect::<Vec<_>>(),
            rank : vec![0;n],
        }
    }

    fn parent(&mut self, x: usize) -> usize {
        if x == self.tree[x] {
            x
        } else {
            let p = self.tree[x];
            let q = self.parent(p);
            self.tree[x] = q;
            q
        }
    }

    fn is_same(&mut self, a: usize, b: usize) -> bool {
        self.parent(a) == self.parent(b)
    }

    fn unite(&mut self, a: usize, b: usize) -> bool {
        let a = self.parent(a);
        let b = self.parent(b);
        if a == b {
            return false;
        }

        if self.rank[a] > self.rank[b] {
            self.tree[b] = a;
        } else {
            self.tree[a] = b;
            if self.rank[a] == self.rank[b] {
                self.rank[b] += 1;
            }
        }
        true
    }
}