class SegmentTree

  def initialize n, arr = [], init = 0, &block
    block = -> (a, b) { a + b } unless block_given?
    @fun = block
    @n = 1
    @n *= 2 while @n < n
    @init = init
    @tree = Array.new(@n*2-1) { init }
    arr.each.with_index do |a, i| put(i, a) end
  end

  def put i, e
    i += @n - 1
    @tree[i] = e
    while i > 0
      i = (i-1) / 2
      @tree[i] = @fun.(@tree[i*2+1], @tree[i*2+2])
    end
  end

  def query a, b
    @a = a
    @b = b
    _query 0, 0, @n
  end

  private

  def _query i, l, r
    return @init if r <= @a || @b <= l
    return @tree[i] if @a <= l && r <= @b
    @fun.(_query(i*2+1, l, (l+r)/2), _query(i*2+2, (l+r)/2, r))
  end
end