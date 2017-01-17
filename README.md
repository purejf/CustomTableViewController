# CustomTableViewController

1. 封装tableView，带有tableView的控制器、tableViewCell

2. 厌烦每次都要写tableView的代理和数据源方法，厌烦每个带有tableView的列表控制器中加入重复代码（例如上拉加载、下拉刷新）

3. 封装一层tableView 例如对tableView某一行或者某一分组进行操作的时候不会崩溃（越界处理）、简化了tableView的方法的书写

4. 封装一层tableViewCell、直接类方法创建一个可复用的cell，不用在viewDidLoad里面进行注册之类的操作

5. 封装一个带有tableView的控制器， 实现诸多变化点，让其可高度化定制。

6. 封装一层tableViewHeaderFooterView 同理tableViewCell - -

7. 封装一个类似于于微信的会话列表中的可以滑动的cell，可以自定义滑动完成之后的按钮数量，使用方法类似于tableView的代理方法和数据源方法
