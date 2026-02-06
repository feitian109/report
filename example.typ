#import "style.typ": *
// 中文乱数假文
#import "@preview/kouhu:0.2.0": kouhu
#show: style

// title 和 description 会被显示在页眉
#set document(title: "文档的类型（如：✕✕课程实验报告）", author: "✕✕✕", description: "文档的主题（如：✕✕实验）")

#title[我是标题]

#v(1em)

// 设置实验日期
#let date = datetime.today()

// 设置课程和个人信息
#grid(
  columns: (1fr, 1fr, 1fr),
  row-gutter: 1em,
  item("课程名称", "✕✕课程"), [], item("实验日期", date.display()),
  item("班级", "✕✕✕✕"), item("姓名", "✕✕✕"), item("学号", "✕✕✕✕✕"),
)

// 显示目录
#outline()

// 设置正文样式
#show: body.with(indent: true)

#let small-kouhu = kouhu(length: 30)
#let med-kouhu = kouhu(length: 100)

= 一级标题

== 二级标题

=== 三级标题 <section>

#med-kouhu

1. #small-kouhu
2. #small-kouhu

- #small-kouhu
- #small-kouhu

/ 某术语: 我是解释

/ 又一个术语: 我是解释

下面是代码块：
#raw(lorem(30), block: true)

```py
def example():
    print("Hello, World!")

"""
使用了 codly 渲染
"""
```

= 还是一级标题

表格测试（@tbl:tbl-test）：

#figure(
  table(
    columns: 2,
    [表头1], [表头2],
    [数据1], [数据2],
    [数据3], [数据4],
  ),
  caption: "测试表格",
) <tbl-test>

公式测试（@eqt:eq-test）：

$ E = m c^2 $ <eq-test>

章节引用，@section。
