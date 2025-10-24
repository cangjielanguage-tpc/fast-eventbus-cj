import { systemDateTime } from '@kit.BasicServicesKit';
import {test_addF64_Entry,test_register_Entry} from './fasteventbus_entry'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        this.button('test addF64', () => {
          test_addF64_Entry()
        })
        this.button('test register', () => {
          test_register_Entry()
        })
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  button(text: string, onclick: (() => void) | undefined) {
    Button(text)
      .height(40)// 高度
      .width('80%')// 宽度
      .type(ButtonType.Capsule)// 圆角
      .fontColor(0xFFFFFFFF)// 文本颜色
      // .backgroundColor(backGroupColor)// 背景颜色
      .margin({ top: 5, bottom: 5 })// 外边距
      .align(Alignment.Center)// 内容对齐方式
      .fontSize(16)// 字体大小
      .onClick(() => {
        this.message = `${text} ${systemDateTime.getTime()}`
        if (onclick) {
          onclick()
        }
      })
  }
}