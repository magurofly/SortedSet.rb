# https://atcoder.jp/contests/abc217/submissions/28825909

main = -> {
  L, Q = gets.split.map(&:to_i)
  s = SortedSet.new([0, L])
  Q.times do
    c, x = gets.split.map(&:to_i)
    case c
    when 1
      s << x
    when 2
      puts s.gt(x) - s.lt(x)
    end
  end
}

# paste SortedSet.rb here

main.call