class MaximumMatching
  
  def initialize l, r
    @L = l
    @R = r
    @adj = Array.new(l + r) { [] }
  end

  def add u, v
    @adj[u] << v + @L
    @adj[v + @L] << u
  end

  def maximum_matching
    @visited = Array.new(@L)
    @meta = Array.new(@L + @R) { -1 }

    match = 0
    @L.times do |u|
      @visited.fill false
      match += 1 if augment u
    end
    match
  end

  private

  def augment u
    return false if @visited[u]
    @visited[u] = true

    @adj[u].each do |w|
      v = @meta[w]
      if v < 0 || augment(v)
        @meta[u] = w
        @meta[w] = u
        return true
      end
    end

    false
  end
end