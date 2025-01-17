# XML 简单介绍

这里为了方便某些没听说过 XML 的人快速了解 XML 的大致语法是什么, 所以很多细节方面的问题我会直接忽略, 那么, 就此开始吧:

## 定义

这里摘抄一下:
> XML 指可扩展标记语言(eXtensible Markup Language).  
> XML 被设计用来传输和存储数据, 不用于表现和展示数据, HTML 则用来表现数据.

XML 是一种以格式化储存数据的语言, 在 `msbuild` 中它就被用来以格式化的方式描述整个项目的信息.

## 节点, 特性

一段很基础的 XML 可能是这个样子的:

```xml
<books>
    <book id="123">这是第一本书</book>
    <book id="456">这是第二本书</book>
    <book id="114">这是第三本书</book>
    <book id="514">这是不知道第几本书</book>
</books>
```

这段 XML 用中文解释起来是这样的:

首先我们定义了一个**节点**, 它的名字叫做 "books", 它有很多**子节点**, 分别是:

- 一个 "book" **节点**, 它的 id **特性**是 123, 它的内容是 "这是第一本书"
- 一个 "book" **节点**, 它的 id **特性**是 456, 它的内容是 "这是第二本书"
- 一个 "book" **节点**, 它的 id **特性**是 114, 它的内容是 "这是第三本书"
- 一个 "book" **节点**, 它的 id **特性**是 514, 它的内容是 "这是不知道第几本书"

在这里, 最外层的 "books" 以及里面的 "book" 都称为**节点**, 其中 "books" 节点内部有很多 "book" 节点, 而 "book" 节点内部只有一串文本.
每个 "book" 节点都有一个叫做 id 的**特性**(有时也叫做**属性**, 不过注意别与 C# 的属性/特性相混淆).  

在语法层面上, 一个节点以 <名字> 开始声明, 在叙述完它的内容后以 &lt;/名字&gt; 结束.  
属性则在节点名称之后以空格分隔排列: <名字 属性1="值1" 属性2="值2">, 属性的值需要由 `"` 包裹.
对于一些没有内部内容的节点, 我们可以使用自结束语法:
```xml
<columns>
    <column id="xxx"/>
    <column qwq="6" awa="4"/>
    <column/>
    <column/>
    <column/>
</columns>
```

XML 允许以任意深度来嵌套, 所以我们可以这样来组装一个很复杂的 XML:

```xml
<books>
    <book id="123">
        <bookmarks page="1">114514</bookmarks>
        <bookmarks page="2">2333</bookmarks>
        <bookmarks page="123">838</bookmarks>
    </book>
    <book id="456">
        <bookmarks page="1">
            <picture src="http://example.com">
                this is alt
            </picture>
            <text content="text here!"/>
        </bookmarks>
        <bookmarks page="2">2333</bookmarks>
    </book>
</books>
```