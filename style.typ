#import "@preview/cuti:0.3.0": show-cn-fakebold
#import "@preview/codly:1.3.0"
#import "@preview/i-figured:0.2.4"

// 0. 设置字号、字体常量
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
  宋体: ((name: "libertinus serif", covers: "latin-in-cjk"), "SimSun"),
  黑体: ((name: "Arial", covers: "latin-in-cjk"), "SimHei"),
  楷体: ((name: "libertinus serif", covers: "latin-in-cjk"), "KaiTi"),
  仿宋: ((name: "libertinus serif", covers: "latin-in-cjk"), "FangSong"),
  等宽: (
    (name: "Monaspace Neon", covers: "latin-in-cjk"),
    (name: "Consolas", covers: "latin-in-cjk"),
    "Sarasa Mono SC",
    "SimHei",
  ),
)

#let style(it) = {
  // 1. 辅助函数
  let array-at(arr, pos) = {
    arr.at(calc.min(pos, arr.len()) - 1)
  }


  // 2. 第三方包设置
  // 启用伪粗体
  show: show-cn-fakebold

  // 设置 codly 格式
  show: codly.codly-init.with()
  codly.codly(
    zebra-fill: none,
    display-name: false,
    number-align: right,
    number-placement: "outside",
  )
  // plain text 不显示行号
  show raw.where(block: true, lang: none): codly.local.with(number-format: none)

  // 设置 figure 和公式编号
  show figure: i-figured.show-figure.with(numbering: "1-1")
  show math.equation.where(block: true): i-figured.show-equation.with(numbering: "(1-1)")
  show heading: i-figured.reset-counters


  // 3. 主要设置
  // 页面
  set page(
    margin: (x: 1.5cm, y: 2cm),
    paper: "a4",
    // 页眉
    header: context {
      // 通过文档元信息设置奇偶页不同页眉
      let header = ""
      if calc.odd(counter(page).get().at(0)) {
        header = document.title
      } else {
        header = document.description
      }

      set text(size: 字号.小五)
      set align(center)
      stack(header, v(0.5em), line(length: 100%))
    },
    // 页脚
    footer: context {
      set text(size: 字号.小五)
      set align(center)
      counter(page).display("1 / 1", both: true)
    },
  )

  // 字体
  set text(font: 字体.宋体, size: 字号.小四, lang: "zh", top-edge: "ascender", bottom-edge: "descender")
  // 代码字体
  show raw: set text(font: 字体.等宽, top-edge: "cap-height", bottom-edge: "baseline")
  show raw.where(block: true): set text(size: 10pt)

  // 行距和段间距
  set par(leading: 0.65em, spacing: 1.2em)
  show outline.entry: set block(above: 0.65em / 2)

  // 标题
  show heading: it => {
    let heading-size = (字号.三号, 字号.四号, 字号.小四)
    set text(size: array-at(heading-size, it.level))
    it
  }
  set heading(numbering: "1.1", supplement: "节")

  // 线
  set line(stroke: 0.5pt)
  // 表格边框
  set table(stroke: 0.5pt)
  // 下划线
  set underline(stroke: 0.5pt, offset: 0.2em)

  // figure
  // 设置表格的 caption 在其上方显示
  show figure.where(kind: table): it => {
    set figure.caption(position: top)
    it
  }

  // 图片
  set image(height: 20%)

  it
}

// 4. 设置快捷函数
// 标题
#let title(it) = {
  set align(center)
  text(size: 字号.三号, weight: "bold", it)
}

// 键值对显示
#let item(k, v) = {
  text(weight: "bold", k + "：")
  h(0.5em)
  underline(extent: 0.5em, v)
}

// 缩进段落
#let p(it, all-indent: true) = {
  set par(first-line-indent: (amount: 2em, all: all-indent))

  // 为列表、代码等添加缩进
  let indent = block.with(inset: (left: 2em))
  show enum: indent
  show list: indent
  show terms: indent
  show raw.where(block: true): indent
  it
}
