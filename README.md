# SortedSet.rb

[tatyam](https://github.com/tatyam-prime/) さんの [SortedSet](https://github.com/tatyam-prime/SortedSet) を Ruby に移植しました。

## ドキュメント

### SortedSet

特に断りがない場合、 N は要素数を指します。

#### `SortedSet.new(a = [])`

Enumerable から SortedSet を作ります。重複がなく、かつソートされていれば O(N) 、そうでなければ O(N log N) です。

#### `a`

SortedSet の中身です。配列（バケット）の配列になっていて、中には要素が昇順に並んでいます。各バケットには要素が存在することが保証されます。

#### `size`

要素数を返します。 O(1) です。

#### `empty?`

空かどうか判定します。 O(1) です。

#### `include?(x)`

`x` が含まれるか判定します。 O(√N) です。

#### `add(x)`, `self << x`

要素を追加します。 `x` がすでに含まれている場合は失敗します。 O(√N) です。

`add(x)` は、要素の追加に成功した場合 `true` を、そうでない場合 `false` を返します。

`self << x` は追加の成功・失敗を問わず `self` を返します。

#### `discard(x)`, `delete(x)`

要素を削除します。 `x` が含まれていない場合は失敗します。 O(√N) です。

要素の削除に成功した場合は `true` を、そうでない場合 `false` を返します。

#### `lt(x)` / `le(x)` / `gt(x)` / `ge(x)`

`x` より小さい / 以下 / より大きい / 以上で 最小 / 最大 の要素を返します。存在しなければ `nil` を返します。 O(√N) です。

#### `self[x]`

小さい方から `x` 番目（ 0-based index ）の要素を返します。存在しなければ `nil` を返します。 O(√N) です。

 `x < 0 かつ -x < size` の場合は、大きい方から `1-x` 番目の要素を返します。

#### `self.index(x)`

`x` より小さい要素の個数を返します。 O(√N) です。

#### `self.rindex(x)`, `self.index_right(x)`

`x` 以下の要素の個数を返します。 O(√N) です。

### SortedMultiset

TODO: 移植する