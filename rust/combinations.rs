fn powmod(mut x: i64, mut n: i64, p: i64) -> i64 {
    let mut y: i64 = 1;
    while n != 0 {
        if n%2 == 1 {
            y = (y * x) % p;
        }
        x = x.pow(2) % p;
        n /= 2;
    }
    y
}

#[cfg(test)]
mod tests {
    #[test]
    fn test() {
        const P: i64 = 1000000007;
        const L: usize = 100010;

        let mut f: Vec<i64> = vec![0; L];
        let mut rf: Vec<i64> = vec![0; L];
    
        f[0] = 1;
        f[1] = 1;
        for i in 2..L {
            f[i] = (f[i-1] * (i) as i64) % P;
        }
    
        rf[L-1] = 1;
        let mut x = f[L-1];
        let mut k = P-2;
        while k != 0 {
            if k%2 == 1 {
                rf[L-1] = (rf[L-1] * x) % P;
            }
            x = x.pow(2) % P;
            k /= 2;
        }
    
        for i in (0..L-1).rev() {
            rf[i] = (rf[i+1] * (i+1) as i64) % P;
        }
    
        let comb = |n: i64, k: i64| {
            if k > n {
                return 0;
            }
            let n_b = f[n as usize];
            let nk_b = rf[(n-k) as usize];
            let k_b = rf[k as usize];
            let nk_b_k_b = (nk_b * k_b) % P;
            (n_b * nk_b_k_b) % P
        };

        assert_eq!(comb(4, 2), 6);
        assert_eq!(comb(13, 8), 1287);
    }
}
