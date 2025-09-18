#import "@preview/cuti:0.3.0": show-cn-fakebold
#import "@preview/codly:1.3.0": *
#import "@preview/i-figured:0.2.4"

#let 字号 = (
  初号: 42pt,
  小初: 36pt,
  一号: 26pt,
  小一: 24pt,
  二号: 22pt,
  小二: 18pt,
  三号: 16pt,
  小三: 15pt,
  四号: 14pt,
  中四: 13pt,
  小四: 12pt,
  五号: 10.5pt,
  小五: 9pt,
  六号: 7.5pt,
  小六: 6.5pt,
  七号: 5.5pt,
  小七: 5pt,
)

#let 字体 = (
  宋体: ((name: "Times New Roman", covers: "latin-in-cjk"), "SimSun"),
  黑体: ((name: "Arial", covers: "latin-in-cjk"), "SimHei"),
  楷体: ((name: "Times New Roman", covers: "latin-in-cjk"), "KaiTi"),
  仿宋: ((name: "Times New Roman", covers: "latin-in-cjk"), "FangSong"),
  等宽: (
    (name: "Monaspace Neon", covers: "latin-in-cjk"),
    (name: "Consolas", covers: "latin-in-cjk"),
    "Sarasa Mono SC",
    "SimHei",
  ),
)

#let style(it) = {
  // 第三方包
  show: show-cn-fakebold
  show: codly-init.with()
  show figure: i-figured.show-figure.with(numbering: "1-1")
  show math.equation.where(block: true): i-figured.show-equation.with(numbering: "(1-1)")

  // 辅助函数
  let array-at(arr, pos) = {
    arr.at(calc.min(pos, arr.len()) - 1)
  }

  // 设置代码块格式
  codly(
    zebra-fill: none,
    display-name: false,
    number-align: right,
    number-placement: "outside",
  )
  // plain text 无行号
  show raw.where(block: true, lang: none): local.with(number-format: none)

  // 行内代码
  show raw.where(block: false): box.with(
    fill: luma(240),
    inset: (x: 0.6em),
    outset: (x: -0.2em, y: 0.3em),
    radius: 0.3em,
  )

  // 字体
  set text(font: 字体.宋体, size: 字号.小四)
  show raw: set text(font: 字体.等宽)
  show raw.where(block: true): set text(size: 10pt)

  // 页面
  set page(
    margin: (x: 1.5cm, y: 2cm),
    paper: "a4",
    // 页眉
    header: context {
      let header = ""
      if calc.odd(counter(page).get().at(0)) {
        header = document.title
      } else {
        header = document.description
      }

      set text(size: 字号.小五)
      set align(center)
      stack(header, v(0.6em), line(length: 100%))
    },
    // 页脚
    footer: context {
      set text(size: 字号.小五)
      set align(center)
      counter(page).display("1 / 1", both: true)
    },
  )

  // 行距和段间距
  set par(leading: 1em, spacing: 1.4em)

  // 标题
  show heading: it => {
    let heading-size = (字号.三号, 字号.四号, 字号.小四)
    set text(size: array-at(heading-size, it.level))
    set block(above: 2em, below: 1.5em)
    it
  }
  set heading(numbering: "1.1", supplement: "节")

  // 线
  set line(stroke: 0.5pt)

  // 下划线
  set underline(offset: 0.2em)

  // 项目
  set terms(separator: "：")

  // 图片
  set image(height: 20%)

  // figure 样式
  show figure.where(kind: image): set figure(supplement: "图")
  show figure.where(kind: table): {
    set figure(supplement: "表")
    set figure.caption(position: top)
  }

  show figure: pad.with(y: 0.5em)

  // 目录标题
  set outline(title: "目录")

  it
}

// 标题
#let title(it) = {
  set align(center)
  text(size: 字号.三号, weight: "bold", it)
}

// 缩进段落
#let p(it, all: true) = {
  set par(first-line-indent: (amount: 2em, all: all))

  // 为列表、代码等添加缩进
  let indent = block.with(inset: (left: 2em))
  show enum: indent
  show list: indent
  show terms: indent
  show raw.where(block: true): indent
  it
}

// 下划线项目
#let u(it) = {
  h(0.6em)
  underline(extent: 0.6em, it)
}
