**UICollectionView**

一个最简单的`UICollectionView`，它包含：

* **Cells:**用于展示内容的主体，cell的尺寸和内容可以各不相同。这个下面会详细介绍。

* **Supplementary Views:**追加视图，类似于`UITableView`每个`Seciton`的`Header View` 或者`Footer View`，用来标记`Section的View`。

* **Decoration Views:**装饰视图，完全跟数据没有关系的视图，负责给`cell`或者`supplementary Views`添加辅助视图用的，灵活性较强。

不管多么复杂的UIcollectionView都是由着三个部件组成的。

**UICollectionViewDataSource**

* section数量 ：`numberOfSectionsInCollectionView:`

* 某个section中多少个item：`collectionView:numberOfItemsInSection:`

* 对于某个位置的显示什么样的cell：`collectionView:cellForItemAtIndexPath:`

* 对于某个`section`显示什么样的`supplementary View`：`collectionView:viewForSupplementaryElementOfKind:atIndexPath:`
* 对于`Decoration Views`，提供的方法并不在`UICollectionViewDataSource`中，而是在`UICollectionViewLayout`中（因为它仅仅跟视图相关，而与数据无关）。

**UICollectionView子视图重用**

在`UIcollectionview`中不仅仅是`cell`的重用，`Supplementary View`和`Decoration View`也是可以并且应当被重用的.
