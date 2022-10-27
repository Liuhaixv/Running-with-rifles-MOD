关于汉化的字体缺失问题, 字体都是和png图片对应，由于汉化字库较少，所以无法显示所有汉字
汉化文件在fonts中
汉化文件为.fontdef及其对应png图片
025,050,100后缀应该是指字号

有关.fontdef的用法见下链接
https://www.ogre3d.org/docs/manual18/manual_44.html

例:glyph u77 0.714518 0.855469 0.720703 0.869466
具体参数意思为
glyph 文字对应的unicode编码 (图片左上角坐标x, y) (图片右下角坐标x, y)

字体导出图片软件(来自AS脚本官网网站)
https://www.angelcode.com/products/bmfont/

目测汉化是个大坑，有三个分辨率，分辨率长宽首先要一样，所以分辨率应该是8的倍数,才能保证比例正确
建议设为4800*4800