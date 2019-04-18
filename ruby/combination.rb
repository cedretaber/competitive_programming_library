class Combination

  attr_reader :P, :F, :RF

  def initialize p=10**9+7, size=10**5+50

    @P = p
    @P.freeze

    @F = Array.new(size)
    @RF = Array.new(size)

    @F[0] = @F[1] = 1
    2.upto(@F.length-1) do |i|
      @F[i] = (@F[i-1] * i) % @P
    end
    @F.freeze
    
    @RF[-1] = 1
    x = @F[-1]
    k = @P - 2
    while k > 0
      @RF[-1] = (@RF[-1] * x) % @P if k%2 == 1
      x = (x**2) % @P
      k /= 2
    end
    (@RF.length-2).downto(0) do |i|
      @RF[i] = (@RF[i+1] * (i+1)) % @P
    end
    @RF.freeze
  end
  
  def comb n, k
    n_b = @F[n]
    nk_b = @RF[n-k]
    k_b = @RF[k]
  
    nk_b_k_b = (nk_b * k_b) % @P
  
    (n_b * nk_b_k_b) % @P
  end
  
  def perm n, k
    n_b = @F[n]
    n_k_b = @RF[n-k]
  
    (n_b * n_k_b) % @P
  end
end