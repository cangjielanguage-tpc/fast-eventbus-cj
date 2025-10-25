import { systemDateTime } from '@kit.BasicServicesKit';
import {test_register_Entry,test_unregister_Entry,test_publish_Entry} from './fasteventbus_entry'
import taskpool from '@ohos.taskpool';
@Entry
@Component
struct Index {
  @State message: string = 'fasteventbus bench hybrid project ';
  private firstBtnAnchor = 'HelloWorld';  // 第一个按钮的锚点ID

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .margin({top: 30})
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
        })
      this.button(
        'test register(1,10,100,1000,10000)',
        (): void => test_register_Entry(),
        this.firstBtnAnchor
      )
      this.button(
        'test unregister(1,10,100,1000,10000)',
        (): void => test_unregister_Entry(),
        'btn_testregister'
      )
      this.button(
        'test publish(1,10,100,1000,10000)',
        (): void => test_publish_Entry(),
        'btn_testunregister'
      )
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  button(text: string, onclick: () => void, prevAnchorId: string) {
    Button(text)
      .id( `btn_${text.split('(')[0].replace(' ', '')}`)
      .height(40)
      .width('80%')
      .type(ButtonType.Capsule)
      .fontColor(0xFFFFFFFF)
      .backgroundColor(0x007DFF)  // 补充背景色，避免透明
      .margin({ top: 10 })
      .alignRules({
        top: { anchor: prevAnchorId, align: VerticalAlign.Bottom },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .onClick(()=>{
        onclick()
        this.message = `${text} 测试完成`;
      })
      // .onClick(async () => {
      //   // 主线程快速更新UI状态
      //   this.message = `${text} 测试中...`;
      //
      //   try {
      //     // 关键：在后台线程执行耗时任务
      //     await taskpool.execute(onclick);
      //     this.message = `${text} 测试完成`;
      //   } catch (error) {
      //     this.message = `${text} 测试失败: ${error}`;
      //   }
      // })
  }
}