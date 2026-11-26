#import "style.typ": *
#show: style

// 设置文档元信息
#set document(title: "边缘智能计算综述调研", author: "XXX", description: "文档的主题（如：XX题目）")

// 设置正文样式
#show: body.with(indent: true)

// 注意：下面正文中提到的格式要求已经由模板正确设置了，不需要再额外调整

// 封面
#{
  set align(center)
  v(5em)
  image("assets/logo.png")
  text(font: 字体.黑体, size: 32pt, weight: "bold")[大 作 业 报 告 书]
  v(9em)

  box(width: 90%, grid(
    row-gutter: 1.2em,
    item("题　目", "（自拟）"),
    item("课　程", "边缘智能计算"),
    item("学　院", "人工智能与计算机学院"),
    item("专　业", "人工智能系"),
    item("班　级", ""),
    item("姓　名", ""),
    item("学　号", ""),
    item("授课老师", ""),
  ))
}
#pagebreak()


// 中文摘要
#{
  set align(center)
  title("XXX的综述(二号宋体)")
  text(size: 字号.小五)[(江南大学人工智能与计算机学院)]
}
#{
  set par(spacing: 1.5em)
  show: noindent

  text[摘要：]
  [XXX (五号宋体)]
  parbreak()

  text[关键字：]
  [XXX (五号宋体)]
}
#pagebreak()


// 英文摘要
#{
  set align(center)
  title("Title in English (二号宋体)")
  text(size: 字号.小五)[(Jiangnan University, School of Artificial Intelligence and Computer Science)]
}
#{
  set par(spacing: 1.5em)
  show: noindent

  text[Abstract：]
  [XXX (五号宋体)]
  parbreak()

  text[Keywords：]
  [XXX (五号宋体)]
}
#pagebreak()


// 目录
#outline()
#pagebreak()


// 正文
= 引言

== 二级标题（可选）

\

XXX (正文五号宋体)

\

可以包含以下内容（供参考）：

+ 研究背景：介绍研究课题的整体背景，说明选题的起因或来源。
+ 研究目的：明确本次调研的目标，指明报告的核心问题。
+ 综述结构：简述报告的章节安排，为读者提供阅读导向。

= 背景与意义

== 二级标题（可选）

\

XXX (正文五号宋体)

\

可以包含以下内容（供参考）：

+ 课题背景：介绍课题相关领域的发展历程或现状，强调其重要性。
+ 研究意义：从理论意义和实际应用两个方面，说明本课题的研究价值和现实意义。
+ 关键问题：明确当前研究中亟待解决的问题，为后续分析奠定基础。

= 研究现状

== 二级标题（可选）

\

XXX (正文五号宋体)

\

可以包含以下内容（供参考）：

+ 国内外研究现状：对比国内外在该领域的研究进展和成果，注重引用权威文献。
+ 代表性工作总结：详细分析几项具有代表性的研究工作，包括其方法、结论和意义。
+ 研究方法对比：列出相关研究中使用的不同方法或技术的优缺点对比（可配表格）。

= 现状分析

== 二级标题（可选）

\

XXX (正文五号宋体)

\

*本章节为加分项！*可以包含以下内容（供参考）：

+ 优势与不足：结合调研结果，分析当前研究的优势、局限性和不足之处。
+ 问题讨论：对调研中发现的关键问题或争议点进行总结，并提出个人见解。
+ 图表展示：适当使用图表（如统计图、对比表）清晰展示分析结果

= 总结与展望

== 二级标题（可选）

\

XXX (正文五号宋体)

\

可以包含以下内容（供参考）：

+ 研究总结：简要归纳报告的主要研究成果和贡献。
+ 未来展望：结合研究领域的最新发展，提出未来研究方向或应用场景的可能性。

// 实际填写时应该去除掉 full: true，保证文献在正文被引用过
#bibliography("ref.bib", full: true, style: "gb-7714-2015-numeric")
