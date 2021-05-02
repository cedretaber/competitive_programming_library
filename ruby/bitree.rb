class BinaryIndexTree

  def initialize n, arr = [], init = 0, &block
    block = ->(a, b) { a + b } unless block_given?
    @fun = block

    @n = n
    @init = init

    @tree = Array.new(n+1) { init }
    arr.each.with_index(1) do |e, i|
      put(i, e)
    end
  end

  def put i, e
    while i <= @n
      @tree[i] = @fun.(@tree[i], e)
      i += i & -i
    end
  end

  def query i
    r = @init
    while i > 0
      r = @fun.(r, @tree[i])
      i -= i & -i
    end
    r
  end
end