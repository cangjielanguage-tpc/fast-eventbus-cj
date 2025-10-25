import {test_register,test_unregister,test_publish,EventTs,clearContainerByEventTypeName} from '@cangjie-tpc/fasteventbus_hybrid'
import { systemDateTime } from '@kit.BasicServicesKit';
import hilog from '@ohos.hilog';
import {loopCounts} from './constants'



// @Concurrent
export function test_register_Entry(){
  let nu = 0;
  @Concurrent
  let onEvent = (e: EventTs) => {
    nu++;
  }
  @Concurrent
  let publish = (e: EventTs) => {
    onEvent(e);
  }
  //调用胶水层cjLib接口
  let name = "intType"
  for (let count of loopCounts) {
    const  startTime = systemDateTime.getTime(true)
    for(let i = 0;i < count;i++){
      test_register(name,onEvent,publish)
    }
    const  endTime = systemDateTime.getTime(true)
    const costPerOp = (endTime - startTime) / count; // 单次操作耗时（纳秒）
    hilog.info(0x001,'bench',`register_${count}: ${costPerOp.toFixed(2)} ns/op`)
    nu = 0 //计数器拨回到0，防止数据过大，导致内存问题
    clearContainerByEventTypeName(name)
  }
}
// @Concurrent
export function test_unregister_Entry(){
  let nu = 0;
  let onEvent = (e: EventTs) => {
    nu++;
  }
  let publish = (e: EventTs) => {
    onEvent(e);
  }
  //调用胶水层cjLib接口
  let name = "intType"
  for (let count of loopCounts) {
    for(let i = 0;i < count;i++){
      test_register(name,onEvent,publish)
    }
    const  startTime = systemDateTime.getTime(true)
    for(let i = 0;i < count;i++){
      test_unregister(name,onEvent,publish)
    }
    const  endTime = systemDateTime.getTime(true)
    const costPerOp = (endTime - startTime) / count; // 单次操作耗时（纳秒）
    hilog.info(0x001,'bench',`unregister_${count}: ${costPerOp.toFixed(2)} ns/op`)
    nu = 0 //计数器拨回到0，防止数据过大，导致内存问题
    clearContainerByEventTypeName(name)//取消订阅为性能，直接将id置为none，让cj垃圾回收器回收，测试需在执行完一个场景后主动clear，不影响下一个场景的执行
  }
}
// @Concurrent
export function test_publish_Entry(){
  let nu = 0;

  let onEvent = (e: EventTs) => {
    nu++;
  }
  let publish = (e: EventTs) => {
    onEvent(e);
  }
  //调用胶水层cjLib接口
  let name = "intType"
  for (let count of loopCounts) {
    for(let i = 0;i < count;i++){
      test_register(name,onEvent,publish)
    }
    const  startTime = systemDateTime.getTime(true)
    for(let i = 0;i < count;i++){
      test_publish(name,onEvent,publish)
    }
    const  endTime = systemDateTime.getTime(true)
    const costPerOp = (endTime - startTime) / count; // 单次操作耗时（纳秒）
    hilog.info(0x001,'bench',`publish_${count}: ${costPerOp.toFixed(2)} ns/op`)
    nu = 0 //计数器拨回到0，防止数据过大，导致内存问题
    clearContainerByEventTypeName(name)
  }
}